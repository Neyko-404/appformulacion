enum StudySessionFailureType {
  invalidData,
  invalidTransition,
  activeSessionAlreadyExists,
  notFound,
  unauthorizedAccess,
  storage,
  corruptedData,
  unexpected,
}

final class StudySessionFailure implements Exception {
  const StudySessionFailure(this.type, this.safeMessage);
  final StudySessionFailureType type;
  final String safeMessage;
  factory StudySessionFailure.invalidTransition() => const StudySessionFailure(
    StudySessionFailureType.invalidTransition,
    'La sesión no permite esa acción.',
  );
  factory StudySessionFailure.activeExists() => const StudySessionFailure(
    StudySessionFailureType.activeSessionAlreadyExists,
    'Ya existe una sesión activa.',
  );
  factory StudySessionFailure.storage() => const StudySessionFailure(
    StudySessionFailureType.storage,
    'No pudimos guardar la sesión.',
  );
  factory StudySessionFailure.corrupted() => const StudySessionFailure(
    StudySessionFailureType.corruptedData,
    'Una sesión guardada no se pudo validar.',
  );
}
