import 'package:authentication_repository/authentication_repository.dart';
import 'package:compass_app/home/home.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/logout/logout.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

void main() {
  group(HomeHeader, () {
    late AuthenticationRepository authenticationRepository;
    late ItineraryConfigRepository itineraryConfigRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
    });

    Widget buildSubject(User? user) {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authenticationRepository),
          RepositoryProvider.value(value: itineraryConfigRepository),
        ],
        child: HomeHeader(user: user),
      );
    }

    testWidgets('renders nothing when user is null', (tester) async {
      await tester.pumpApp(buildSubject(null));

      expect(find.byType(LogoutButton), findsNothing);
      expect(find.byType(Title), findsNothing);
    });

    testWidgets('renders picture, logout button and title', (tester) async {
      const user = User(name: 'Sofie', picture: 'assets/user.jpg');
      await tester.pumpApp(buildSubject(user));

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(LogoutButton), findsOneWidget);
      expect(find.text(l10n.nameTrips(user.name)), findsOneWidget);
      expect(find.byType(ShaderMask), findsOneWidget);
    });
  });
}
