import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

var _sequentialId = 0;

Handler middleware(Handler handler) {
  return handler
      .use(provider<int>((context) => _sequentialId))
      .use(
        provider<BookingBloc>(
          (context) => BookingBloc(sequentialId: _sequentialId),
        ),
      );
}
