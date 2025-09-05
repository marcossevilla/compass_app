import 'package:api/booking/booking.dart';
import 'package:test/test.dart';

void main() {
  group(BookingState, () {
    test('supports value comparison', () {
      expect(
        BookingState(bookings: [], sequentialId: 0),
        equals(BookingState(bookings: [], sequentialId: 0)),
      );
    });

    test('.initial adds default booking', () {
      expect(
        BookingState.initial(),
        isA<BookingState>().having(
          (state) => state.bookings.single,
          'default booking',
          equals(BookingState.defaultBooking(sequentialId: 0)),
        ),
      );
    });
  });
}
