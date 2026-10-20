import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockSearchFormCubit extends MockCubit<SearchFormState>
    implements SearchFormCubit {}

void main() {
  group(SearchFormGuests, () {
    late SearchFormCubit cubit;

    setUp(() {
      cubit = MockSearchFormCubit();
      when(() => cubit.state).thenReturn(const SearchFormState(guests: 3));
    });

    Widget buildSubject() {
      return BlocProvider.value(value: cubit, child: const SearchFormGuests());
    }

    testWidgets('renders label and $QuantitySelector', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Who'), findsOneWidget);
      expect(find.byType(QuantitySelector), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('renders 0 guests', (tester) async {
      when(() => cubit.state).thenReturn(const SearchFormState());
      await tester.pumpApp(buildSubject());

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('calls decrementGuests when minus is tapped', (tester) async {
      await tester.pumpApp(buildSubject());
      await tester.tap(find.byIcon(Icons.remove_circle_outline));

      verify(() => cubit.decrementGuests()).called(1);
    });

    testWidgets('calls incrementGuests when plus is tapped', (tester) async {
      await tester.pumpApp(buildSubject());
      await tester.tap(find.byIcon(Icons.add_circle_outline));

      verify(() => cubit.incrementGuests()).called(1);
    });
  });
}
