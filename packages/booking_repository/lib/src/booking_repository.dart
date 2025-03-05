import 'package:api_client/api_client.dart';
import 'package:models/models.dart';

/// {@template booking_repository}
/// Repository that manages the booking domain.
/// {@endtemplate}
class BookingRepository {
  /// {@macro booking_repository}
  BookingRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  List<Destination>? _cachedDestinations;

  /// Creates a new booking.
  Future<void> createBooking(Booking booking) async {
    final bookingApiModel = BookingApiModel(
      startDate: booking.startDate,
      endDate: booking.endDate,
      name: '${booking.destination.name}, ${booking.destination.continent}',
      destinationRef: booking.destination.ref,
      activitiesRef: [...booking.activities.map((activity) => activity.ref)],
    );

    await _apiClient.postBooking(bookingApiModel);
  }

  /// Get a booking by its [id].
  Future<Booking> getBooking(int id) async {
    // Get booking by ID from server.
    final booking = await _apiClient.getBooking(id);

    // Load destinations if not loaded yet.
    if (_cachedDestinations == null) {
      final destinations = await _apiClient.getDestinations();
      _cachedDestinations = destinations;
    }

    // Get destination for booking.
    final destination = _cachedDestinations!.firstWhere(
      (destination) => destination.ref == booking.destinationRef,
    );

    final activitiesByDestination = await _apiClient.getActivityByDestination(
      destination.ref,
    );

    final activities = activitiesByDestination.where(
      (activity) => booking.activitiesRef.contains(activity.ref),
    );

    return Booking(
      id: booking.id,
      startDate: booking.startDate,
      endDate: booking.endDate,
      destination: destination,
      activities: [...activities],
    );
  }

  /// Get a list of all bookings.
  Future<List<BookingSummary>> getBookingsList() async {
    final bookings = await _apiClient.getBookings();

    return [
      ...bookings.map(
        (bookingApi) => BookingSummary(
          id: bookingApi.id!,
          name: bookingApi.name,
          startDate: bookingApi.startDate,
          endDate: bookingApi.endDate,
        ),
      ),
    ];
  }

  /// Delete a booking.
  Future<void> delete(int id) async => _apiClient.deleteBooking(id);
}
