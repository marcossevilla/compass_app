import 'package:activity_repository/activity_repository.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/booking/booking.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';

enum _BookingMode { create, load }

class BookingPage extends StatelessWidget {
  const BookingPage.loadBooking({
    required int id,
    super.key,
  })  : _id = id,
        _mode = _BookingMode.load;

  const BookingPage.createBooking({super.key})
      : _id = null,
        _mode = _BookingMode.create;

  final _BookingMode _mode;
  final int? _id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bookingRepository = context.read<BookingRepository>();

        final bookingCreateUseCase = BookingCreateUseCase(
          bookingRepository: bookingRepository,
          activityRepository: context.read<ActivityRepository>(),
          destinationRepository: context.read<DestinationRepository>(),
        );

        final bookingShareUseCase = BookingShareUseCase.withSharePlus();

        final cubit = BookingCubit(
          createUseCase: bookingCreateUseCase,
          shareUseCase: bookingShareUseCase,
          bookingRepository: bookingRepository,
          itineraryConfigRepository: context.read<ItineraryConfigRepository>(),
        );

        return switch (_mode) {
          _BookingMode.create => cubit..createBooking(),
          _BookingMode.load => cubit..loadBooking(_id!),
        };
      },
      child: const BookingView(),
    );
  }
}

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final booking = context.select(
      (BookingCubit cubit) => cubit.state.booking,
    );

    return BlocListener<BookingCubit, BookingState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == BookingStatus.sharingFailure,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(l10n.errorWhileSharing),
              action: SnackBarAction(
                label: l10n.tryAgain,
                onPressed: context.read<BookingCubit>().shareBooking,
              ),
            ),
          );
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          // Back navigation always goes to home.
          if (!didPop) context.go(Routes.home);
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            // Workaround for https://github.com/flutter/flutter/issues/115358#issuecomment-2117157419.
            heroTag: null,
            key: const ValueKey('share-button'),
            onPressed: booking == null
                ? null
                : context.read<BookingCubit>().shareBooking,
            label: Text(l10n.shareTrip),
            icon: const Icon(Icons.share_outlined),
          ),
          body: BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              // If either command is running, show progress indicator.
              if (state.status.isInProgress) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // If fails to create booking, tap to try again.
              if (state.status == BookingStatus.creatingFailure) {
                return Center(
                  child: ErrorIndicator(
                    label: l10n.tryAgain,
                    title: l10n.errorWhileLoadingBooking,
                    onPressed: context.read<BookingCubit>().createBooking,
                  ),
                );
              }

              // If existing booking fails to load, tap to go home.
              if (state.status == BookingStatus.loadingFailure) {
                return Center(
                  child: ErrorIndicator(
                    label: l10n.close,
                    title: l10n.errorWhileLoadingBooking,
                    onPressed: () => context.go(Routes.home),
                  ),
                );
              }

              return const BookingBody();
            },
          ),
        ),
      ),
    );
  }
}
