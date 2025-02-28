import 'package:api/booking/booking.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('BookingEvent', () {
    late BookingApiModel booking;

    setUp(() {
      booking = BookingApiModel(
        id: 0,
        name: 'Booking 1',
        startDate: DateTime(2024, 7, 20),
        endDate: DateTime(2024, 8, 15),
        destinationRef: 'destination1',
        activitiesRef: ['activity1', 'activity2'],
      );
    });

    group('BookingAdded', () {
      test('supports value comparison', () {
        expect(BookingAdded(booking), BookingAdded(booking));
      });
    });

    group('BookingRemoved', () {
      test('supports value comparison', () {
        expect(BookingRemoved(booking), BookingRemoved(booking));
      });
    });
  });
}
