// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get activities => 'Actividades';

  @override
  String get addDates => 'Agregar Fechas';

  @override
  String get bookingDeleted => 'Reserva eliminada';

  @override
  String get bookNewTrip => 'Reservar Nuevo Viaje';

  @override
  String get close => 'Cerrar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get daytime => 'Día';

  @override
  String get errorWhileDeletingBooking => 'Error al eliminar la reserva';

  @override
  String get errorWhileLoadingActivities => 'Error al cargar actividades';

  @override
  String get errorWhileLoadingBooking => 'Error al cargar la reserva';

  @override
  String get errorWhileLoadingContinents => 'Error al cargar continentes';

  @override
  String get errorWhileLoadingDestinations => 'Error al cargar destinos';

  @override
  String get errorWhileLoadingHome => 'Error al cargar inicio';

  @override
  String get errorWhileLogin => 'Error al intentar iniciar sesión';

  @override
  String get errorWhileLogout => 'Error al intentar cerrar sesión';

  @override
  String get errorWhileSavingActivities => 'Error al guardar actividades';

  @override
  String get errorWhileSavingItinerary => 'Error al guardar el itinerario';

  @override
  String get errorWhileSharing => 'Error al compartir la reserva';

  @override
  String get evening => 'Noche';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String nameTrips(String name) {
    return 'Viajes de $name';
  }

  @override
  String get search => 'Buscar';

  @override
  String get searchDestination => 'Buscar destino';

  @override
  String selected(int selection) {
    return '$selection seleccionado(s)';
  }

  @override
  String get shareTrip => 'Compartir Viaje';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get yourChosenActivities => 'Tus actividades seleccionadas';

  @override
  String get when => 'Cuándo';
}
