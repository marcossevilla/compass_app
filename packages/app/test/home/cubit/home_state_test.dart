import 'package:compass_app/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';

void main() {
  group(HomeState, () {
    const user = User(name: 'Sofie', picture: 'assets/user.jpg');

    test('supports value equality', () {
      expect(const HomeState(), equals(const HomeState()));
    });

    group('copyWith', () {
      test('returns the same object when no arguments are passed', () {
        expect(const HomeState().copyWith(), equals(const HomeState()));
      });

      test('replaces every non-null parameter', () {
        final bookings = [
          BookingSummary(
            id: 1,
            name: 'name',
            startDate: DateTime(2024),
            endDate: DateTime(2024, 1, 2),
          ),
        ];

        expect(
          const HomeState().copyWith(
            user: user,
            bookings: bookings,
            status: HomeStatus.success,
          ),
          equals(
            HomeState(
              user: user,
              bookings: bookings,
              status: HomeStatus.success,
            ),
          ),
        );
      });
    });
  });
}
