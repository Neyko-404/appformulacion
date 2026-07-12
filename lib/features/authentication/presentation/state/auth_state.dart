import 'package:focusly/features/authentication/domain/entities/auth_session.dart';

enum AuthOperation {
  idle,
  signIn,
  signUp,
  passwordReset,
  emailVerification,
  reloadSession,
  signOut,
}

final class AuthState {
  const AuthState({
    required this.session,
    required this.isInitializing,
    this.operation = AuthOperation.idle,
    this.message,
    this.errorMessage,
  });

  const AuthState.initializing()
    : this(session: const AuthSession.unauthenticated(), isInitializing: true);

  final AuthSession session;
  final bool isInitializing;
  final AuthOperation operation;
  final String? message;
  final String? errorMessage;

  bool get isLoading => operation != AuthOperation.idle;

  AuthState withSession(AuthSession value) => AuthState(
    session: value,
    isInitializing: false,
    operation: operation,
    message: message,
    errorMessage: errorMessage,
  );

  AuthState begin(AuthOperation value) => AuthState(
    session: session,
    isInitializing: isInitializing,
    operation: value,
  );

  AuthState finish({AuthSession? updatedSession, String? successMessage}) {
    return AuthState(
      session: updatedSession ?? session,
      isInitializing: false,
      message: successMessage,
    );
  }

  AuthState fail(String safeMessage) => AuthState(
    session: session,
    isInitializing: false,
    errorMessage: safeMessage,
  );

  AuthState clearFeedback() =>
      AuthState(session: session, isInitializing: isInitializing);
}
