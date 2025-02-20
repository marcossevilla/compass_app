import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/routing/routes.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Search form submit button.
///
/// The button is disabled when the form is data is incomplete.
// ignore: comment_references
/// When tapped, it navigates to the [ResultsScreen]
/// passing the search options as query parameters.
class SearchFormSubmit extends StatelessWidget {
  const SearchFormSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dimensions = context.dimensions;
    final valid = context.select((SearchFormCubit cubit) => cubit.state.valid);

    return BlocListener<SearchFormCubit, SearchFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == SearchFormStatus.configSaved) {
          context.go(Routes.results);
        }

        if (state.status == SearchFormStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(l10n.errorWhileSavingItinerary),
                action: SnackBarAction(
                  label: l10n.tryAgain,
                  onPressed:
                      context.read<SearchFormCubit>().updateItineraryConfig,
                ),
              ),
            );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: dimensions.paddingVertical,
          left: dimensions.paddingScreenHorizontal,
          right: dimensions.paddingScreenHorizontal,
          bottom: dimensions.paddingScreenVertical,
        ),
        child: FilledButton(
          onPressed:
              valid
                  ? context.read<SearchFormCubit>().updateItineraryConfig
                  : null,
          child: SizedBox(
            height: 52,
            child: Center(child: Text(l10n.search.toUpperCase())),
          ),
        ),
      ),
    );
  }
}
