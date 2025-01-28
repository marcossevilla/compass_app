import 'package:api_client/api_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking.g.dart';

/// {@template booking}
/// A booking that contains a destination and a list of activities.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class Booking {
  /// {@macro booking}
  const Booking({
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.activity,
    this.id,
  });

  /// Creates a [Booking] from a JSON object.
  factory Booking.fromJson(Map<String, Object?> json) {
    return _$BookingFromJson(json);
  }

  /// Optional ID of the booking.
  /// May be null if the booking is not yet stored.
  final int? id;

  /// Start date of the trip
  final DateTime startDate;

  /// End date of the trip.
  final DateTime endDate;

  /// Destination of the trip.
  final Destination destination;

  /// List of chosen activities.
  final List<Activity> activity;
}

/// {@template booking_summary}
/// [BookingSummary] contains the necessary data to display a booking
/// in the user home screen, but lacks the rest of the booking data
/// like activitities or destination.
/// {@endtemplate}
@JsonSerializable()
class BookingSummary {
  /// {@macro booking_summary}
  const BookingSummary({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  /// Creates a [BookingSummary] from a JSON object.
  factory BookingSummary.fromJson(Map<String, Object?> json) {
    return _$BookingSummaryFromJson(json);
  }

  /// Booking id.
  final int id;

  /// Name to be displayed.
  final String name;

  /// Start date of the booking.
  final DateTime startDate;

  /// End date of the booking.
  final DateTime endDate;
}

/// {@template booking_api_model}
/// A booking that contains a destination and a list of activities.
/// {@endtemplate}
@JsonSerializable()
class BookingApiModel {
  /// {@macro booking_api_model}
  const BookingApiModel({
    required this.startDate,
    required this.endDate,
    required this.name,
    required this.destinationRef,
    required this.activitiesRef,
    this.id,
  });

  /// Creates a [BookingApiModel] from a JSON object.
  factory BookingApiModel.fromJson(Map<String, Object?> json) =>
      _$BookingApiModelFromJson(json);

  /// Booking ID.
  /// Generated when stored in server.
  final int? id;

  /// Start date of the trip.
  final DateTime startDate;

  /// End date of the trip.
  final DateTime endDate;

  /// Booking name.
  /// Should be "Destination, Continent".
  final String name;

  /// Destination of the trip.
  final String destinationRef;

  /// List of chosen activities.
  final List<String> activitiesRef;
}
