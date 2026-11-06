import 'package:bloc_test/bloc_test.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/booking/booking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

class MockBookingCreateUseCase extends Mock implements BookingCreateUseCase;

class MockBookingShareUseCase extends Mock implements BookingShareUseCase;

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

  const itineraryConfig = ItineraryConfig(destination: 'alaska');

  group(BookingCubit, () {
    late BookingCreateUseCase createUseCase;
    late BookingShareUseCase shareUseCase;
    late BookingRepository bookingRepository;
    late ItineraryConfigRepository itineraryConfigRepository;

    setUpAll(() {
      registerFallbackValue(const ItineraryConfig());
      registerFallbackValue(booking);
    });

    setUp(() {
      createUseCase = MockBookingCreateUseCase();
      shareUseCase = MockBookingShareUseCase();
      bookingRepository = MockBookingRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();

      when(() => itineraryConfigRepository.itineraryConfig)
          .thenReturn(itineraryConfig);
    });

    BookingCubit buildCubit() {
      return BookingCubit(
        createUseCase: createUseCase,
        shareUseCase: shareUseCase,
        bookingRepository: bookingRepository,
        itineraryConfigRepository: itineraryConfigRepository,
      );
    }

    test('initial state is $BookingState', () {
      expect(buildCubit().state, const BookingState());
    });

    group('createBooking', () {
      blocTest<BookingCubit, BookingState>(
        'emits [creating, created] when booking is created',
        setUp: () {
          when(() => createUseCase.createFrom(any()))
              .thenAnswer((_) async => booking);
        },
        build: buildCubit,
        act: (cubit) => cubit.createBooking(),
        expect: () => [
          const BookingState(status: BookingStatus.creating),
          BookingState(booking: booking, status: BookingStatus.created),
        ],
        verify: (_) {
          verify(() => createUseCase.createFrom(itineraryConfig)).called(1);
        },
      );

      blocTest<BookingCubit, BookingState>(
        'emits [creating, creatingFailure] when creation fails',
        setUp: () {
          when(() => createUseCase.createFrom(any()))
              .thenThrow(Exception('oops'));
        },
        build: buildCubit,
        act: (cubit) => cubit.createBooking(),
        expect: () => const [
          BookingState(status: BookingStatus.creating),
          BookingState(status: BookingStatus.creatingFailure),
        ],
      );
    });

    group('loadBooking', () {
      blocTest<BookingCubit, BookingState>(
        'emits [loading, loaded] when booking is loaded',
        setUp: () {
          when(() => bookingRepository.getBooking(any()))
              .thenAnswer((_) async => booking);
        },
        build: buildCubit,
        act: (cubit) => cubit.loadBooking(1),
        expect: () => [
          const BookingState(status: BookingStatus.loading),
          BookingState(booking: booking, status: BookingStatus.loaded),
        ],
        verify: (_) {
          verify(() => bookingRepository.getBooking(1)).called(1);
        },
      );

      blocTest<BookingCubit, BookingState>(
        'emits [loading, loadingFailure] when loading fails',
        setUp: () {
          when(() => bookingRepository.getBooking(any()))
              .thenThrow(Exception('oops'));
        },
        build: buildCubit,
        act: (cubit) => cubit.loadBooking(1),
        expect: () => const [
          BookingState(status: BookingStatus.loading),
          BookingState(status: BookingStatus.loadingFailure),
        ],
      );
    });

    group('shareBooking', () {
      blocTest<BookingCubit, BookingState>(
        'shares the booking and keeps the current status',
        setUp: () {
          when(() => shareUseCase.shareBooking(any())).thenAnswer((_) async {});
        },
        build: buildCubit,
        seed: () =>
            BookingState(booking: booking, status: BookingStatus.loaded),
        act: (cubit) => cubit.shareBooking(),
        expect: () => const <BookingState>[],
        verify: (_) {
          verify(() => shareUseCase.shareBooking(booking)).called(1);
        },
      );

      blocTest<BookingCubit, BookingState>(
        'emits [sharingFailure, previous status] when sharing fails',
        setUp: () {
          when(() => shareUseCase.shareBooking(any()))
              .thenThrow(Exception('oops'));
        },
        build: buildCubit,
        seed: () =>
            BookingState(booking: booking, status: BookingStatus.loaded),
        act: (cubit) => cubit.shareBooking(),
        expect: () => [
          BookingState(booking: booking, status: BookingStatus.sharingFailure),
          BookingState(booking: booking, status: BookingStatus.loaded),
        ],
      );
    });
  });
}
