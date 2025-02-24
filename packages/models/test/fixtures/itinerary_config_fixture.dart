Map<String, Object> itineraryConfigMap(DateTime date) => {
  'continent': 'continent',
  'startDate': date.toIso8601String(),
  'endDate': date.toIso8601String(),
  'guests': 0,
  'destination': 'destination',
  'activities': ['activities'],
};
