import 'package:compass_app/routing/routing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('routes', () {
    // These locations are the deep-linking contract: an external link with one
    // of these paths must resolve to the matching in-app destination.
    test('expose the expected deep-link locations', () {
      expect(const LoginRoute().location, '/login');
      expect(const HomeRoute().location, '/');
      expect(const SearchRoute().location, '/search');
      expect(const ResultsRoute().location, '/results');
      expect(const ActivitiesRoute().location, '/activities');
      expect(const BookingRoute().location, '/booking');
    });

    test('BookingDetailsRoute builds a location from its id', () {
      expect(const BookingDetailsRoute(id: 1).location, '/booking/1');
      expect(const BookingDetailsRoute(id: 42).location, '/booking/42');
    });
  });
}
