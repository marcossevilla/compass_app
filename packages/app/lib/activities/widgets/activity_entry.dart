import 'package:cached_network_image/cached_network_image.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class const ActivityEntry({
  required final Activity activity,
  required final bool selected,
  required final ValueChanged<bool?> onChanged,
  super.key,
}) extends StatelessWidget {
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
