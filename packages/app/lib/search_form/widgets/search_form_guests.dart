import 'package:compass_app/search_form/search_form.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Number of guests selection form.
///
/// Users can tap the Plus and Minus icons to increase or decrease
/// the number of guests.
class SearchFormGuests extends StatelessWidget {
  const SearchFormGuests({super.key});

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return Padding(
      padding: EdgeInsets.only(
        top: dimensions.paddingVertical,
        left: dimensions.paddingScreenHorizontal,
        right: dimensions.paddingScreenHorizontal,
      ),
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
              Text('Who', style: Theme.of(context).textTheme.titleMedium),
              const QuantitySelector(),
            ],
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class QuantitySelector extends StatelessWidget {
  const QuantitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: context.read<SearchFormCubit>().decrementGuests,
            child: Icon(
              Icons.remove_circle_outline,
              color: Colors.grey.shade300,
            ),
          ),
          BlocSelector<SearchFormCubit, SearchFormState, int>(
            selector: (state) => state.guests,
            builder:
                (context, state) => Text(
                  state.toString(),
                  style:
                      state == 0
                          ? theme.inputDecorationTheme.hintStyle
                          : theme.textTheme.bodyMedium,
                ),
          ),
          InkWell(
            onTap: context.read<SearchFormCubit>().incrementGuests,
            child: Icon(Icons.add_circle_outline, color: Colors.grey.shade300),
          ),
        ],
      ),
    );
  }
}
