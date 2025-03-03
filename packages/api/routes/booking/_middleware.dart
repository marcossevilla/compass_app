import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) => handler.use(bookingProvider);
