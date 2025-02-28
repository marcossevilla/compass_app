import 'package:api/booking/booking.dart';
import 'package:test/test.dart';

void main() {
  group('BookingState', () {
    test('supports value comparison', () {
      expect(BookingState(bookings: []), BookingState(bookings: []));
    });

    test('.initial adds default booking', () {
      expect(
        BookingState.initial(sequentialId: 0),
        isA<BookingState>().having(
          (state) => state.bookings.single,
          'default booking',
          equals(BookingState.defaultBooking(sequentialId: 0)),
        ),
      );
    });
  });
}
