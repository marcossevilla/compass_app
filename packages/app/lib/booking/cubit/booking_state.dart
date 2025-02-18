part of 'booking_cubit.dart';

enum BookingStatus {
  initial,
  loading,
  loaded,
  loadingFailure,
  creating,
  created,
  creatingFailure,
  sharingFailure;

  bool get isInProgress => this == loading || this == creating;
}

class BookingState extends Equatable {
  const BookingState({
    this.booking,
    this.status = BookingStatus.initial,
  });

  final Booking? booking;
  final BookingStatus status;

  BookingState copyWith({
    Booking? booking,
    BookingStatus? status,
  }) {
    return BookingState(
      booking: booking ?? this.booking,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [booking, status];
}
