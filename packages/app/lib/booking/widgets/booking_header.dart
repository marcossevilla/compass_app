import 'package:booking_repository/booking_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:compass_app/extensions/extensions.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';

class BookingHeader extends StatelessWidget {
  const BookingHeader({required this.booking, super.key});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dimensions = context.dimensions;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Top(booking: booking),
        Padding(
          padding: dimensions.edgeInsetsScreenHorizontal,
          child: Text(booking.destination.knownFor, style: textTheme.bodyLarge),
        ),
        SizedBox(height: dimensions.paddingVertical),
        _Tags(booking: booking),
        SizedBox(height: dimensions.paddingVertical),
        Padding(
          padding: dimensions.edgeInsetsScreenHorizontal,
          child: Text(
            l10n.yourChosenActivities,
            style: textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }
}

class _Top extends StatelessWidget {
  const _Top({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return SizedBox(
      height: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _HeaderImage(booking: booking),
          const _Gradient(),
          _Headline(booking: booking),
          Positioned(
            right: dimensions.paddingScreenHorizontal,
            top: dimensions.paddingScreenVertical,
            child: const SafeArea(child: HomeButton(blur: true)),
          ),
        ],
      ),
    );
  }
}

class _Tags extends StatelessWidget {
  const _Tags({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = context.dimensions;

    final chipColor = switch (theme.brightness) {
      Brightness.dark => const Color(0x4DFFFFFF),
      Brightness.light => const Color(0x4D000000),
    };

    return Padding(
      padding: dimensions.edgeInsetsScreenHorizontal,
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          ...booking.destination.tags.map(
            (tag) => TagChip(
              tag: tag,
              height: 32,
              fontSize: 16,
              chipColor: chipColor,
              onChipColor: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dimensions = context.dimensions;

    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: Padding(
        padding: dimensions.edgeInsetsScreenSymmetric,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(booking.destination.name, style: textTheme.headlineLarge),
            Text(
              DateTimeRange(
                start: booking.startDate,
                end: booking.endDate,
              ).dateFormatStartEnd,
              style: textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  const _HeaderImage({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.fitWidth,
      imageUrl: booking.destination.imageUrl,
    );
  }
}

class _Gradient extends StatelessWidget {
  const _Gradient();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Theme.of(context).colorScheme.surface],
        ),
      ),
    );
  }
}
