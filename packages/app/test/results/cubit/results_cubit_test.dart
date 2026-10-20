import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/results/results.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

void main() {
  const europeDestination = Destination(
    ref: 'alps',
    name: 'Alps',
    country: 'Switzerland',
    continent: 'Europe',
    knownFor: 'Mountains',
    tags: ['Mountain'],
    imageUrl: 'https://example.com/alps.jpg',
  );
  const asiaDestination = Destination(
    ref: 'bali',
    name: 'Bali',
    country: 'Indonesia',
    continent: 'Asia',
    knownFor: 'Beaches',
    tags: ['Beach'],
    imageUrl: 'https://example.com/bali.jpg',
  );
  const config = ItineraryConfig(continent: 'Europe');

  group(ResultsCubit, () {
    late DestinationRepository destinationRepository;
    late ItineraryConfigRepository itineraryConfigRepository;

    setUpAll(() {
      registerFallbackValue(const ItineraryConfig());
    });

    setUp(() {
      destinationRepository = MockDestinationRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
      when(() => itineraryConfigRepository.itineraryConfig).thenReturn(config);
    });

    ResultsCubit buildCubit() => ResultsCubit(
      destinationRepository: destinationRepository,
      itineraryConfigRepository: itineraryConfigRepository,
    );

    test('initial state is $ResultsState', () {
      expect(buildCubit().state, equals(const ResultsState()));
    });

    group('search', () {
      blocTest<ResultsCubit, ResultsState>(
        'emits searching then searchCompleted with destinations '
        'filtered by continent',
        setUp: () {
          when(() => destinationRepository.getDestinations())
              .thenAnswer((_) async => [europeDestination, asiaDestination]);
        },
        build: buildCubit,
        act: (cubit) => cubit.search(),
        expect: () => const [
          ResultsState(
            itineraryConfig: config,
            status: ResultsStatus.searching,
          ),
          ResultsState(
            itineraryConfig: config,
            destinations: [europeDestination],
            status: ResultsStatus.searchCompleted,
          ),
        ],
      );

      blocTest<ResultsCubit, ResultsState>(
        'emits searching then searchFailure when loading fails',
        setUp: () {
          when(() => destinationRepository.getDestinations())
              .thenThrow(Exception('oops'));
        },
        build: buildCubit,
        act: (cubit) => cubit.search(),
        expect: () => const [
          ResultsState(
            itineraryConfig: config,
            status: ResultsStatus.searching,
          ),
          ResultsState(
            itineraryConfig: config,
            status: ResultsStatus.searchFailure,
          ),
        ],
      );
    });

    group('updateItineraryConfig', () {
      blocTest<ResultsCubit, ResultsState>(
        'stores the config and emits updatedConfig '
        'then restores the previous status',
        build: buildCubit,
        seed: () => const ResultsState(status: ResultsStatus.searchCompleted),
        act: (cubit) => cubit.updateItineraryConfig('alps'),
        expect: () => const [
          ResultsState(status: ResultsStatus.updatedConfig),
          ResultsState(status: ResultsStatus.searchCompleted),
        ],
        verify: (_) {
          verify(
            () => itineraryConfigRepository.itineraryConfig = config.copyWith(
              destination: 'alps',
              activities: [],
            ),
          ).called(1);
        },
      );

      blocTest<ResultsCubit, ResultsState>(
        'emits updateConfigFailure then restores the previous status '
        'when storing fails',
        setUp: () {
          when(() => itineraryConfigRepository.itineraryConfig = any())
              .thenThrow(Exception('oops'));
        },
        build: buildCubit,
        seed: () => const ResultsState(status: ResultsStatus.searchCompleted),
        act: (cubit) => cubit.updateItineraryConfig('alps'),
        expect: () => const [
          ResultsState(status: ResultsStatus.updateConfigFailure),
          ResultsState(status: ResultsStatus.searchCompleted),
        ],
      );
    });
  });
}
