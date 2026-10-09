part of 'results_cubit.dart';

enum ResultsStatus() {
  initial,
  searching,
  searchCompleted,
  searchFailure,
  updatedConfig,
  updateConfigFailure,
}

class const ResultsState({
  final List<Destination> destinations = const [],
  final ItineraryConfig itineraryConfig = const ItineraryConfig(),
  final ResultsStatus status = ResultsStatus.initial,
}) extends Equatable {
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
