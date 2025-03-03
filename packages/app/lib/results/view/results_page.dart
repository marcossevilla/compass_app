import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/results/results.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:models/models.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ResultsCubit(
            destinationRepository: context.read<DestinationRepository>(),
            itineraryConfigRepository:
                context.read<ItineraryConfigRepository>(),
          )..search(),
      child: const ResultsView(),
    );
  }
}

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dimensions = context.dimensions;

    return BlocListener<ResultsCubit, ResultsState>(
      listener: (context, state) {
        if (state.status == ResultsStatus.updatedConfig) {
          context.go(Routes.activities);
        }

        if (state.status == ResultsStatus.updateConfigFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.errorWhileSavingItinerary)),
            );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, r) {
          if (!didPop) context.go(Routes.search);
        },
        child: Scaffold(
          body: BlocBuilder<ResultsCubit, ResultsState>(
            builder: (context, state) {
              if (state.status == ResultsStatus.searchCompleted) {
                return Padding(
                  padding: dimensions.edgeInsetsScreenHorizontal,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: ResultsSearchBar(
                          itineraryConfig: state.itineraryConfig,
                        ),
                      ),
                      Grid(destinations: state.destinations),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  ResultsSearchBar(itineraryConfig: state.itineraryConfig),
                  if (state.status == ResultsStatus.searching)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (state.status == ResultsStatus.searchFailure)
                    Expanded(
                      child: Center(
                        child: ErrorIndicator(
                          label: l10n.tryAgain,
                          title: l10n.errorWhileLoadingDestinations,
                          onPressed: context.read<ResultsCubit>().search,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class ResultsSearchBar extends StatelessWidget {
  const ResultsSearchBar({required this.itineraryConfig, super.key});

  final ItineraryConfig itineraryConfig;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          top: dimensions.paddingScreenVertical,
          bottom: AppDimensions.mobile.paddingScreenVertical,
        ),
        child: AppSearchBar(
          config: itineraryConfig,
          // Navigate to [SearchFormScreen] and edit search.
          onTap: context.pop,
        ),
      ),
    );
  }
}

@visibleForTesting
class Grid extends StatelessWidget {
  const Grid({required this.destinations, super.key});

  final List<Destination> destinations;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 182 / 222,
      ),
      delegate: SliverChildBuilderDelegate(childCount: destinations.length, (
        context,
        index,
      ) {
        final destination = destinations[index];
        return ResultCard(
          key: ValueKey(destination.ref),
          destination: destination,
          onTap:
              () => context.read<ResultsCubit>().updateItineraryConfig(
                destination.ref,
              ),
        );
      }),
    );
  }
}
