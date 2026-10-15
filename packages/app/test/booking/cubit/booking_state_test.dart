import 'package:compass_app/booking/booking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';

void main() {
  final booking = Booking(
    startDate: DateTime(2024),
    endDate: DateTime(2024, 1, 5),
    destination: const Destination(
      ref: 'alaska',
      name: 'Alaska',
      country: 'United States',
      continent: 'North America',
      knownFor: 'Wildlife',
      tags: [],
      imageUrl: 'https://example.com/alaska.jpg',
    ),
    activities: const [],
  );

  group(BookingStatus, () {
    test('isInProgress is true only for loading and creating', () {
      for (final status in BookingStatus.values) {
        expect(
          status.isInProgress,
          status == BookingStatus.loading || status == BookingStatus.creating,
        );
      }
    });
  });

  group(BookingState, () {
    test('supports value equality', () {
      expect(const BookingState(), const BookingState());
    });

    test('has correct default values', () {
      const state = BookingState();
      expect(state.booking, isNull);
      expect(state.status, BookingStatus.initial);
    });

    group('copyWith', () {
      test('returns the same object when no arguments are passed', () {
        final state = BookingState(
          booking: booking,
          status: BookingStatus.loaded,
        );
        expect(state.copyWith(), state);
      });

      test('replaces non-null parameters', () {
        expect(
          const BookingState().copyWith(
            booking: booking,
            status: BookingStatus.created,
          ),
          BookingState(booking: booking, status: BookingStatus.created),
        );
      });
    });
  });
}
