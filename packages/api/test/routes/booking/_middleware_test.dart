import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/booking/_middleware.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('middleware', () {
    test('provides a $BookingBloc instance', () async {
      final handler = middleware((_) => Response());
      final request = Request.get(Uri.parse('http://localhost/booking/'));
      final context = _MockRequestContext();

      when(() => context.request).thenReturn(request);
      when(() => context.provide<BookingBloc>(any())).thenReturn(context);

      await handler(context);

      final create =
          verify(
                () => context.provide<BookingBloc>(captureAny()),
              ).captured.single
              as BookingBloc Function();

      expect(create(), isA<BookingBloc>());
    });
  });
}
