part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({this.status = LoginStatus.initial});

  final LoginStatus status;

  LoginState copyWith({LoginStatus? status}) {
    return LoginState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
