import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/logout/logout.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:models/models.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({required this.user, super.key});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dimensions = context.dimensions;

    if (user == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.asset(
                user!.picture,
                width: dimensions.profilePictureSize,
                height: dimensions.profilePictureSize,
              ),
            ),
            const LogoutButton(),
          ],
        ),
        SizedBox(height: dimensions.paddingVertical),
        Title(text: l10n.nameTrips(user!.name)),
      ],
    );
  }
}

@visibleForTesting
class Title extends StatelessWidget {
  const Title({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.bottomLeft,
        radius: 2,
        colors: [Colors.purple.shade700, Colors.purple.shade400],
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: GoogleFonts.rubik(
          textStyle: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
