import 'package:cached_network_image/cached_network_image.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// Continent selection carousel.
///
/// Loads a list of continents in a horizontal carousel.
/// Users can tap one item to select it.
/// Tapping again the same item will deselect it.
class SearchFormContinent extends StatelessWidget {
  const SearchFormContinent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dimensions = context.dimensions;

    return SizedBox(
      height: 140,
      child: BlocBuilder<SearchFormCubit, SearchFormState>(
        builder: (context, state) {
          if (state.status == SearchFormStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SearchFormStatus.error) {
            return Center(
              child: ErrorIndicator(
                label: l10n.tryAgain,
                title: l10n.errorWhileLoadingContinents,
                onPressed: context.read<SearchFormCubit>().load,
              ),
            );
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.continents.length,
            padding: dimensions.edgeInsetsScreenHorizontal,
            itemBuilder: (context, index) {
              final Continent(:imageUrl, :name) = state.continents[index];
              return CarouselItem(
                key: ValueKey(name),
                name: name,
                imageUrl: imageUrl,
                selectedContinent: state.selectedContinent,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 8),
          );
        },
      ),
    );
  }
}

@visibleForTesting
class CarouselItem extends StatelessWidget {
  const CarouselItem({
    required this.name,
    required this.imageUrl,
    required this.selectedContinent,
    super.key,
  });

  final String name;
  final String imageUrl;
  final String? selectedContinent;

  bool get selected => selectedContinent == name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: imageUrl,
              errorWidget: (context, url, error) {
                // NOTE: Getting "invalid image data" error for some of the
                // images e.g. https://rstr.in/google/tripedia/jlbgFDrSUVE.
                return DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: const SizedBox(width: 140, height: 140),
                );
              },
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            // Overlay when other continent is selected.
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: selected ? 0 : 0.7,
                duration: kThemeChangeDuration,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    // Support dark-mode.
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            // Handle taps.
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (selectedContinent == name) {
                      return context
                          .read<SearchFormCubit>()
                          .updateSelectedContinent(null);
                    }

                    return context
                        .read<SearchFormCubit>()
                        .updateSelectedContinent(name);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
