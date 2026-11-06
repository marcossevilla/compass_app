import 'package:activity_repository/activity_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/activities/activities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

Activity _activity(String ref, TimeOfDay timeOfDay) {
  return Activity(
    name: ref,
    description: 'description',
    locationName: 'location',
    duration: 1,
    timeOfDay: timeOfDay,
    familyFriendly: true,
    price: 1,
    destinationRef: 'alaska',
    ref: ref,
    imageUrl: 'https://example.com/$ref.jpg',
  );
}

void main() {
  final morning = _activity('morning', TimeOfDay.morning);
  final anytime = _activity('any', TimeOfDay.any);
  final afternoon = _activity('afternoon', TimeOfDay.afternoon);
  final evening = _activity('evening', TimeOfDay.evening);
  final night = _activity('night', TimeOfDay.night);

  group(ActivitiesCubit, () {
    late ActivityRepository activityRepository;
    late ItineraryConfigRepository itineraryConfigRepository;

    setUpAll(() {
      registerFallbackValue(const ItineraryConfig());
    });

    setUp(() {
      activityRepository = MockActivityRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
    });

    ActivitiesCubit buildCubit() {
      return ActivitiesCubit(
        activityRepository: activityRepository,
        itineraryConfigRepository: itineraryConfigRepository,
      );
    }

    test('initial state is $ActivitiesState', () {
      expect(buildCubit().state, equals(const ActivitiesState()));
    });

    group('loadActivities', () {
      test('throws when destination is missing', () {
        when(() => itineraryConfigRepository.itineraryConfig)
            .thenReturn(const ItineraryConfig());

        expect(buildCubit().loadActivities, throwsA(isA<Exception>()));
      });

      blocTest<ActivitiesCubit, ActivitiesState>(
        'emits loaded activities split by time of day',
        setUp: () {
          when(() => itineraryConfigRepository.itineraryConfig).thenReturn(
            const ItineraryConfig(destination: 'alaska', activities: ['any']),
          );
          when(() => activityRepository.getByDestination('alaska')).thenAnswer(
            (_) async => [morning, anytime, afternoon, evening, night],
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.loadActivities(),
        expect: () => [
          const ActivitiesState(selectedActivities: {'any'}),
          const ActivitiesState(
            selectedActivities: {'any'},
            status: ActivitiesStatus.loadingActivities,
          ),
          ActivitiesState(
            selectedActivities: const {'any'},
            daytimeActivities: [morning, anytime, afternoon],
            eveningActivities: [evening, night],
            status: ActivitiesStatus.loadedActivities,
          ),
        ],
      );

      blocTest<ActivitiesCubit, ActivitiesState>(
        'emits failedLoadingActivities when repository throws',
        setUp: () {
          when(() => itineraryConfigRepository.itineraryConfig)
              .thenReturn(const ItineraryConfig(destination: 'alaska'));
          when(() => activityRepository.getByDestination('alaska'))
              .thenThrow(Exception('oops'));
        },
        build: buildCubit,
        act: (cubit) => cubit.loadActivities(),
        expect: () => const [
          ActivitiesState(),
          ActivitiesState(status: ActivitiesStatus.loadingActivities),
          ActivitiesState(status: ActivitiesStatus.failedLoadingActivities),
        ],
      );
    });

    group('addActivity', () {
      blocTest<ActivitiesCubit, ActivitiesState>(
        'adds the activity to the selected list',
        build: buildCubit,
        seed: () => ActivitiesState(
          daytimeActivities: [morning],
          eveningActivities: [evening],
        ),
        act: (cubit) => cubit.addActivity('evening'),
        expect: () => [
          ActivitiesState(
            daytimeActivities: [morning],
            eveningActivities: [evening],
            selectedActivities: const {'evening'},
            status: ActivitiesStatus.loadedActivities,
          ),
        ],
      );
    });

    group('removeActivity', () {
      blocTest<ActivitiesCubit, ActivitiesState>(
        'removes the activity from the selected list',
        build: buildCubit,
        seed: () => ActivitiesState(
          daytimeActivities: [morning],
          eveningActivities: [evening],
          selectedActivities: const {'morning', 'evening'},
        ),
        act: (cubit) => cubit.removeActivity('morning'),
        expect: () => [
          ActivitiesState(
            daytimeActivities: [morning],
            eveningActivities: [evening],
            selectedActivities: const {'evening'},
          ),
        ],
      );
    });

    group('saveActivities', () {
      blocTest<ActivitiesCubit, ActivitiesState>(
        'stores selected activities and emits savedActivities',
        setUp: () {
          when(() => itineraryConfigRepository.itineraryConfig)
              .thenReturn(const ItineraryConfig(destination: 'alaska'));
        },
        build: buildCubit,
        seed: () => const ActivitiesState(selectedActivities: {'morning'}),
        act: (cubit) => cubit.saveActivities(),
        expect: () => const [
          ActivitiesState(
            selectedActivities: {'morning'},
            status: ActivitiesStatus.savedActivities,
          ),
        ],
        verify: (_) {
          verify(
            () => itineraryConfigRepository.itineraryConfig =
                const ItineraryConfig(
                  destination: 'alaska',
                  activities: ['morning'],
                ),
          ).called(1);
        },
      );

      blocTest<ActivitiesCubit, ActivitiesState>(
        'emits failedSavingActivities when storing fails',
        setUp: () {
          when(() => itineraryConfigRepository.itineraryConfig)
              .thenReturn(const ItineraryConfig(destination: 'alaska'));
          when(() => itineraryConfigRepository.itineraryConfig = any())
              .thenThrow(Exception('oops'));
        },
        build: buildCubit,
        act: (cubit) => cubit.saveActivities(),
        expect: () => const [
          ActivitiesState(status: ActivitiesStatus.failedSavingActivities),
        ],
      );
    });
  });
}
