import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockBookingRepository extends Mock implements BookingRepository {}

class MockContinentRepository extends Mock implements ContinentRepository {}

class MockDestinationRepository extends Mock implements DestinationRepository {}

class MockItineraryConfigRepository extends Mock
    implements ItineraryConfigRepository {}

class MockUserRepository extends Mock implements UserRepository {}
