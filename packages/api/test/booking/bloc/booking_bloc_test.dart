import 'package:api/booking/booking.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class _FakeBookingApiModel extends Fake implements BookingApiModel {
  @override
  BookingApiModel copyWith({
    int? Function()? id,
    DateTime? startDate,
    DateTime? endDate,
    String? name,
    String? destinationRef,
    List<String>? activitiesRef,
  }) {
    return this;
  }
}

void main() {
  group(BookingBloc, () {
    late BookingApiModel defaultBooking;
    late BookingApiModel booking;

    setUp(() {
      defaultBooking = BookingState.defaultBooking(sequentialId: 0);
      booking = _FakeBookingApiModel();
    });

    blocTest<BookingBloc, BookingState>(
      'emits [$BookingState] with new booking when $BookingAdded is added',
      build: BookingBloc.new,
      act: (bloc) => bloc.add(BookingAdded(booking)),
      expect: () {
        return [
          BookingState(bookings: [defaultBooking, booking], sequentialId: 1),
        ];
      },
    );

    blocTest<BookingBloc, BookingState>(
      'emits [$BookingState] with default booking '
      'when $BookingRemoved is added',
      build: BookingBloc.new,
      seed: () {
        return BookingState(
          bookings: [defaultBooking, booking],
          sequentialId: 2,
        );
      },
      act: (bloc) => bloc.add(BookingRemoved(booking)),
      expect: () {
        return [
          BookingState(bookings: [defaultBooking], sequentialId: 2),
        ];
      },
    );
  });
}
