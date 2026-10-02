import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/logout/logout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

void main() {
  group(LogoutCubit, () {
    late AuthenticationRepository authenticationRepository;
    late ItineraryConfigRepository itineraryConfigRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
    });

    LogoutCubit buildCubit() {
      return LogoutCubit(
        authenticationRepository: authenticationRepository,
        itineraryConfigRepository: itineraryConfigRepository,
      );
    }

    test('initial state is LogoutState()', () {
      expect(buildCubit().state, const LogoutState());
    });

    group('logout', () {
      blocTest<LogoutCubit, LogoutState>(
        'emits [loading, success] and clears itinerary config on success',
        setUp: () {
          when(() => authenticationRepository.logout())
              .thenAnswer((_) async {});
        },
        build: buildCubit,
        act: (cubit) => cubit.logout(),
        expect: () => const [
          LogoutState(status: LogoutStatus.loading),
          LogoutState(status: LogoutStatus.success),
        ],
        verify: (_) {
          verify(() => authenticationRepository.logout()).called(1);
          verify(
            () => itineraryConfigRepository.itineraryConfig =
                const ItineraryConfig(),
          ).called(1);
        },
      );

      blocTest<LogoutCubit, LogoutState>(
        'emits [loading, success] when logout throws',
        setUp: () {
          when(() => authenticationRepository.logout())
              .thenThrow(Exception('oops'));
        },
        build: buildCubit,
        act: (cubit) => cubit.logout(),
        expect: () => const [
          LogoutState(status: LogoutStatus.loading),
          LogoutState(status: LogoutStatus.success),
        ],
        verify: (_) {
          verify(() => authenticationRepository.logout()).called(1);
          verifyNever(() => itineraryConfigRepository.itineraryConfig = any());
        },
      );
    });
  });
}
