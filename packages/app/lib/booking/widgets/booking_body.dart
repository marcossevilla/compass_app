import 'package:cached_network_image/cached_network_image.dart';
import 'package:compass_app/booking/booking.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class BookingBody extends StatelessWidget {
  const BookingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BookingCubit, BookingState, Booking?>(
      selector: (state) => state.booking,
      builder: (context, booking) {
        if (booking == null) return const SizedBox();

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: BookingHeader(booking: booking)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _Activity(activity: booking.activities[index]),
                childCount: booking.activities.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 200)),
          ],
        );
      },
    );
  }
}

class _Activity extends StatelessWidget {
  const _Activity({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        top: dimensions.paddingVertical,
        left: dimensions.paddingScreenHorizontal,
        right: dimensions.paddingScreenHorizontal,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: activity.imageUrl,
              height: 80,
              width: 80,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.timeOfDay.name.toUpperCase(),
                  style: textTheme.labelSmall,
                ),
                Text(
                  activity.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
                Text(
                  activity.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
