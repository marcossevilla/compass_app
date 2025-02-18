import 'package:bloc/bloc.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:user_repository/user_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required UserRepository userRepository,
    required BookingRepository bookingRepository,
  })  : _log = Logger('HomeCubit'),
        _userRepository = userRepository,
        _bookingRepository = bookingRepository,
        super(const HomeState());

  final Logger _log;
  final UserRepository _userRepository;
  final BookingRepository _bookingRepository;

  Future<void> load() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));

      final results = await Future.wait([
        _userRepository.getUser(),
        _bookingRepository.getBookingsList(),
      ]);

      emit(
        state.copyWith(
          user: results.first as User,
          bookings: results.last as List<BookingSummary>,
          status: HomeStatus.success,
        ),
      );

      _log.fine('Loaded user and bookings');
    } on Exception catch (error) {
      _log.warning('Failed to load user and bookings', error);
      emit(state.copyWith(status: HomeStatus.errorInitializing));
    }
  }

  Future<void> deleteBooking(int id) async {
    try {
      emit(state.copyWith(status: HomeStatus.deletingBooking));
      await _bookingRepository.delete(id);
      emit(state.copyWith(status: HomeStatus.bookingDeleted));
      _log.fine('Deleted booking $id');
    } on Exception catch (error) {
      _log.warning('Failed to delete booking $id', error);
      emit(state.copyWith(status: HomeStatus.errorWhileDeletingBooking));
    }

    try {
      // After deleting the booking, we need to reload the bookings list.
      // BookingRepository is the source of truth for bookings.
      final bookings = await _bookingRepository.getBookingsList();
      emit(state.copyWith(bookings: bookings));
      _log.fine('Loaded bookings');
    } on Exception catch (error) {
      _log.warning('Failed to load bookings', error);
    }

    // Reset the status to success after deleting a booking and reloading.
    emit(state.copyWith(status: HomeStatus.success));
  }
}
