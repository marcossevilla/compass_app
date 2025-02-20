part of 'activities_cubit.dart';

enum ActivitiesStatus {
  initial,
  loadingActivities,
  loadedActivities,
  failedLoadingActivities,
  savedActivities,
  failedSavingActivities,
}

class ActivitiesState extends Equatable {
  const ActivitiesState({
    this.daytimeActivities = const [],
    this.eveningActivities = const [],
    this.selectedActivities = const {},
    this.status = ActivitiesStatus.initial,
  });

  final List<Activity> daytimeActivities;
  final List<Activity> eveningActivities;
  final Set<String> selectedActivities;
  final ActivitiesStatus status;

  ActivitiesState copyWith({
    List<Activity>? daytimeActivities,
    List<Activity>? eveningActivities,
    Set<String>? selectedActivities,
    ActivitiesStatus? status,
  }) {
    return ActivitiesState(
      daytimeActivities: daytimeActivities ?? this.daytimeActivities,
      eveningActivities: eveningActivities ?? this.eveningActivities,
      selectedActivities: selectedActivities ?? this.selectedActivities,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props {
    return [daytimeActivities, eveningActivities, selectedActivities, status];
  }
}
