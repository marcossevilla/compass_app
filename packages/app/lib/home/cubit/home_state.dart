part of 'home_cubit.dart';

enum HomeStatus {
  initial,
  loading,
  success,
  deletingBooking,
  bookingDeleted,
  errorInitializing,
  errorWhileDeletingBooking,
}

class const HomeState({
  final User? user,
  final List<BookingSummary> bookings = const [],
  final HomeStatus status = HomeStatus.initial,
}) extends Equatable {
  HomeState copyWith({
    User? user,
    List<BookingSummary>? bookings,
    HomeStatus? status,
  }) {
    return HomeState(
      user: user ?? this.user,
      bookings: bookings ?? this.bookings,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [user, bookings, status];
}
