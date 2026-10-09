import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'booking.g.dart';

/// A booking that contains a destination and a list of activities.
@JsonSerializable(explicitToJson: true)
class const Booking({
  /// Start date of the trip
  required final DateTime startDate,

  /// End date of the trip.
  required final DateTime endDate,

  /// Destination of the trip.
  required final Destination destination,

  /// List of chosen activities.
  required final List<Activity> activities,

  /// Optional ID of the booking.
  /// May be null if the booking is not yet stored.
  final int? id,
}) extends Equatable {
  /// Creates a [Booking] from a JSON object.
  factory fromJson(Map<String, Object?> json) {
    return _$BookingFromJson(json);
  }

  /// Converts this [Booking] to a JSON object.
  Map<String, Object?> toJson() => _$BookingToJson(this);

  @override
  List<Object?> get props => [id, startDate, endDate, destination, activities];
}

/// [BookingSummary] contains the necessary data to display a booking
/// in the user home screen, but lacks the rest of the booking data
/// like activitities or destination.
@JsonSerializable()
class const BookingSummary({
  /// Booking id.
  required final int id,

  /// Name to be displayed.
  required final String name,

  /// Start date of the booking.
  required final DateTime startDate,

  /// End date of the booking.
  required final DateTime endDate,
}) extends Equatable {
  /// Creates a [BookingSummary] from a JSON object.
  factory fromJson(Map<String, Object?> json) {
    return _$BookingSummaryFromJson(json);
  }

  /// Converts this [BookingSummary] to a JSON object.
  Map<String, Object?> toJson() => _$BookingSummaryToJson(this);

  @override
  List<Object> get props => [id, name, startDate, endDate];
}

/// A booking that contains a destination and a list of activities.
@JsonSerializable()
class const BookingApiModel({
  /// Start date of the trip.
  required final DateTime startDate,

  /// End date of the trip.
  required final DateTime endDate,

  /// Booking name.
  /// Should be "Destination, Continent".
  required final String name,

  /// Destination of the trip.
  required final String destinationRef,

  /// List of chosen activities.
  required final List<String> activitiesRef,

  /// Booking ID.
  /// Generated when stored in server.
  final int? id,
}) extends Equatable {
  /// Creates a [BookingApiModel] from a JSON object.
  factory fromJson(Map<String, Object?> json) {
    return _$BookingApiModelFromJson(json);
  }

  /// Converts a [BookingApiModel] to a JSON object.
  Map<String, Object?> toJson() => _$BookingApiModelToJson(this);

  /// Returns an instance of [BookingApiModel] with updated properties.
  BookingApiModel copyWith({
    int? Function()? id,
    DateTime? startDate,
    DateTime? endDate,
    String? name,
    String? destinationRef,
    List<String>? activitiesRef,
  }) {
    return BookingApiModel(
      id: id?.call() ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      name: name ?? this.name,
      destinationRef: destinationRef ?? this.destinationRef,
      activitiesRef: activitiesRef ?? this.activitiesRef,
    );
  }

  @override
  List<Object?> get props => [
    id,
    startDate,
    endDate,
    name,
    destinationRef,
    activitiesRef,
  ];
}
