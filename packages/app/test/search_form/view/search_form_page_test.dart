import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

class MockSearchFormCubit extends MockCubit<SearchFormState>
    implements SearchFormCubit {}

void main() {
  group(SearchFormPage, () {
    late ContinentRepository continentRepository;
    late ItineraryConfigRepository itineraryConfigRepository;

    setUp(() {
      continentRepository = MockContinentRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
      when(() => continentRepository.getContinents())
          .thenAnswer((_) async => const <Continent>[]);
      when(() => itineraryConfigRepository.itineraryConfig)
          .thenReturn(const ItineraryConfig());
    });

    testWidgets('renders $SearchFormView and loads data', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: continentRepository),
            RepositoryProvider.value(value: itineraryConfigRepository),
          ],
          child: const SearchFormPage(),
        ),
      );
      await tester.pump();

      expect(find.byType(SearchFormView), findsOneWidget);
      verify(() => continentRepository.getContinents()).called(1);
      verify(() => itineraryConfigRepository.itineraryConfig).called(1);
    });
  });

  group(SearchFormView, () {
    late SearchFormCubit cubit;
    late GoRouter goRouter;

    setUp(() {
      cubit = MockSearchFormCubit();
      goRouter = MockGoRouter();
      when(() => cubit.state).thenReturn(const SearchFormState());
    });

    Widget buildSubject() {
      return BlocProvider.value(value: cubit, child: const SearchFormView());
    }

    testWidgets('renders form sections', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);

      expect(find.byType(AppSearchBar), findsOneWidget);
      expect(find.byType(SearchFormContinent), findsOneWidget);
      expect(find.byType(SearchFormDate), findsOneWidget);
      expect(find.byType(SearchFormGuests), findsOneWidget);
      expect(find.byType(SearchFormSubmit), findsOneWidget);
    });

    testWidgets('navigates home when back is pressed', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);

      await tester.binding.handlePopRoute();
      await tester.pump();

      verify(() => goRouter.go(Routes.home)).called(1);
    });
  });
}
