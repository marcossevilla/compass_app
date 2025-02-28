import 'package:api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingState.initial()) {
    on<BookingAdded>(_onBookingAdded);
    on<BookingRemoved>(_onBookingRemoved);
  }

  void _onBookingAdded(BookingAdded event, Emitter<BookingState> emit) {
    emit(
      BookingState(
        bookings: [...state.bookings, event.booking],
        sequentialId: state.sequentialId + 1,
      ),
    );
  }

  void _onBookingRemoved(BookingRemoved event, Emitter<BookingState> emit) {
    final bookings = state.bookings.whereNot(
      (booking) => booking == event.booking,
    );

    emit(
      BookingState(bookings: [...bookings], sequentialId: state.sequentialId),
    );
  }
}
