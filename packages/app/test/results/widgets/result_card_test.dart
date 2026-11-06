import 'package:cached_network_image/cached_network_image.dart';
import 'package:compass_app/results/results.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ResultCard, () {
    const destination = Destination(
      ref: 'alps',
      name: 'Alps',
      country: 'Switzerland',
      continent: 'Europe',
      knownFor: 'Mountains',
      tags: ['Mountain', 'Skiing'],
      imageUrl: 'https://example.com/alps.jpg',
    );

    Widget buildSubject({GestureTapCallback? onTap}) {
      return SizedBox(
        width: 182,
        height: 222,
        child: ResultCard(destination: destination, onTap: onTap ?? () {}),
      );
    }

    testWidgets('renders name, tags and image', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(buildSubject());
      });

      expect(find.text('ALPS'), findsOneWidget);
      expect(find.byType(TagChip), findsNWidgets(2));
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await mockNetworkImages(() async {
        await tester.pumpApp(buildSubject(onTap: () => tapped = true));
        await tester.tap(find.byType(InkWell));
      });

      expect(tapped, isTrue);
    });

    testWidgets('errorWidget builds an error icon', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(buildSubject());
      });

      final image = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      final context = tester.element(find.byType(CachedNetworkImage));
      final errorWidget = image.errorWidget!(
        context,
        destination.imageUrl,
        Exception('oops'),
      );

      expect(
        errorWidget,
        isA<Icon>().having((icon) => icon.icon, 'icon', Icons.error),
      );
    });
  });
}
