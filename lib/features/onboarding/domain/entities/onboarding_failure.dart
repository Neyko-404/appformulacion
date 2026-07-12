final class OnboardingFailure implements Exception {
  const OnboardingFailure._(this.type, this.safeMessage);

  factory OnboardingFailure.storage() => const OnboardingFailure._(
    OnboardingFailureType.storage,
    'No pudimos acceder a la configuración guardada.',
  );

  factory OnboardingFailure.corruptedData() => const OnboardingFailure._(
    OnboardingFailureType.corruptedData,
    'La configuración guardada no se pudo validar.',
  );

  final OnboardingFailureType type;
  final String safeMessage;
}

enum OnboardingFailureType { storage, corruptedData }
