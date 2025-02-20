import 'package:bloc/bloc.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:logging/logging.dart';

part 'results_state.dart';

class ResultsCubit extends Cubit<ResultsState> {
  ResultsCubit({
    required DestinationRepository destinationRepository,
    required ItineraryConfigRepository itineraryConfigRepository,
  }) : _log = Logger('ResultsCubit'),
       _destinationRepository = destinationRepository,
       _itineraryConfigRepository = itineraryConfigRepository,
       super(const ResultsState());

  final Logger _log;
  final DestinationRepository _destinationRepository;
  final ItineraryConfigRepository _itineraryConfigRepository;

  Future<void> search() async {
    try {
      // Load current itinerary config.
      final config = _itineraryConfigRepository.itineraryConfig;
      emit(
        state.copyWith(
          itineraryConfig: config,
          status: ResultsStatus.searching,
        ),
      );

      final destinations = await _destinationRepository.getDestinations();
      emit(
        state.copyWith(
          destinations: [
            // Update the list of destinations.
            ...destinations.where(
              (destination) => destination.continent == config.continent,
            ),
          ],
          status: ResultsStatus.searchCompleted,
        ),
      );

      _log.fine('Destinations (${destinations.length}) loaded');
    } on Exception catch (e) {
      _log.warning('Failed to load destinations', e);
      emit(state.copyWith(status: ResultsStatus.searchFailure));
    }
  }

  Future<void> updateItineraryConfig(String destinationRef) async {
    assert(destinationRef.isNotEmpty, 'destinationRef should not be empty');

    final currentStatus = state.status;

    try {
      final itineraryConfig = _itineraryConfigRepository.itineraryConfig;
      _itineraryConfigRepository.itineraryConfig = itineraryConfig.copyWith(
        destination: destinationRef,
        activities: [],
      );
      emit(state.copyWith(status: ResultsStatus.updatedConfig));
    } on Exception catch (e) {
      _log.warning('Failed to store ItineraryConfig', e);
      emit(state.copyWith(status: ResultsStatus.updateConfigFailure));
    } finally {
      emit(state.copyWith(status: currentStatus));
    }
  }
}
