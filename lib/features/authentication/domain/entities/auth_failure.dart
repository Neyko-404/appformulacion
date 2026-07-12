enum AuthFailureCode { invalidCredentials, emailAlreadyInUse, unexpected }

final class AuthFailure implements Exception {
  const AuthFailure({required this.code, required this.safeMessage});

  factory AuthFailure.invalidCredentials() => const AuthFailure(
    code: AuthFailureCode.invalidCredentials,
    safeMessage: 'No pudimos iniciar sesión con esos datos.',
  );

  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
    code: AuthFailureCode.emailAlreadyInUse,
    safeMessage: 'No pudimos crear la cuenta con ese correo.',
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
