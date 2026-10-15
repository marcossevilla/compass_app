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

class const BookingState({
  final Booking? booking,
  final BookingStatus status = BookingStatus.initial,
}) extends Equatable {
  BookingState copyWith({Booking? booking, BookingStatus? status}) {
    return BookingState(
      booking: booking ?? this.booking,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [booking, status];
}
