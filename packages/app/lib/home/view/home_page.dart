import 'package:compass_app/extensions/extensions.dart';
import 'package:compass_app/home/home.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.homeCubit, super.key});

  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: homeCubit, child: const HomeView());
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dimensions = context.dimensions;

    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == HomeStatus.bookingDeleted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.bookingDeleted)));
        }

        if (state.status == HomeStatus.errorWhileDeletingBooking) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.errorWhileDeletingBooking)),
            );
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          // Workaround for https://github.com/flutter/flutter/issues/115358#issuecomment-2117157419
          heroTag: null,
          key: const ValueKey('booking-button'),
          icon: const Icon(Icons.add_location_outlined),
          label: Text(l10n.bookNewTrip.toUpperCase()),
          onPressed: () => context.go(Routes.search),
        ),
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state.status == HomeStatus.loading ||
                  state.status == HomeStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == HomeStatus.errorInitializing) {
                return ErrorIndicator(
                  label: l10n.tryAgain,
                  title: l10n.errorWhileLoadingHome,
                  onPressed: context.read<HomeCubit>().load,
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: dimensions.paddingScreenVertical,
                        horizontal: dimensions.paddingScreenHorizontal,
                      ),
                      child: HomeHeader(user: state.user),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: state.bookings.length,
                    itemBuilder: (_, index) {
                      final booking = state.bookings[index];

                      return _Booking(
                        key: ValueKey(booking.id),
                        booking: booking,
                        onTap:
                            () =>
                                context.push(Routes.bookingWithId(booking.id)),
                        confirmDismiss: (_) async {
                          // Wait for command to complete.
                          await context.read<HomeCubit>().deleteBooking(
                            booking.id,
                          );

                          // If command completed successfully, return true.
                          // Removes the dismissable from the list.
                          return true;
                        },
                      );
                    },
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

class _Booking extends StatelessWidget {
  const _Booking({
    required this.booking,
    required this.onTap,
    required this.confirmDismiss,
    super.key,
  });

  final BookingSummary booking;
  final GestureTapCallback onTap;
  final ConfirmDismissCallback confirmDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final dimensions = context.dimensions;

    return Dismissible(
      key: ValueKey(booking.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: confirmDismiss,
      background: ColoredBox(
        color: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: dimensions.paddingHorizontal),
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: dimensions.paddingVertical,
            horizontal: dimensions.paddingScreenHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(booking.name, style: textTheme.titleLarge),
              Text(
                DateTimeRange(
                  start: booking.startDate,
                  end: booking.endDate,
                ).dateFormatStartEnd,
                style: textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
