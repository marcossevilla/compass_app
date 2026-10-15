import 'package:compass_app/booking/booking.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

void main() {
  final booking = Booking(
    startDate: DateTime(2024),
    endDate: DateTime(2024, 1, 5),
    destination: const Destination(
      ref: 'alaska',
      name: 'Alaska',
      country: 'United States',
      continent: 'North America',
      knownFor: 'Wildlife and glaciers',
      tags: ['Mountain', 'Hiking'],
      imageUrl: 'https://example.com/alaska.jpg',
    ),
    activities: const [],
  );

  group(BookingHeader, () {
    testWidgets('renders destination details', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(
          SingleChildScrollView(child: BookingHeader(booking: booking)),
        );
      });

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text('Alaska'), findsOneWidget);
      expect(find.text('1 - 5 Jan'), findsOneWidget);
      expect(find.text('Wildlife and glaciers'), findsOneWidget);
      expect(find.text(l10n.yourChosenActivities), findsOneWidget);
      expect(find.byType(HomeButton), findsOneWidget);
      expect(find.byType(TagChip), findsNWidgets(2));
    });

    testWidgets('uses a light chip color in dark mode', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(
          Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: SingleChildScrollView(
              child: BookingHeader(booking: booking),
            ),
          ),
        );
      });

      final chips = tester.widgetList<TagChip>(find.byType(TagChip));
      expect(chips.map((chip) => chip.chipColor), [
        const Color(0x4DFFFFFF),
        const Color(0x4DFFFFFF),
      ]);
    });

    testWidgets('uses a dark chip color in light mode', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(
          SingleChildScrollView(child: BookingHeader(booking: booking)),
        );
      });

      final chip = tester.widgetList<TagChip>(find.byType(TagChip)).first;
      expect(chip.chipColor, const Color(0x4D000000));
    });
  });
}
