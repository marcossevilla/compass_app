import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

typedef ShareFunction = Future<void> Function(String text);

/// UseCase for sharing a booking.
class BookingShareUseCase {
  BookingShareUseCase._(this._share) : _log = Logger('BookingShareUseCase');

  /// Create a [BookingShareUseCase] that uses `share_plus` package.
  factory BookingShareUseCase.withSharePlus() =>
      BookingShareUseCase._(Share.share);

  /// Create a [BookingShareUseCase] with a custom share function.
  factory BookingShareUseCase.custom(ShareFunction share) =>
      BookingShareUseCase._(share);

  final Logger _log;
  final ShareFunction _share;

  Future<void> shareBooking(Booking booking) async {
    final dateRange = DateTimeRange(
      start: booking.startDate,
      end: booking.endDate,
    );

    final text =
        'Trip to ${booking.destination.name}\n'
        'on ${dateRange.dateFormatStartEnd}\n'
        'Activities:\n'
        '${booking.activities.map((a) => ' - ${a.name}').join('\n')}.';

    _log.info('Sharing booking: $text');

    try {
      await _share(text);
      _log.fine('Shared booking');
    } on Exception catch (error) {
      _log.severe('Failed to share booking', error);
    }
  }
}
