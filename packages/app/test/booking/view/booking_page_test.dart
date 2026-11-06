import 'dart:async';

import 'package:activity_repository/activity_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/booking/booking.dart';
import 'package:compass_app/l10n/l10n.dart';
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

class MockBookingCubit extends MockCubit<BookingState>
    implements BookingCubit {}

void main() {
  final booking = Booking(
    id: 1,
    startDate: DateTime(2024),
    endDate: DateTime(2024, 1, 5),
    destination: const Destination(
      ref: 'alaska',
      name: 'Alaska',
      country: 'United States',
      continent: 'North America',
      knownFor: 'Wildlife',
      tags: ['Mountain'],
      imageUrl: 'https://example.com/alaska.jpg',
    ),
    activities: const [],
  );

  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group(BookingPage, () {
    late ActivityRepository activityRepository;
    late BookingRepository bookingRepository;
    late DestinationRepository destinationRepository;
    late ItineraryConfigRepository itineraryConfigRepository;

    setUp(() {
      activityRepository = MockActivityRepository();
      bookingRepository = MockBookingRepository();
      destinationRepository = MockDestinationRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
    });

    Widget buildSubject(BookingPage page) {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: activityRepository),
          RepositoryProvider.value(value: bookingRepository),
          RepositoryProvider.value(value: destinationRepository),
          RepositoryProvider.value(value: itineraryConfigRepository),
        ],
        child: page,
      );
    }

    testWidgets('createBooking creates a booking from the itinerary config', (
      tester,
    ) async {
      when(() => itineraryConfigRepository.itineraryConfig)
          .thenReturn(const ItineraryConfig());

      await tester.pumpApp(buildSubject(const BookingPage.createBooking()));
      await tester.pump();

      verify(() => itineraryConfigRepository.itineraryConfig).called(1);
      expect(find.text(l10n.errorWhileLoadingBooking), findsOneWidget);
      expect(find.text(l10n.tryAgain), findsOneWidget);
    });

    testWidgets('loadBooking loads the booking with the given id', (
      tester,
    ) async {
      final completer = Completer<Booking>();
      when(() => bookingRepository.getBooking(1))
          .thenAnswer((_) => completer.future);

      await mockNetworkImages(() async {
        await tester.pumpApp(
          buildSubject(const BookingPage.loadBooking(id: 1)),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        completer.complete(booking);
        await tester.pump();
      });

      verify(() => bookingRepository.getBooking(1)).called(1);
      expect(find.byType(BookingBody), findsOneWidget);
      expect(find.text('Alaska'), findsOneWidget);
    });
  });

  group(BookingView, () {
    late BookingCubit bookingCubit;
    late GoRouter goRouter;

    setUp(() {
      bookingCubit = MockBookingCubit();
      goRouter = MockGoRouter();

      when(() => bookingCubit.state).thenReturn(const BookingState());
      when(() => bookingCubit.shareBooking()).thenAnswer((_) async {});
      when(() => bookingCubit.createBooking()).thenAnswer((_) async {});
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: bookingCubit,
        child: const BookingView(),
      );
    }

    testWidgets('shows a progress indicator while in progress', (tester) async {
      when(() => bookingCubit.state)
          .thenReturn(const BookingState(status: BookingStatus.loading));

      await tester.pumpApp(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('retries creation when creating fails', (tester) async {
      when(
        () => bookingCubit.state,
      ).thenReturn(const BookingState(status: BookingStatus.creatingFailure));

      await tester.pumpApp(buildSubject());

      expect(find.text(l10n.errorWhileLoadingBooking), findsOneWidget);
      await tester.tap(find.text(l10n.tryAgain));
      await tester.pump();

      verify(() => bookingCubit.createBooking()).called(1);
    });

    testWidgets('goes home when loading fails and close is tapped', (
      tester,
    ) async {
      when(() => bookingCubit.state)
          .thenReturn(const BookingState(status: BookingStatus.loadingFailure));

      await tester.pumpApp(buildSubject(), goRouter: goRouter);

      expect(find.text(l10n.errorWhileLoadingBooking), findsOneWidget);
      await tester.tap(find.text(l10n.close));
      await tester.pump();

      verify(() => goRouter.go(Routes.home)).called(1);
    });

    testWidgets('renders $BookingBody when booking is loaded', (tester) async {
      when(() => bookingCubit.state).thenReturn(
        BookingState(booking: booking, status: BookingStatus.loaded),
      );

      await mockNetworkImages(() async {
        await tester.pumpApp(buildSubject());
      });

      expect(find.byType(BookingBody), findsOneWidget);
      expect(find.byType(ErrorIndicator), findsNothing);
    });

    testWidgets('share button is disabled when booking is null', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject());

      final button = tester.widget<FloatingActionButton>(
        find.byKey(const ValueKey('share-button')),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('shares booking when share button is tapped', (tester) async {
      when(() => bookingCubit.state).thenReturn(
        BookingState(booking: booking, status: BookingStatus.loaded),
      );

      await mockNetworkImages(() async {
        await tester.pumpApp(buildSubject());
      });

      await tester.tap(find.byKey(const ValueKey('share-button')));
      await tester.pump();

      verify(() => bookingCubit.shareBooking()).called(1);
    });

    testWidgets('shows a snackbar and retries when sharing fails', (
      tester,
    ) async {
      final loaded = BookingState(
        booking: booking,
        status: BookingStatus.loaded,
      );
      whenListen(
        bookingCubit,
        Stream.fromIterable([
          BookingState(booking: booking, status: BookingStatus.sharingFailure),
        ]),
        initialState: loaded,
      );

      await mockNetworkImages(() async {
        await tester.pumpApp(buildSubject());
        await tester.pump();
      });

      expect(find.text(l10n.errorWhileSharing), findsOneWidget);

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(SnackBarAction, l10n.tryAgain));
      await tester.pump();

      verify(() => bookingCubit.shareBooking()).called(1);
    });

    testWidgets('does not show a snackbar for other status changes', (
      tester,
    ) async {
      whenListen(
        bookingCubit,
        Stream.fromIterable(const [
          BookingState(status: BookingStatus.creating),
          BookingState(status: BookingStatus.creatingFailure),
        ]),
        initialState: const BookingState(),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('goes home on back navigation', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);

      await tester.binding.handlePopRoute();
      await tester.pump();

      verify(() => goRouter.go(Routes.home)).called(1);
    });
  });
}
