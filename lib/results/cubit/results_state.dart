part of 'results_cubit.dart';

enum ResultsStatus {
  initial,
  searching,
  searchCompleted,
  searchFailure,
  updatedConfig,
  updateConfigFailure,
}

class ResultsState extends Equatable {
  const ResultsState({
    this.destinations = const [],
    this.itineraryConfig = const ItineraryConfig(),
    this.status = ResultsStatus.initial,
  });

  final List<Destination> destinations;
  final ItineraryConfig itineraryConfig;
  final ResultsStatus status;

  ResultsState copyWith({
    List<Destination>? destinations,
    ItineraryConfig? itineraryConfig,
    ResultsStatus? status,
  }) {
    return ResultsState(
      destinations: destinations ?? this.destinations,
      itineraryConfig: itineraryConfig ?? this.itineraryConfig,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [destinations, itineraryConfig, status];
}
