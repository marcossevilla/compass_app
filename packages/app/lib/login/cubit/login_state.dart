part of 'login_cubit.dart';

enum LoginStatus() {
  initial,
  loading,
  success,
  failure,
}

class const LoginState({final LoginStatus status = LoginStatus.initial})
    extends Equatable {
  LoginState copyWith({LoginStatus? status}) {
    return LoginState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
