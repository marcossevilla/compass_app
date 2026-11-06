import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockSearchFormCubit extends MockCubit<SearchFormState>
    implements SearchFormCubit {}

void main() {
  group(SearchFormSubmit, () {
    late SearchFormCubit cubit;
    late GoRouter goRouter;
    late AppLocalizations l10n;

    final validState = SearchFormState(
      guests: 1,
      selectedContinent: 'Europe',
      startDate: DateTime(2026),
      endDate: DateTime(2026, 2),
    );

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
    });

    setUp(() {
      cubit = MockSearchFormCubit();
      goRouter = MockGoRouter();
      when(() => cubit.state).thenReturn(const SearchFormState());
    });

    Widget buildSubject() {
      return Scaffold(
        body: BlocProvider.value(value: cubit, child: const SearchFormSubmit()),
      );
    }

    testWidgets('button is disabled when the form is invalid', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
      expect(find.text(l10n.search.toUpperCase()), findsOneWidget);
    });

    testWidgets('calls updateItineraryConfig when tapped and valid', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(validState);
      await tester.pumpApp(buildSubject(), goRouter: goRouter);

      await tester.tap(find.byType(FilledButton));

      verify(() => cubit.updateItineraryConfig()).called(1);
    });

    testWidgets('navigates to results when config is saved', (tester) async {
      whenListen(
        cubit,
        Stream.fromIterable([
          validState.copyWith(status: SearchFormStatus.configSaved),
        ]),
        initialState: validState,
      );
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      await tester.pump();

      verify(() => goRouter.go(Routes.results)).called(1);
    });

    testWidgets('shows a snackbar when saving fails', (tester) async {
      whenListen(
        cubit,
        Stream.fromIterable([
          validState.copyWith(status: SearchFormStatus.error),
        ]),
        initialState: validState,
      );
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      await tester.pump();

      expect(find.text(l10n.errorWhileSavingItinerary), findsOneWidget);
      verifyNever(() => goRouter.go(any()));
    });

    testWidgets('retries saving when the snackbar action is tapped', (
      tester,
    ) async {
      whenListen(
        cubit,
        Stream.fromIterable([
          validState.copyWith(status: SearchFormStatus.error),
        ]),
        initialState: validState,
      );
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.tryAgain));
      await tester.pump();

      verify(() => cubit.updateItineraryConfig()).called(1);
    });
  });
}
