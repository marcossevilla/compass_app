import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

void main() {
  group(SearchFormCubit, () {
    late ContinentRepository continentRepository;
    late ItineraryConfigRepository itineraryConfigRepository;

    const continents = [
      Continent(name: 'Europe', imageUrl: 'https://example.com/europe'),
      Continent(name: 'Asia', imageUrl: 'https://example.com/asia'),
    ];
    final startDate = DateTime(2026, 1, 10);
    final endDate = DateTime(2026, 1, 20);
    final itineraryConfig = ItineraryConfig(
      continent: 'Europe',
      startDate: startDate,
      endDate: endDate,
      guests: 2,
    );

    setUpAll(() {
      registerFallbackValue(const ItineraryConfig());
    });

    setUp(() {
      continentRepository = MockContinentRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
    });

    SearchFormCubit buildCubit() {
      return SearchFormCubit(
        continentRepository: continentRepository,
        itineraryConfigRepository: itineraryConfigRepository,
      );
    }

    test('initial state is $SearchFormState', () {
      expect(buildCubit().state, equals(const SearchFormState()));
    });

    group('load', () {
      blocTest<SearchFormCubit, SearchFormState>(
        'emits continents and itinerary config when successful',
        setUp: () {
          when(() => continentRepository.getContinents())
              .thenAnswer((_) async => continents);
          when(() => itineraryConfigRepository.itineraryConfig)
              .thenReturn(itineraryConfig);
        },
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => [
          const SearchFormState(status: SearchFormStatus.loading),
          const SearchFormState(
            status: SearchFormStatus.loading,
            continents: continents,
          ),
          SearchFormState(
            status: SearchFormStatus.loading,
            continents: continents,
            selectedContinent: 'Europe',
            startDate: startDate,
            endDate: endDate,
            guests: 2,
          ),
          SearchFormState(
            status: SearchFormStatus.loaded,
            continents: continents,
            selectedContinent: 'Europe',
            startDate: startDate,
            endDate: endDate,
            guests: 2,
          ),
        ],
      );

      blocTest<SearchFormCubit, SearchFormState>(
        'defaults guests to 0 when the stored config has no guests',
        setUp: () {
          when(() => continentRepository.getContinents())
              .thenAnswer((_) async => continents);
          when(() => itineraryConfigRepository.itineraryConfig)
              .thenReturn(const ItineraryConfig());
        },
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const [
          SearchFormState(status: SearchFormStatus.loading),
          SearchFormState(
            status: SearchFormStatus.loading,
            continents: continents,
          ),
          SearchFormState(
            status: SearchFormStatus.loaded,
            continents: continents,
          ),
        ],
      );

      blocTest<SearchFormCubit, SearchFormState>(
        'emits error when loading continents fails',
        setUp: () {
          when(() => continentRepository.getContinents())
              .thenThrow(Exception('oops'));
        },
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const [
          SearchFormState(status: SearchFormStatus.loading),
          SearchFormState(status: SearchFormStatus.error),
        ],
        verify: (_) {
          verifyNever(() => itineraryConfigRepository.itineraryConfig);
        },
      );

      blocTest<SearchFormCubit, SearchFormState>(
        'emits error when loading the itinerary config fails',
        setUp: () {
          when(() => continentRepository.getContinents())
              .thenAnswer((_) async => continents);
          when(() => itineraryConfigRepository.itineraryConfig)
              .thenThrow(Exception('oops'));
        },
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const [
          SearchFormState(status: SearchFormStatus.loading),
          SearchFormState(
            status: SearchFormStatus.loading,
            continents: continents,
          ),
          SearchFormState(
            status: SearchFormStatus.error,
            continents: continents,
          ),
        ],
      );
    });

    group('updateSelectedContinent', () {
      blocTest<SearchFormCubit, SearchFormState>(
        'emits the selected continent',
        build: buildCubit,
        act: (cubit) => cubit.updateSelectedContinent('Asia'),
        expect: () => const [SearchFormState(selectedContinent: 'Asia')],
      );
    });

    group('updateDateTimeRange', () {
      blocTest<SearchFormCubit, SearchFormState>(
        'emits the selected dates',
        build: buildCubit,
        act: (cubit) => cubit.updateDateTimeRange(startDate, endDate),
        expect: () => [SearchFormState(startDate: startDate, endDate: endDate)],
      );
    });

    group('incrementGuests', () {
      blocTest<SearchFormCubit, SearchFormState>(
        'emits guests increased by one',
        build: buildCubit,
        seed: () => const SearchFormState(guests: 1),
        act: (cubit) => cubit.incrementGuests(),
        expect: () => const [SearchFormState(guests: 2)],
      );
    });

    group('decrementGuests', () {
      blocTest<SearchFormCubit, SearchFormState>(
        'emits guests decreased by one',
        build: buildCubit,
        seed: () => const SearchFormState(guests: 2),
        act: (cubit) => cubit.decrementGuests(),
        expect: () => const [SearchFormState(guests: 1)],
      );
    });

    group('updateItineraryConfig', () {
      final seedState = SearchFormState(
        selectedContinent: 'Europe',
        startDate: startDate,
        endDate: endDate,
        guests: 2,
      );

      blocTest<SearchFormCubit, SearchFormState>(
        'stores the itinerary config and emits configSaved',
        build: buildCubit,
        seed: () => seedState,
        act: (cubit) => cubit.updateItineraryConfig(),
        expect: () => [
          seedState.copyWith(status: SearchFormStatus.configSaved),
        ],
        verify: (_) {
          verify(
            () => itineraryConfigRepository.itineraryConfig = itineraryConfig,
          ).called(1);
        },
      );

      blocTest<SearchFormCubit, SearchFormState>(
        'emits error when storing the itinerary config fails',
        setUp: () {
          when(() => itineraryConfigRepository.itineraryConfig = any())
              .thenThrow(Exception('oops'));
        },
        build: buildCubit,
        seed: () => seedState,
        act: (cubit) => cubit.updateItineraryConfig(),
        expect: () => [seedState.copyWith(status: SearchFormStatus.error)],
      );
    });
  });

  group(SearchFormState, () {
    test('supports value equality', () {
      expect(const SearchFormState(), equals(const SearchFormState()));
    });

    group('valid', () {
      test('returns true when all fields are set', () {
        expect(
          SearchFormState(
            guests: 1,
            selectedContinent: 'Europe',
            startDate: DateTime(2026),
            endDate: DateTime(2026, 2),
          ).valid,
          isTrue,
        );
      });

      test('returns false when a field is missing', () {
        expect(const SearchFormState().valid, isFalse);
      });
    });
  });
}
