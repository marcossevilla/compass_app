import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

int _sequentialId = 0;

Handler middleware(Handler handler) {
  return handler.use(
    provider<List<BookingApiModel>>((context) {
      final bookings = List<BookingApiModel>.empty(growable: true);

      final destination = Assets.destinations.first;
      final activitiesRef =
          Assets.activities
              .where((activity) => activity.destinationRef == destination.ref)
              .map((activity) => activity.ref)
              .toList();

      bookings.add(
        BookingApiModel(
          id: _sequentialId++,
          name: '${destination.name}, ${destination.continent}',
          startDate: DateTime(2024, 7, 20),
          endDate: DateTime(2024, 8, 15),
          destinationRef: destination.ref,
          activitiesRef: activitiesRef,
        ),
      );

      return bookings;
    }),
  );
}
