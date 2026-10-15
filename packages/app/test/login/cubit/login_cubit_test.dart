import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group(LoginCubit, () {
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
    });

    LoginCubit buildCubit() =>
        LoginCubit(authenticationRepository: authenticationRepository);

    test('initial state is $LoginState', () {
      expect(buildCubit().state, equals(const LoginState()));
    });

    group('login', () {
      blocTest<LoginCubit, LoginState>(
        'emits [loading, success] when login succeeds',
        setUp: () {
          when(
            () => authenticationRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async {});
        },
        build: buildCubit,
        act: (cubit) => cubit.login(('email@example.com', 'password')),
        expect: () => const [
          LoginState(status: LoginStatus.loading),
          LoginState(status: LoginStatus.success),
        ],
        verify: (_) {
          verify(
            () => authenticationRepository.login(
              email: 'email@example.com',
              password: 'password',
            ),
          ).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [loading, failure] when login fails',
        setUp: () {
          when(
            () => authenticationRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: buildCubit,
        act: (cubit) => cubit.login(('email@example.com', 'password')),
        expect: () => const [
          LoginState(status: LoginStatus.loading),
          LoginState(status: LoginStatus.failure),
        ],
      );
    });
  });
}
