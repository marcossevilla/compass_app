import 'package:compass_app/extensions/extensions.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Date selection form field.
///
/// Opens a date range picker dialog when tapped.
class SearchFormDate extends StatelessWidget {
  const SearchFormDate({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final dimensions = context.dimensions;

    return Padding(
      padding: EdgeInsets.only(
        top: dimensions.paddingVertical,
        left: dimensions.paddingScreenHorizontal,
        right: dimensions.paddingScreenHorizontal,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final dateRange = await showDateRangePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );

          if (!context.mounted) return;

          context.read<SearchFormCubit>().updateDateTimeRange(dateRange);
        },
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade100),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.paddingHorizontal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.when, style: textTheme.titleMedium),
                BlocBuilder<SearchFormCubit, SearchFormState>(
                  builder: (context, state) {
                    final dateRange = state.dateRange;
                    if (dateRange != null) {
                      return Text(
                        dateRange.dateFormatStartEnd,
                        style: textTheme.bodyLarge,
                      );
                    }

                    return Text(
                      l10n.addDates,
                      style: theme.inputDecorationTheme.hintStyle,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
