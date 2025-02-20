import 'package:activity_repository/activity_repository.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:logging/logging.dart';

/// UseCase for creating [Booking] objects from [ItineraryConfig].
///
/// Fetches [Destination] and [Activity] objects from repositories,
/// checks if dates are set and creates a [Booking] object.
class BookingCreateUseCase {
  BookingCreateUseCase({
    required ActivityRepository activityRepository,
    required BookingRepository bookingRepository,
    required DestinationRepository destinationRepository,
  }) : _log = Logger('BookingCreateUseCase'),
       _activityRepository = activityRepository,
       _bookingRepository = bookingRepository,
       _destinationRepository = destinationRepository;

  final Logger _log;
  final ActivityRepository _activityRepository;
  final BookingRepository _bookingRepository;
  final DestinationRepository _destinationRepository;

  /// Create [Booking] from a stored [ItineraryConfig].
  Future<Booking> createFrom(ItineraryConfig itineraryConfig) async {
    // Get [Destination] object from repository.
    if (itineraryConfig.destination == null) {
      _log.warning('Destination is not set');
      throw Exception('Destination is not set');
    }

    final destination = await fetchDestination(itineraryConfig.destination!);

    _log.fine('Destination loaded: ${destination.ref}');

    // Get [Activity] objects from repository.
    if (itineraryConfig.activities.isEmpty) {
      _log.warning('Activities are not set');
      throw Exception('Activities are not set');
    }

    final activitiesResult = await _activityRepository.getByDestination(
      itineraryConfig.destination!,
    );

    final activities = activitiesResult.where(
      (activity) => itineraryConfig.activities.contains(activity.ref),
    );
    _log.fine('Activities loaded (${activities.length})');

    // Check if dates are set.
    if (itineraryConfig.startDate == null || itineraryConfig.endDate == null) {
      _log.warning('Dates are not set');
      throw Exception('Dates are not set');
    }

    final booking = Booking(
      activities: activities.toList(),
      destination: destination,
      startDate: itineraryConfig.startDate!,
      endDate: itineraryConfig.endDate!,
    );

    await _bookingRepository.createBooking(booking);

    _log.fine('Booking saved successfully');

    return booking;
  }

  @visibleForTesting
  Future<Destination> fetchDestination(String destinationRef) async {
    final destinations = await _destinationRepository.getDestinations();
    final destination = destinations.firstWhere(
      (destination) => destination.ref == destinationRef,
    );
    return destination;
  }
}
