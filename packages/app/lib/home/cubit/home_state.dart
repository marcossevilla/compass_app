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

class HomeState extends Equatable {
  const HomeState({
    this.user,
    this.bookings = const [],
    this.status = HomeStatus.initial,
  });

  final User? user;
  final List<BookingSummary> bookings;
  final HomeStatus status;

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
