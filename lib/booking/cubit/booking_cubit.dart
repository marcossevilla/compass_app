import 'package:bloc/bloc.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/booking/booking.dart';
import 'package:equatable/equatable.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:logging/logging.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({
    required BookingCreateUseCase createUseCase,
    required BookingShareUseCase shareUseCase,
    required BookingRepository bookingRepository,
    required ItineraryConfigRepository itineraryConfigRepository,
  })  : _log = Logger('BookingCubit'),
        _createUseCase = createUseCase,
        _shareUseCase = shareUseCase,
        _bookingRepository = bookingRepository,
        _itineraryConfigRepository = itineraryConfigRepository,
        super(const BookingState());

  final Logger _log;
  final BookingCreateUseCase _createUseCase;
  final BookingShareUseCase _shareUseCase;
  final BookingRepository _bookingRepository;
  final ItineraryConfigRepository _itineraryConfigRepository;

  Future<void> createBooking() async {
    try {
      _log.fine('Creating booking...');

      emit(state.copyWith(status: BookingStatus.creating));

      final booking = await _createUseCase.createFrom(
        _itineraryConfigRepository.itineraryConfig,
      );

      emit(
        state.copyWith(
          booking: booking,
          status: BookingStatus.created,
        ),
      );

      _log.fine('Created Booking');
    } on Exception catch (e) {
      _log.warning('Booking error: $e');
      emit(state.copyWith(status: BookingStatus.creatingFailure));
    }
  }

  Future<void> loadBooking(int id) async {
    try {
      _log.fine('Loading booking $id');
      emit(state.copyWith(status: BookingStatus.loading));

      final booking = await _bookingRepository.getBooking(id);
      _log.fine('Loaded booking $id');

      emit(
        state.copyWith(
          booking: booking,
          status: BookingStatus.loaded,
        ),
      );
    } on Exception catch (e) {
      _log.warning('Failed to load booking $id', e);
      emit(state.copyWith(status: BookingStatus.loadingFailure));
    }
  }

  Future<void> shareBooking() async {
    final currentStatus = state.status;
    try {
      _log.fine('Sharing booking...');
      await _shareUseCase.shareBooking(state.booking!);
      _log.fine('Shared booking');
    } on Exception catch (e) {
      _log.warning('Failed to share booking', e);
      emit(state.copyWith(status: BookingStatus.sharingFailure));
    } finally {
      emit(state.copyWith(status: currentStatus));
    }
  }
}
