import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthenticationRepository authenticationRepository,
  })  : _log = Logger('LoginCubit'),
        _authenticationRepository = authenticationRepository,
        super(const LoginState());

  final Logger _log;
  final AuthenticationRepository _authenticationRepository;

  Future<void> login((String, String) credentials) async {
    try {
      final (email, password) = credentials;

      emit(const LoginState(status: LoginStatus.loading));

      await _authenticationRepository.login(
        email: email,
        password: password,
      );

      emit(const LoginState(status: LoginStatus.success));
    } on Exception catch (error) {
      _log.warning('Login failed! $error');
      emit(const LoginState(status: LoginStatus.failure));
    }
  }
}
