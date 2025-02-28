import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

final _bookingBloc = BookingBloc();

Handler middleware(Handler handler) {
  return handler.use(provider<BookingBloc>((_) => _bookingBloc));
}
