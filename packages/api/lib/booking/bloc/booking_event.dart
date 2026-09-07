part of 'booking_bloc.dart';

sealed class BookingEvent extends Equatable {
  const new();
}

final class BookingAdded extends BookingEvent {
  const new(this.booking);

  final BookingApiModel booking;

  @override
  List<Object> get props => [booking];
}

final class BookingRemoved extends BookingEvent {
  const new(this.booking);

  final BookingApiModel booking;

  @override
  List<Object> get props => [booking];
}
