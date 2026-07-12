import 'package:focusly/features/authentication/domain/entities/auth_user.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class Authenticated extends AuthState {
  const Authenticated(this.user);

  final AuthUser user;
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

final class PasswordResetSent extends AuthState {
  const PasswordResetSent({
    this.message = 'Si el correo está registrado, recibirás instrucciones.',
  });

  final String message;
}

final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;
}
