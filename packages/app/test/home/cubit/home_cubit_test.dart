import 'package:bloc_test/bloc_test.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group(HomeCubit, () {
    late UserRepository userRepository;
    late BookingRepository bookingRepository;

    const user = User(name: 'Sofie', picture: 'assets/user.jpg');
    final booking = BookingSummary(
      id: 1,
      name: 'Alaska, North America',
      startDate: DateTime(2024),
      endDate: DateTime(2024, 1, 5),
    );

    setUp(() {
      userRepository = MockUserRepository();
      bookingRepository = MockBookingRepository();
    });

    HomeCubit buildCubit() => HomeCubit(
      userRepository: userRepository,
      bookingRepository: bookingRepository,
    );

    test('initial state is $HomeState', () {
      expect(buildCubit().state, equals(const HomeState()));
    });

    group('load', () {
      blocTest<HomeCubit, HomeState>(
        'emits [loading, success] with user and bookings',
        setUp: () {
          when(() => userRepository.getUser()).thenAnswer((_) async => user);
          when(() => bookingRepository.getBookingsList())
              .thenAnswer((_) async => [booking]);
        },
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          HomeState(
            user: user,
            bookings: [booking],
            status: HomeStatus.success,
          ),
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'emits [loading, errorInitializing] when loading fails',
        setUp: () {
          when(() => userRepository.getUser()).thenThrow(Exception('oops'));
          when(() => bookingRepository.getBookingsList())
              .thenAnswer((_) async => [booking]);
        },
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const [
          HomeState(status: HomeStatus.loading),
          HomeState(status: HomeStatus.errorInitializing),
        ],
      );
    });

    group('deleteBooking', () {
      blocTest<HomeCubit, HomeState>(
        'emits [deletingBooking, bookingDeleted, reloaded bookings, success]',
        setUp: () {
          when(() => bookingRepository.delete(1)).thenAnswer((_) async {});
          when(() => bookingRepository.getBookingsList())
              .thenAnswer((_) async => []);
        },
        build: buildCubit,
        seed: () => HomeState(
          user: user,
          bookings: [booking],
          status: HomeStatus.success,
        ),
        act: (cubit) => cubit.deleteBooking(1),
        expect: () => [
          HomeState(
            user: user,
            bookings: [booking],
            status: HomeStatus.deletingBooking,
          ),
          HomeState(
            user: user,
            bookings: [booking],
            status: HomeStatus.bookingDeleted,
          ),
          const HomeState(user: user, status: HomeStatus.bookingDeleted),
          const HomeState(user: user, status: HomeStatus.success),
        ],
        verify: (_) {
          verify(() => bookingRepository.delete(1)).called(1);
        },
      );

      blocTest<HomeCubit, HomeState>(
        'emits errorWhileDeletingBooking when delete fails '
        'and success when reloading bookings fails',
        setUp: () {
          when(() => bookingRepository.delete(1)).thenThrow(Exception('oops'));
          when(() => bookingRepository.getBookingsList())
              .thenThrow(Exception('oops'));
        },
        build: buildCubit,
        seed: () => HomeState(
          user: user,
          bookings: [booking],
          status: HomeStatus.success,
        ),
        act: (cubit) => cubit.deleteBooking(1),
        expect: () => [
          HomeState(
            user: user,
            bookings: [booking],
            status: HomeStatus.deletingBooking,
          ),
          HomeState(
            user: user,
            bookings: [booking],
            status: HomeStatus.errorWhileDeletingBooking,
          ),
          HomeState(
            user: user,
            bookings: [booking],
            status: HomeStatus.success,
          ),
        ],
      );
    });
  });
}
