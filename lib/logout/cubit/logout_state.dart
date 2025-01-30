part of 'logout_cubit.dart';

enum LogoutStatus { initial, loading, success, failure }

class LogoutState extends Equatable {
  const LogoutState({this.status = LogoutStatus.initial});

  final LogoutStatus status;

  LogoutState copyWith({LogoutStatus? status}) {
    return LogoutState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
