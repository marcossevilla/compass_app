import 'package:api/booking/booking.dart';
import 'package:dart_frog/dart_frog.dart';

final _booking = BookingBloc();

final Middleware bookingProvider = provider<BookingBloc>((_) => _booking);
