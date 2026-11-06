import 'package:compass_app/booking/booking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  Activity buildActivity(String name) {
    return Activity(
      name: name,
      description: 'Description',
      locationName: 'Location',
      duration: 1,
      timeOfDay: TimeOfDay.morning,
      familyFriendly: true,
      price: 1,
      destinationRef: 'alaska',
      ref: name,
      imageUrl: 'https://example.com/$name.jpg',
    );
  }

  final booking = Booking(
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
    activities: [buildActivity('Hiking'), buildActivity('Kayaking')],
  );

  group(BookingShareUseCase, () {
    test('withSharePlus creates an instance', () {
      expect(BookingShareUseCase.withSharePlus(), isA<BookingShareUseCase>());
    });

    group('shareBooking', () {
      test('shares a text describing the booking', () async {
        final sharedParams = <ShareParams>[];
        final useCase = BookingShareUseCase.custom((params) async {
          sharedParams.add(params);
          return const ShareResult('', ShareResultStatus.success);
        });

        await useCase.shareBooking(booking);

        expect(sharedParams, hasLength(1));
        expect(
          sharedParams.single.text,
          'Trip to Alaska\n'
          'on 1 - 5 Jan\n'
          'Activities:\n'
          ' - Hiking\n'
          ' - Kayaking.',
        );
      });

      test('completes normally when sharing throws', () async {
        final useCase = BookingShareUseCase.custom(
          (_) async => throw Exception('oops'),
        );

        await expectLater(useCase.shareBooking(booking), completes);
      });
    });
  });
}
