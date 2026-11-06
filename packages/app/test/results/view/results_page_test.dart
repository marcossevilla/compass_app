import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/results/results.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

class MockResultsCubit extends MockCubit<ResultsState>
    implements ResultsCubit {}

void main() {
  const destination = Destination(
    ref: 'alps',
    name: 'Alps',
    country: 'Switzerland',
    continent: 'Europe',
    knownFor: 'Mountains',
    tags: ['Mountain'],
    imageUrl: 'https://example.com/alps.jpg',
  );

  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group(ResultsPage, () {
    late DestinationRepository destinationRepository;
    late ItineraryConfigRepository itineraryConfigRepository;

    setUp(() {
      destinationRepository = MockDestinationRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
      when(() => itineraryConfigRepository.itineraryConfig)
          .thenReturn(const ItineraryConfig(continent: 'Europe'));
      when(() => destinationRepository.getDestinations())
          .thenAnswer((_) async => [destination]);
    });

    testWidgets('renders $ResultsView and starts searching', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: destinationRepository),
              RepositoryProvider.value(value: itineraryConfigRepository),
            ],
            child: const ResultsPage(),
          ),
        );
        await tester.pump();
      });

      expect(find.byType(ResultsView), findsOneWidget);
      verify(() => destinationRepository.getDestinations()).called(1);
      expect(find.byType(ResultCard), findsOneWidget);
    });
  });

  group(ResultsView, () {
    late ResultsCubit resultsCubit;
    late GoRouter goRouter;

    setUp(() {
      resultsCubit = MockResultsCubit();
      goRouter = MockGoRouter();
      when(() => goRouter.go(any())).thenAnswer((_) {});
      when(() => goRouter.pop<Object?>()).thenAnswer((_) {});
      when(() => resultsCubit.search()).thenAnswer((_) async {});
      when(() => resultsCubit.updateItineraryConfig(any()))
          .thenAnswer((_) async {});
    });

    Future<void> pumpSubject(WidgetTester tester) {
      return mockNetworkImages(() async {
        await tester.pumpApp(
          BlocProvider.value(value: resultsCubit, child: const ResultsView()),
          goRouter: goRouter,
        );
      });
    }

    testWidgets('renders a progress indicator while searching', (tester) async {
      when(() => resultsCubit.state)
          .thenReturn(const ResultsState(status: ResultsStatus.searching));

      await pumpSubject(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ResultsSearchBar), findsOneWidget);
    });

    testWidgets('renders an error indicator that retries the search', (
      tester,
    ) async {
      when(() => resultsCubit.state)
          .thenReturn(const ResultsState(status: ResultsStatus.searchFailure));

      await pumpSubject(tester);

      expect(find.byType(ErrorIndicator), findsOneWidget);
      expect(find.text(l10n.errorWhileLoadingDestinations), findsOneWidget);

      await tester.tap(find.text(l10n.tryAgain));
      await tester.pump();

      verify(() => resultsCubit.search()).called(1);
    });

    testWidgets('renders a grid of results when search completed', (
      tester,
    ) async {
      when(() => resultsCubit.state).thenReturn(
        const ResultsState(
          destinations: [destination],
          status: ResultsStatus.searchCompleted,
        ),
      );

      await pumpSubject(tester);

      expect(find.byType(Grid), findsOneWidget);
      expect(find.byType(ResultCard), findsOneWidget);
    });

    testWidgets('updates the itinerary config when a result is tapped', (
      tester,
    ) async {
      when(() => resultsCubit.state).thenReturn(
        const ResultsState(
          destinations: [destination],
          status: ResultsStatus.searchCompleted,
        ),
      );

      await pumpSubject(tester);
      await tester.tap(find.byType(ResultCard));
      await tester.pump();

      verify(() => resultsCubit.updateItineraryConfig('alps')).called(1);
    });

    testWidgets('pops when the search bar is tapped', (tester) async {
      when(() => resultsCubit.state).thenReturn(const ResultsState());

      await pumpSubject(tester);
      await tester.tap(find.text(l10n.searchDestination));
      await tester.pump();

      verify(() => goRouter.pop<Object?>()).called(1);
    });

    testWidgets('navigates to activities when config is updated', (
      tester,
    ) async {
      whenListen(
        resultsCubit,
        Stream.fromIterable(const [
          ResultsState(status: ResultsStatus.updatedConfig),
        ]),
        initialState: const ResultsState(),
      );

      await pumpSubject(tester);
      await tester.pump();

      verify(() => goRouter.go(Routes.activities)).called(1);
    });

    testWidgets('shows a snackbar when updating the config fails', (
      tester,
    ) async {
      whenListen(
        resultsCubit,
        Stream.fromIterable(const [
          ResultsState(status: ResultsStatus.updateConfigFailure),
        ]),
        initialState: const ResultsState(),
      );

      await pumpSubject(tester);
      await tester.pump();

      expect(find.text(l10n.errorWhileSavingItinerary), findsOneWidget);
    });

    testWidgets('navigates to search on back navigation', (tester) async {
      when(() => resultsCubit.state).thenReturn(const ResultsState());

      await pumpSubject(tester);
      await tester.binding.handlePopRoute();
      await tester.pump();

      verify(() => goRouter.go(Routes.search)).called(1);
    });
  });
}
