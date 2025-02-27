part of 'booking_bloc.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

final class BookingAdded extends BookingEvent {
  const BookingAdded(this.booking);

  final BookingApiModel booking;

  @override
  List<Object> get props => [booking];
}

final class BookingRemoved extends BookingEvent {
  const BookingRemoved(this.booking);

  final BookingApiModel booking;

  @override
  List<Object> get props => [booking];
}
