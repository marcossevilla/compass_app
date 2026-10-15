import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

class MockSearchFormCubit extends MockCubit<SearchFormState>
    implements SearchFormCubit {}

void main() {
  const continents = [
    Continent(name: 'Europe', imageUrl: 'https://example.com/europe'),
    Continent(name: 'Asia', imageUrl: 'https://example.com/asia'),
  ];

  late SearchFormCubit cubit;
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() {
    cubit = MockSearchFormCubit();
    when(() => cubit.load()).thenAnswer((_) async {});
  });

  group(SearchFormContinent, () {
    Widget buildSubject() {
      return BlocProvider.value(
        value: cubit,
        child: const SearchFormContinent(),
      );
    }

    testWidgets('renders loading indicator when loading', (tester) async {
      when(() => cubit.state)
          .thenReturn(const SearchFormState(status: SearchFormStatus.loading));
      await tester.pumpApp(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders $ErrorIndicator and retries on error', (tester) async {
      when(() => cubit.state)
          .thenReturn(const SearchFormState(status: SearchFormStatus.error));
      await tester.pumpApp(buildSubject());

      expect(find.byType(ErrorIndicator), findsOneWidget);
      expect(find.text(l10n.errorWhileLoadingContinents), findsOneWidget);

      await tester.tap(find.text(l10n.tryAgain));

      verify(() => cubit.load()).called(1);
    });

    testWidgets('renders a $CarouselItem per continent', (tester) async {
      when(() => cubit.state).thenReturn(
        const SearchFormState(
          status: SearchFormStatus.loaded,
          continents: continents,
        ),
      );
      await mockNetworkImages(() => tester.pumpApp(buildSubject()));

      expect(find.byType(CarouselItem), findsNWidgets(2));
      expect(find.text('Europe'), findsOneWidget);
      expect(find.text('Asia'), findsOneWidget);
    });
  });

  group(CarouselItem, () {
    setUp(() {
      when(() => cubit.state).thenReturn(const SearchFormState());
    });

    Widget buildSubject({String? selectedContinent}) {
      return BlocProvider.value(
        value: cubit,
        child: CarouselItem(
          name: 'Europe',
          imageUrl: 'https://example.com/europe',
          selectedContinent: selectedContinent,
        ),
      );
    }

    testWidgets('selects the continent when tapped', (tester) async {
      await mockNetworkImages(() => tester.pumpApp(buildSubject()));

      await tester.tap(find.byType(InkWell));

      verify(() => cubit.updateSelectedContinent('Europe')).called(1);
    });

    testWidgets('deselects the continent when tapped while selected', (
      tester,
    ) async {
      await mockNetworkImages(
        () => tester.pumpApp(buildSubject(selectedContinent: 'Europe')),
      );

      await tester.tap(find.byType(InkWell));

      verify(() => cubit.updateSelectedContinent(null)).called(1);
    });

    testWidgets('renders a placeholder when the image fails to load', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(DecoratedBox), findsWidgets);
    });
  });
}
