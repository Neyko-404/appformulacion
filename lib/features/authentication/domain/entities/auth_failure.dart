enum AuthFailureCode {
  invalidCredentials,
  invalidEmail,
  emailAlreadyInUse,
  weakPassword,
  tooManyAttempts,
  networkUnavailable,
  userDisabled,
  operationNotAllowed,
  unexpected,
}

final class AuthFailure implements Exception {
  const AuthFailure({required this.code, required this.safeMessage});

  factory AuthFailure.invalidCredentials() => const AuthFailure(
    code: AuthFailureCode.invalidCredentials,
    safeMessage: 'No pudimos iniciar sesión con esos datos.',
  );

  factory AuthFailure.invalidEmail() => const AuthFailure(
    code: AuthFailureCode.invalidEmail,
    safeMessage: 'Revisa el formato del correo e inténtalo nuevamente.',
  );

  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
    code: AuthFailureCode.emailAlreadyInUse,
    safeMessage: 'No pudimos crear la cuenta con ese correo.',
  );

  factory AuthFailure.weakPassword() => const AuthFailure(
    code: AuthFailureCode.weakPassword,
    safeMessage: 'La contraseña necesita ser más segura.',
  );

  factory AuthFailure.tooManyAttempts() => const AuthFailure(
    code: AuthFailureCode.tooManyAttempts,
    safeMessage: 'Espera un momento antes de intentarlo nuevamente.',
  );

  factory AuthFailure.networkUnavailable() => const AuthFailure(
    code: AuthFailureCode.networkUnavailable,
    safeMessage: 'Revisa tu conexión e inténtalo nuevamente.',
  );

  factory AuthFailure.userDisabled() => const AuthFailure(
    code: AuthFailureCode.userDisabled,
    safeMessage: 'Esta cuenta no está disponible. Solicita ayuda.',
  );

  factory AuthFailure.operationNotAllowed() => const AuthFailure(
    code: AuthFailureCode.operationNotAllowed,
    safeMessage: 'Esta operación no está disponible por el momento.',
  );

  factory AuthFailure.unexpected() => const AuthFailure(
    code: AuthFailureCode.unexpected,
    safeMessage: 'Ocurrió un problema. Inténtalo nuevamente.',
  );

  final AuthFailureCode code;
  final String safeMessage;

  @override
  String toString() => 'AuthFailure(${code.name})';
}
