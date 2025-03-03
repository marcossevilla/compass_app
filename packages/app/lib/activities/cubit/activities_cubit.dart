import 'package:activity_repository/activity_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:logging/logging.dart';
import 'package:models/models.dart';

part 'activities_state.dart';

class ActivitiesCubit extends Cubit<ActivitiesState> {
  ActivitiesCubit({
    required ActivityRepository activityRepository,
    required ItineraryConfigRepository itineraryConfigRepository,
  }) : _log = Logger('ActivitiesCubit'),
       _activityRepository = activityRepository,
       _itineraryConfigRepository = itineraryConfigRepository,
       super(const ActivitiesState());

  final Logger _log;
  final ActivityRepository _activityRepository;
  final ItineraryConfigRepository _itineraryConfigRepository;

  Future<void> loadActivities() async {
    final config = _itineraryConfigRepository.itineraryConfig;

    final destinationRef = config.destination;
    if (destinationRef == null) {
      _log.severe('Destination missing in ItineraryConfig');
      throw Exception('Destination not found');
    }

    emit(
      state.copyWith(
        selectedActivities: {
          ...state.selectedActivities,
          ...config.activities.toSet(),
        },
      ),
    );

    try {
      emit(state.copyWith(status: ActivitiesStatus.loadingActivities));

      final activities = await _activityRepository.getByDestination(
        destinationRef,
      );

      final daytimeActivities = activities.where(
        (activity) => [
          TimeOfDay.any,
          TimeOfDay.morning,
          TimeOfDay.afternoon,
        ].contains(activity.timeOfDay),
      );

      final eveningActivities = activities.where(
        (activity) =>
            [TimeOfDay.evening, TimeOfDay.night].contains(activity.timeOfDay),
      );

      emit(
        state.copyWith(
          daytimeActivities: daytimeActivities.toList(),
          eveningActivities: eveningActivities.toList(),
          status: ActivitiesStatus.loadedActivities,
        ),
      );

      _log.fine(
        'Activities (daytime: ${daytimeActivities.length}, '
        'evening: ${eveningActivities.length}) loaded',
      );
    } on Exception catch (e) {
      _log.warning('Failed to load activities', e);
      emit(state.copyWith(status: ActivitiesStatus.failedLoadingActivities));
    }
  }

  /// Add [Activity] to selected list.
  void addActivity(String activityRef) {
    assert(
      (state.daytimeActivities + state.eveningActivities).any(
        (activity) => activity.ref == activityRef,
      ),
      'Activity $activityRef not found',
    );

    emit(
      state.copyWith(
        selectedActivities: {...state.selectedActivities, activityRef},
        status: ActivitiesStatus.loadedActivities,
      ),
    );

    _log.finest('Activity $activityRef added');
  }

  /// Remove [Activity] from selected list.
  void removeActivity(String activityRef) {
    assert(
      (state.daytimeActivities + state.eveningActivities).any(
        (activity) => activity.ref == activityRef,
      ),
      'Activity $activityRef not found',
    );

    emit(
      state.copyWith(
        selectedActivities: {
          ...state.selectedActivities.where(
            (activity) => activity != activityRef,
          ),
        },
      ),
    );

    _log.finest('Activity $activityRef removed');
  }

  void saveActivities() {
    try {
      final itineraryConfig = _itineraryConfigRepository.itineraryConfig;

      _itineraryConfigRepository.itineraryConfig = itineraryConfig.copyWith(
        activities: state.selectedActivities.toList(),
      );

      emit(state.copyWith(status: ActivitiesStatus.savedActivities));
    } on Exception catch (e) {
      _log.warning('Failed to store ItineraryConfig', e);
      emit(state.copyWith(status: ActivitiesStatus.failedSavingActivities));
    }
  }
}
