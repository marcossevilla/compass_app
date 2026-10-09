part of 'booking_bloc.dart';

sealed class const BookingEvent() extends Equatable;

final class const BookingAdded(final BookingApiModel booking)
    extends BookingEvent {
  @override
  List<Object> get props => [booking];
}

final class const BookingRemoved(final BookingApiModel booking)
    extends BookingEvent {
  @override
  List<Object> get props => [booking];
}
