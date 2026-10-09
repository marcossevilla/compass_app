part of 'search_form_cubit.dart';

enum SearchFormStatus() {
  initial,
  loading,
  loaded,
  error,
  configSaved,
}

class const SearchFormState({
  final int guests = 0,
  final DateTime? startDate,
  final DateTime? endDate,
  final String? selectedContinent,
  final List<Continent> continents = const [],
  final SearchFormStatus status = SearchFormStatus.initial,
}) extends Equatable {
  /// True if the form is valid and can be submitted.
  bool get valid {
    return guests > 0 &&
        selectedContinent != null &&
        startDate != null &&
        endDate != null;
  }

  SearchFormState copyWith({
    int? guests,
    DateTime? startDate,
    DateTime? endDate,
    String? selectedContinent,
    List<Continent>? continents,
    SearchFormStatus? status,
  }) {
    return SearchFormState(
      guests: guests ?? this.guests,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedContinent: selectedContinent ?? this.selectedContinent,
      continents: continents ?? this.continents,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props {
    return [guests, startDate, endDate, selectedContinent, continents, status];
  }
}
