enum CompanionCustomizationFailureType {
  invalidData,
  corruptedData,
  storage,
  unexpected,
}

final class CompanionCustomizationFailure implements Exception {
  const CompanionCustomizationFailure(this.type, this.safeMessage);

  final CompanionCustomizationFailureType type;
  final String safeMessage;

  factory CompanionCustomizationFailure.invalidData() =>
      const CompanionCustomizationFailure(
        CompanionCustomizationFailureType.invalidData,
        'La personalización no es válida.',
      );

  factory CompanionCustomizationFailure.corruptedData() =>
      const CompanionCustomizationFailure(
        CompanionCustomizationFailureType.corruptedData,
        'La personalización guardada no se pudo validar.',
      );

  factory CompanionCustomizationFailure.storage() =>
      const CompanionCustomizationFailure(
        CompanionCustomizationFailureType.storage,
        'No pudimos acceder a la personalización guardada.',
      );

  factory CompanionCustomizationFailure.unexpected() =>
      const CompanionCustomizationFailure(
        CompanionCustomizationFailureType.unexpected,
        'No pudimos completar la operación.',
      );
}
