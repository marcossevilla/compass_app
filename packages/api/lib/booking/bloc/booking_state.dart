part of 'booking_bloc.dart';

class BookingState extends Equatable {
  const BookingState({required this.bookings, required this.sequentialId});

  BookingState.initial({this.sequentialId = 0})
    : bookings = [defaultBooking(sequentialId: sequentialId)];

  @visibleForTesting
  static BookingApiModel defaultBooking({required int sequentialId}) {
    final destination = Assets.destinations.first;
    final activitiesRef = Assets.activities
        .where((activity) => activity.destinationRef == destination.ref)
        .map((activity) => activity.ref)
        .toList();

    return BookingApiModel(
      id: sequentialId,
      name: '${destination.name}, ${destination.continent}',
      startDate: DateTime(2024, 7, 20),
      endDate: DateTime(2024, 8, 15),
      destinationRef: destination.ref,
      activitiesRef: activitiesRef,
    );
  }

  final int sequentialId;
  final List<BookingApiModel> bookings;

  @override
  List<Object> get props => [sequentialId, bookings];
}
