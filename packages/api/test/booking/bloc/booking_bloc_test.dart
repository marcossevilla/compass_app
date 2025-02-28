import 'package:api/booking/booking.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class _FakeBookingApiModel extends Fake implements BookingApiModel {}

void main() {
  group('BookingBloc', () {
    late BookingApiModel defaultBooking;
    late BookingApiModel booking;

    setUp(() {
      defaultBooking = BookingState.defaultBooking(sequentialId: 0);
      booking = _FakeBookingApiModel();
    });

    blocTest<BookingBloc, BookingState>(
      'emits [BookingState] with new booking when BookingAdded is added',
      build: () => BookingBloc(sequentialId: 0),
      act: (bloc) => bloc.add(BookingAdded(booking)),
      expect: () {
        return [
          BookingState(bookings: [defaultBooking, booking]),
        ];
      },
    );

    blocTest<BookingBloc, BookingState>(
      'emits [BookingState] with default booking when BookingRemoved is added',
      build: () => BookingBloc(sequentialId: 0),
      seed: () => BookingState(bookings: [defaultBooking, booking]),
      act: (bloc) => bloc.add(BookingRemoved(booking)),
      expect: () {
        return [
          BookingState(bookings: [defaultBooking]),
        ];
      },
    );
  });
}
