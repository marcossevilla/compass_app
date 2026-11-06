import 'package:activity_repository/activity_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/activities/activities.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/routing/routes.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

class MockActivitiesCubit extends MockCubit<ActivitiesState>
    implements ActivitiesCubit;

void main() {
  const activity = Activity(
    name: 'Glacier Trekking',
    description: 'description',
    locationName: 'location',
    duration: 1,
    timeOfDay: TimeOfDay.morning,
    familyFriendly: true,
    price: 1,
    destinationRef: 'alaska',
    ref: 'glacier-trekking',
    imageUrl: 'https://example.com/glacier.jpg',
  );

  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group(ActivitiesPage, () {
    late ActivityRepository activityRepository;
    late ItineraryConfigRepository itineraryConfigRepository;

    setUp(() {
      activityRepository = MockActivityRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
      when(() => itineraryConfigRepository.itineraryConfig)
          .thenReturn(const ItineraryConfig(destination: 'alaska'));
      when(() => activityRepository.getByDestination('alaska'))
          .thenAnswer((_) async => [activity]);
    });

    testWidgets('renders $ActivitiesView and loads activities', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: activityRepository),
              RepositoryProvider.value(value: itineraryConfigRepository),
            ],
            child: const ActivitiesPage(),
          ),
        );
        await tester.pump();
      });

      expect(find.byType(ActivitiesView), findsOneWidget);
      verify(() => activityRepository.getByDestination('alaska')).called(1);
      expect(find.byType(ActivityEntry), findsOneWidget);
    });
  });

  group(ActivitiesView, () {
    late ActivitiesCubit cubit;
    late GoRouter goRouter;

    setUp(() {
      cubit = MockActivitiesCubit();
      goRouter = MockGoRouter();
      when(() => cubit.loadActivities()).thenAnswer((_) async {});
      when(() => cubit.state).thenReturn(const ActivitiesState());
    });

    Future<void> pumpSubject(WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(
          BlocProvider.value(value: cubit, child: const ActivitiesView()),
          goRouter: goRouter,
        );
      });
    }

    testWidgets('renders only header for initial status', (tester) async {
      await pumpSubject(tester);

      expect(find.byType(ActivitiesHeader), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ErrorIndicator), findsNothing);
    });

    testWidgets('renders progress indicator while loading', (tester) async {
      when(() => cubit.state).thenReturn(
        const ActivitiesState(status: ActivitiesStatus.loadingActivities),
      );

      await pumpSubject(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error indicator and retries on failure', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const ActivitiesState(status: ActivitiesStatus.failedLoadingActivities),
      );

      await pumpSubject(tester);

      expect(find.text(l10n.errorWhileLoadingActivities), findsOneWidget);

      await tester.tap(find.text(l10n.tryAgain));

      verify(() => cubit.loadActivities()).called(1);
    });

    testWidgets('renders activities and $BottomArea when loaded', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const ActivitiesState(
          daytimeActivities: [activity],
          selectedActivities: {'glacier-trekking'},
          status: ActivitiesStatus.loadedActivities,
        ),
      );

      await pumpSubject(tester);

      expect(find.byType(ActivitiesHeader), findsOneWidget);
      expect(find.byType(ActivitiesTitle), findsNWidgets(2));
      expect(find.byType(ActivitiesList), findsNWidgets(2));
      expect(find.byType(BottomArea), findsOneWidget);
      expect(find.text(l10n.selected(1)), findsOneWidget);
    });

    testWidgets('navigates to booking when activities are saved', (
      tester,
    ) async {
      whenListen(
        cubit,
        Stream.fromIterable(const [
          ActivitiesState(status: ActivitiesStatus.savedActivities),
        ]),
        initialState: const ActivitiesState(),
      );

      await pumpSubject(tester);
      await tester.pump();

      verify(() => goRouter.go(Routes.booking)).called(1);
    });

    testWidgets('shows snackbar and retries when saving fails', (tester) async {
      whenListen(
        cubit,
        Stream.fromIterable(const [
          ActivitiesState(status: ActivitiesStatus.failedSavingActivities),
        ]),
        initialState: const ActivitiesState(),
      );

      await pumpSubject(tester);
      await tester.pumpAndSettle();

      expect(find.text(l10n.errorWhileSavingActivities), findsOneWidget);

      await tester.tap(find.text(l10n.tryAgain));
      await tester.pump();

      verify(() => cubit.saveActivities()).called(1);
    });

    testWidgets('navigates to results when back navigation is attempted', (
      tester,
    ) async {
      await pumpSubject(tester);

      await tester.binding.handlePopRoute();
      await tester.pump();

      verify(() => goRouter.go(Routes.results)).called(1);
    });
  });

  group(BottomArea, () {
    late ActivitiesCubit cubit;

    setUp(() {
      cubit = MockActivitiesCubit();
      when(() => cubit.state).thenReturn(const ActivitiesState());
    });

    Widget buildSubject(Set<String> selectedActivities) {
      return BlocProvider.value(
        value: cubit,
        child: BottomArea(selectedActivities: selectedActivities),
      );
    }

    testWidgets('disables confirm button when nothing is selected', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject(const {}));

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
      expect(find.text(l10n.selected(0)), findsOneWidget);
    });

    testWidgets('saves activities when confirm is tapped', (tester) async {
      await tester.pumpApp(buildSubject(const {'a', 'b'}));

      expect(find.text(l10n.selected(2)), findsOneWidget);

      await tester.tap(find.text(l10n.confirm));

      verify(() => cubit.saveActivities()).called(1);
    });
  });
}
