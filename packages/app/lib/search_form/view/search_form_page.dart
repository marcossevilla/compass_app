import 'package:compass_app/routing/routing.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';

class SearchFormPage extends StatelessWidget {
  const SearchFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => SearchFormCubit(
            continentRepository: context.read<ContinentRepository>(),
            itineraryConfigRepository:
                context.read<ItineraryConfigRepository>(),
          )..load(),
      child: const SearchFormView(),
    );
  }
}

class SearchFormView extends StatelessWidget {
  const SearchFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) context.go(Routes.home);
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  top: dimensions.paddingScreenVertical,
                  left: dimensions.paddingScreenHorizontal,
                  right: dimensions.paddingScreenHorizontal,
                  bottom: dimensions.paddingVertical,
                ),
                child: const AppSearchBar(),
              ),
            ),
            const SearchFormContinent(),
            const SearchFormDate(),
            const SearchFormGuests(),
            const Spacer(),
            const SearchFormSubmit(),
          ],
        ),
      ),
    );
  }
}
