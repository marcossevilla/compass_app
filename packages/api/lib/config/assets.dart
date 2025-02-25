import 'dart:convert';
import 'dart:io';

import 'package:models/models.dart';

/// Class containing constants with assets paths.
abstract final class Assets {
  static const _activities = 'public/assets/activities.json';
  static const _destinations = 'public/assets/destinations.json';

  /// List of destinations.
  static List<Destination> get destinations {
    final data = json.decode(File(_destinations).readAsStringSync()) as List;
    return data
        .map((e) => Destination.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// List of activities.
  static List<Activity> get activities {
    final data = json.decode(File(_activities).readAsStringSync()) as List;
    return data
        .map((e) => Activity.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
