part of 'search_form_cubit.dart';

enum SearchFormStatus { initial, loading, loaded, error, configSaved }

class SearchFormState extends Equatable {
  const SearchFormState({
    this.guests = 0,
    this.dateRange,
    this.selectedContinent,
    this.continents = const [],
    this.status = SearchFormStatus.initial,
  });

  final int guests;
  final DateTimeRange? dateRange;
  final String? selectedContinent;
  final List<Continent> continents;
  final SearchFormStatus status;

  /// True if the form is valid and can be submitted.
  bool get valid {
    return guests > 0 && selectedContinent != null && dateRange != null;
  }

  SearchFormState copyWith({
    int? guests,
    DateTimeRange? dateRange,
    String? selectedContinent,
    List<Continent>? continents,
    SearchFormStatus? status,
  }) {
    return SearchFormState(
      guests: guests ?? this.guests,
      dateRange: dateRange ?? this.dateRange,
      selectedContinent: selectedContinent ?? this.selectedContinent,
      continents: continents ?? this.continents,
    );
  }

  @override
  List<Object?> get props {
    return [guests, dateRange, selectedContinent, continents, status];
  }
}
