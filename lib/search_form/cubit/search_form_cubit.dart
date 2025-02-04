import 'package:bloc/bloc.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:logging/logging.dart';

part 'search_form_state.dart';

class SearchFormCubit extends Cubit<SearchFormState> {
  SearchFormCubit({
    required ContinentRepository continentRepository,
    required ItineraryConfigRepository itineraryConfigRepository,
  })  : _log = Logger('SearchFormViewModel'),
        _continentRepository = continentRepository,
        _itineraryConfigRepository = itineraryConfigRepository,
        super(const SearchFormState());

  final Logger _log;
  final ContinentRepository _continentRepository;
  final ItineraryConfigRepository _itineraryConfigRepository;

  Future<void> load() async {
    try {
      emit(state.copyWith(status: SearchFormStatus.loading));
      await loadContinents();
      await loadItineraryConfig();
      emit(state.copyWith(status: SearchFormStatus.loaded));
    } on Exception {
      emit(state.copyWith(status: SearchFormStatus.error));
    }
  }

  Future<void> loadContinents() async {
    try {
      final continents = await _continentRepository.getContinents();
      emit(state.copyWith(continents: continents));
      _log.fine('Continents (${continents.length}) loaded');
    } on Exception catch (e) {
      _log.warning('Failed to load continents', e);
      rethrow;
    }
  }

  Future<void> loadItineraryConfig() async {
    try {
      final itineraryConfig = _itineraryConfigRepository.itineraryConfig;

      DateTimeRange? dateRange;

      if (itineraryConfig.startDate != null &&
          itineraryConfig.endDate != null) {
        dateRange = DateTimeRange(
          start: itineraryConfig.startDate!,
          end: itineraryConfig.endDate!,
        );
      }

      emit(
        state.copyWith(
          selectedContinent: itineraryConfig.continent,
          dateRange: dateRange,
          guests: itineraryConfig.guests ?? 0,
        ),
      );

      _log.fine('ItineraryConfig loaded');
    } on Exception catch (e) {
      _log.warning('Failed to load stored ItineraryConfig', e);
      rethrow;
    }
  }

  void updateSelectedContinent(String? continent) {
    emit(state.copyWith(selectedContinent: continent));
    _log.finest('Selected continent: $continent');
  }

  void updateDateTimeRange(DateTimeRange? dateTimeRange) {
    emit(state.copyWith(dateRange: dateTimeRange));
    _log.finest('Selected date range: $dateTimeRange');
  }

  void incrementGuests() {
    emit(state.copyWith(guests: state.guests + 1));
    _log.finest('Set guests number: ${state.guests + 1}');
  }

  void decrementGuests() {
    emit(state.copyWith(guests: state.guests - 1));
    _log.finest('Set guests number: ${state.guests - 1}');
  }

  void updateItineraryConfig() {
    try {
      _itineraryConfigRepository.itineraryConfig = ItineraryConfig(
        continent: state.selectedContinent,
        startDate: state.dateRange?.start,
        endDate: state.dateRange?.end,
        guests: state.guests,
      );
      emit(state.copyWith(status: SearchFormStatus.configSaved));
      _log.fine('ItineraryConfig saved');
    } on Exception catch (e) {
      _log.warning('Failed to store ItineraryConfig', e);
      emit(state.copyWith(status: SearchFormStatus.error));
    }
  }
}
