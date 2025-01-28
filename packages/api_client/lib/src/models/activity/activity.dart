// ignore_for_file: lines_longer_than_80_chars

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
class Activity {
  /// {@macro activity}
  const Activity({
    required this.name,
    required this.description,
    required this.locationName,
    required this.duration,
    required this.timeOfDay,
    required this.familyFriendly,
    required this.price,
    required this.destinationRef,
    required this.ref,
    required this.imageUrl,
  });

  /// Creates an [Activity] from a JSON object.
  factory Activity.fromJson(Map<String, Object?> json) {
    return _$ActivityFromJson(json);
  }

  /// Converts this [Activity] to a JSON object.
  Map<String, Object?> toJson() => _$ActivityToJson(this);

  /// e.g. 'Glacier Trekking and Ice Climbing'
  final String name;

  /// e.g. 'Embark on a thrilling adventure exploring the awe-inspiring glaciers of Alaska.
  /// Hike across the icy terrain, marvel at the deep blue crevasses, and even try your hand at ice climbing for an unforgettable experience.'
  final String description;

  /// e.g. 'Matanuska Glacier or Mendenhall Glacier'
  final String locationName;

  /// Duration in days.
  /// e.g. 8
  final int duration;

  /// e.g. 'morning'
  final TimeOfDay timeOfDay;

  /// e.g. false
  final bool familyFriendly;

  /// e.g. 4
  final int price;

  /// e.g. 'alaska'
  final String destinationRef;

  /// e.g. 'glacier-trekking-and-ice-climbing'
  final String ref;

  /// e.g. 'https://storage.googleapis.com/tripedia-images/activities/alaska_glacier-trekking-and-ice-climbing.jpg'
  final String imageUrl;
}
