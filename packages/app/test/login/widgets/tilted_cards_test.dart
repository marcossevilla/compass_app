import 'package:cached_network_image/cached_network_image.dart';
import 'package:compass_app/login/login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

void main() {
  group(TiltedCards, () {
    testWidgets('renders three cards and the logo', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(const TiltedCards());
      });

      expect(find.byType(CachedNetworkImage), findsNWidgets(3));
      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });
}
