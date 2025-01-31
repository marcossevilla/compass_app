import 'package:activity_repository/activity_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';

class ActivityEntry extends StatelessWidget {
  const ActivityEntry({
    required this.activity,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Activity activity;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 80,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              width: 80,
              height: 80,
              imageUrl: activity.imageUrl,
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          AppCheckbox(
            key: ValueKey('${activity.ref}-checkbox'),
            value: selected,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
