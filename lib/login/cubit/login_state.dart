part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({this.status = LoginStatus.initial});

  final LoginStatus status;

  @override
  List<Object> get props => [status];
}
