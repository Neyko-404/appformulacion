enum FocusGoalFailureType { invalidData, storage, corruptedData, unexpected }

final class FocusGoalFailure implements Exception {
  const FocusGoalFailure._(this.type, this.safeMessage);

  factory FocusGoalFailure.invalidData() => const FocusGoalFailure._(
    FocusGoalFailureType.invalidData,
    'Revisa los valores de tus metas.',
  );

  factory FocusGoalFailure.storage() => const FocusGoalFailure._(
    FocusGoalFailureType.storage,
    'No pudimos guardar tus metas. Inténtalo nuevamente.',
  );

  factory FocusGoalFailure.corruptedData() => const FocusGoalFailure._(
    FocusGoalFailureType.corruptedData,
    'No pudimos leer tus metas guardadas.',
  );

  factory FocusGoalFailure.unexpected() => const FocusGoalFailure._(
    FocusGoalFailureType.unexpected,
    'Ocurrió un problema inesperado con tus metas.',
  );

  final FocusGoalFailureType type;
  final String safeMessage;

  @override
  String toString() => 'FocusGoalFailure(${type.name})';
}
