part of 'activities_cubit.dart';

enum ActivitiesStatus {
  initial,
  loadingActivities,
  loadedActivities,
  failedLoadingActivities,
  savedActivities,
  failedSavingActivities,
}

class const ActivitiesState({
  final List<Activity> daytimeActivities = const [],
  final List<Activity> eveningActivities = const [],
  final Set<String> selectedActivities = const {},
  final ActivitiesStatus status = ActivitiesStatus.initial,
}) extends Equatable {
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
