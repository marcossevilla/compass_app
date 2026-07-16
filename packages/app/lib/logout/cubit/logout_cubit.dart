import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:logging/logging.dart';
import 'package:models/models.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit({
    required this._authenticationRepository,
    required this._itineraryConfigRepository,
  }) : _log = Logger('LogoutCubit'),
       super(const LogoutState());

  final Logger _log;
  final AuthenticationRepository _authenticationRepository;
  final ItineraryConfigRepository _itineraryConfigRepository;

  Future<void> logout() async {
    try {
      emit(state.copyWith(status: LogoutStatus.loading));
      await _authenticationRepository.logout();
      _itineraryConfigRepository.itineraryConfig = const ItineraryConfig();
      emit(state.copyWith(status: LogoutStatus.success));
    } on Exception catch (e) {
      _log.warning('Logout failed', e);
      emit(state.copyWith(status: LogoutStatus.success));
    }
  }
}
