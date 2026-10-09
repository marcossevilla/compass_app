part of 'logout_cubit.dart';

enum LogoutStatus { initial, loading, success, failure }

class const LogoutState({final LogoutStatus status = LogoutStatus.initial})
    extends Equatable {
  LogoutState copyWith({LogoutStatus? status}) {
    return LogoutState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
