import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/booking/booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

class MockBookingCubit extends MockCubit<BookingState>
    implements BookingCubit {}

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
      tags: ['Mountain'],
      imageUrl: 'https://example.com/alaska.jpg',
    ),
    activities: const [
      Activity(
        name: 'Glacier Trekking',
        description: 'Hike across the ice',
        locationName: 'Matanuska Glacier',
        duration: 1,
        timeOfDay: TimeOfDay.morning,
        familyFriendly: false,
        price: 4,
        destinationRef: 'alaska',
        ref: 'glacier-trekking',
        imageUrl: 'https://example.com/glacier.jpg',
      ),
    ],
  );

  group(BookingBody, () {
    late BookingCubit bookingCubit;

    setUp(() {
      bookingCubit = MockBookingCubit();
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: bookingCubit,
        child: const BookingBody(),
      );
    }

    testWidgets('renders nothing when booking is null', (tester) async {
      when(() => bookingCubit.state).thenReturn(const BookingState());

      await tester.pumpApp(buildSubject());

      expect(find.byType(CustomScrollView), findsNothing);
      expect(find.byType(BookingHeader), findsNothing);
    });

    testWidgets('renders header and activities when booking is set', (
      tester,
    ) async {
      when(() => bookingCubit.state).thenReturn(
        BookingState(booking: booking, status: BookingStatus.loaded),
      );

      await mockNetworkImages(() async {
        await tester.pumpApp(buildSubject());
      });

      expect(find.byType(BookingHeader), findsOneWidget);
      expect(find.text('MORNING'), findsOneWidget);
      expect(find.text('Glacier Trekking'), findsOneWidget);
      expect(find.text('Hike across the ice'), findsOneWidget);
    });
  });
}
