import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

/// Time of day when the activity is available.
enum TimeOfDay {
  /// Any time of day.
  any,

  /// Morning.
  morning,

  /// Afternoon.
  afternoon,

  /// Evening.
  evening,

  /// Night.
  night,
}

/// {@template activity}
/// An activity that can be done at a destination.
/// {@endtemplate}
@JsonSerializable()
class const Activity({
  /// e.g. 'Glacier Trekking and Ice Climbing'
  required final String name,

  /// e.g. 'Embark on a thrilling adventure exploring the awe-inspiring glaciers
  /// of Alaska. Hike across the icy terrain, marvel at the deep blue crevasses,
  /// and even try your hand at ice climbing for an unforgettable experience.'
  required final String description,

  /// e.g. 'Matanuska Glacier or Mendenhall Glacier'
  required final String locationName,

  /// Duration in days.
  /// e.g. 8
  required final int duration,

  /// e.g. 'morning'
  required final TimeOfDay timeOfDay,

  /// e.g. false
  required final bool familyFriendly,

  /// e.g. 4
  required final int price,

  /// e.g. 'alaska'
  required final String destinationRef,

  /// e.g. 'glacier-trekking-and-ice-climbing'
  required final String ref,

  /// e.g. 'https://storage.googleapis.com/tripedia-images/activities/alaska_glacier-trekking-and-ice-climbing.jpg'
  required final String imageUrl,
}) extends Equatable {
  /// {@macro activity}
  this;

  /// Creates an [Activity] from a JSON object.
  factory fromJson(Map<String, Object?> json) {
    return _$ActivityFromJson(json);
  }

  /// Converts this [Activity] to a JSON object.
  Map<String, Object?> toJson() => _$ActivityToJson(this);

  @override
  List<Object> get props => [
    name,
    description,
    locationName,
    duration,
    timeOfDay,
    familyFriendly,
    price,
    destinationRef,
    ref,
  ];
}
