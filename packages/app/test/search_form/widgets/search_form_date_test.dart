import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockSearchFormCubit extends MockCubit<SearchFormState>
    implements SearchFormCubit {}

void main() {
  group(SearchFormDate, () {
    late SearchFormCubit cubit;
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
    });

    setUp(() {
      cubit = MockSearchFormCubit();
      when(() => cubit.state).thenReturn(const SearchFormState());
    });

    Widget buildSubject() {
      return BlocProvider.value(value: cubit, child: const SearchFormDate());
    }

    testWidgets('renders add dates hint when no dates selected', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject());

      expect(find.text(l10n.when), findsOneWidget);
      expect(find.text(l10n.addDates), findsOneWidget);
    });

    testWidgets('renders the selected date range', (tester) async {
      when(() => cubit.state).thenReturn(
        SearchFormState(
          startDate: DateTime(2026, 6, 10),
          endDate: DateTime(2026, 6, 20),
        ),
      );
      await tester.pumpApp(buildSubject());

      expect(find.text(l10n.addDates), findsNothing);
      expect(find.text('10 - 20 June'), findsOneWidget);
    });

    testWidgets('updates date range with null when picker is cancelled', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(find.byType(DateRangePickerDialog), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      verify(() => cubit.updateDateTimeRange(null, null)).called(1);
    });

    testWidgets('updates date range with the picked dates', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final later = DateTime(now.year, now.month, now.day + 2);

      // Pick the dates through the dialog's text input mode, which does not
      // depend on the currently visible month.
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      final localizations = MaterialLocalizations.of(
        tester.element(find.byType(DateRangePickerDialog)),
      );
      final fields = find.byType(TextField);
      await tester.enterText(
        fields.at(0),
        localizations.formatCompactDate(tomorrow),
      );
      await tester.enterText(
        fields.at(1),
        localizations.formatCompactDate(later),
      );
      await tester.tap(find.text(localizations.okButtonLabel));
      await tester.pumpAndSettle();

      verify(() => cubit.updateDateTimeRange(tomorrow, later)).called(1);
    });

    testWidgets('does not update cubit when unmounted before picking', (
      tester,
    ) async {
      final visible = ValueNotifier(true);
      addTearDown(visible.dispose);

      await tester.pumpApp(
        ValueListenableBuilder<bool>(
          valueListenable: visible,
          builder: (context, value, _) =>
              value ? buildSubject() : const SizedBox(),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      visible.value = false;
      await tester.pump();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      verifyNever(() => cubit.updateDateTimeRange(any(), any()));
    });
  });
}
