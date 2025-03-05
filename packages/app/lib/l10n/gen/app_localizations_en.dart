// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get activities => 'Activities';

  @override
  String get addDates => 'Add Dates';

  @override
  String get bookingDeleted => 'Booking deleted';

  @override
  String get bookNewTrip => 'Book New Trip';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get daytime => 'Daytime';

  @override
  String get errorWhileDeletingBooking => 'Error while deleting booking';

  @override
  String get errorWhileLoadingActivities => 'Error while loading activities';

  @override
  String get errorWhileLoadingBooking => 'Error while loading booking';

  @override
  String get errorWhileLoadingContinents => 'Error while loading continents';

  @override
  String get errorWhileLoadingDestinations =>
      'Error while loading destinations';

  @override
  String get errorWhileLoadingHome => 'Error while loading home';

  @override
  String get errorWhileLogin => 'Error while trying to login';

  @override
  String get errorWhileLogout => 'Error while trying to logout';

  @override
  String get errorWhileSavingActivities => 'Error while saving activities';

  @override
  String get errorWhileSavingItinerary => 'Error while saving itinerary';

  @override
  String get errorWhileSharing => 'Error while sharing booking';

  @override
  String get evening => 'Evening';

  @override
  String get login => 'Login';

  @override
  String nameTrips(String name) {
    return '$name\'s Trips';
  }

  @override
  String get search => 'Search';

  @override
  String get searchDestination => 'Search destination';

  @override
  String selected(int selection) {
    return '$selection selected';
  }

  @override
  String get shareTrip => 'Share Trip';

  @override
  String get tryAgain => 'Try again';

  @override
  String get yourChosenActivities => 'Your chosen activities';

  @override
  String get when => 'When';
}
