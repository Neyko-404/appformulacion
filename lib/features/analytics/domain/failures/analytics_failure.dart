enum AnalyticsFailureType {
  unauthenticated,
  unavailableData,
  sourceFailure,
  invalidData,
  unexpected,
}

final class AnalyticsFailure implements Exception {
  const AnalyticsFailure(this.type, this.safeMessage);

  final AnalyticsFailureType type;
  final String safeMessage;

  factory AnalyticsFailure.unauthenticated() => const AnalyticsFailure(
    AnalyticsFailureType.unauthenticated,
    'Necesitas una sesión válida para consultar tu progreso.',
  );

  factory AnalyticsFailure.source() => const AnalyticsFailure(
    AnalyticsFailureType.sourceFailure,
    'No pudimos consultar tu actividad de estudio.',
  );
}
