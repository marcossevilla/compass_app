part of 'booking_bloc.dart';

class BookingState extends Equatable {
  const BookingState({required this.bookings});

  BookingState.initial({required int sequentialId})
    : bookings = List<BookingApiModel>.empty(growable: true) {
    final destination = Assets.destinations.first;
    final activitiesRef =
        Assets.activities
            .where((activity) => activity.destinationRef == destination.ref)
            .map((activity) => activity.ref)
            .toList();

    bookings.add(
      BookingApiModel(
        id: sequentialId++,
        name: '${destination.name}, ${destination.continent}',
        startDate: DateTime(2024, 7, 20),
        endDate: DateTime(2024, 8, 15),
        destinationRef: destination.ref,
        activitiesRef: activitiesRef,
      ),
    );
  }

  final List<BookingApiModel> bookings;

  @override
  List<Object> get props => [bookings];
}
