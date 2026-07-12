import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:focusly/core/logging/app_logger.dart';
import 'package:focusly/features/authentication/data/services/firebase_auth_service.dart';
import 'package:focusly/features/authentication/domain/entities/auth_failure.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/authentication/domain/repositories/auth_repository.dart';

final class FirebaseAuthRepository implements AuthRepository {
  const FirebaseAuthRepository(
    this._service, [
    this._logger = const AppLogger(),
  ]);

  final FirebaseAuthService _service;
  final AppLogger _logger;

  @override
  Future<AuthSession> getCurrentSession() async {
    return mapFirebaseUserToSession(_service.currentUser);
  }

  @override
  Stream<AuthSession> watchAuthState() {
    return _service.authStateChanges().transform(
      StreamTransformer.fromHandlers(
        handleData: (user, sink) => sink.add(mapFirebaseUserToSession(user)),
        handleError: (Object error, StackTrace stackTrace, sink) {
          _logTechnicalError(error, stackTrace);
          sink.addError(
            error is FirebaseAuthException
                ? mapFirebaseAuthException(error)
                : AuthFailure.unexpected(),
            stackTrace,
          );
        },
      ),
    );
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    return _guard(
      () async => mapFirebaseUserToSession(
        await _service.signIn(email: email, password: password),
      ),
    );
  }

  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
  }) async {
    return _guard(
      () async => mapFirebaseUserToSession(
        await _service.signUp(email: email, password: password),
      ),
    );
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    try {
      await _service.sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (error, stackTrace) {
      if (error.code == 'user-not-found') {
        return;
      }
      _logTechnicalError(error, stackTrace);
      throw mapFirebaseAuthException(error);
    } on Object catch (error, stackTrace) {
      _logTechnicalError(error, stackTrace);
      throw AuthFailure.unexpected();
    }
  }

  @override
  Future<void> sendEmailVerification() =>
      _guard(_service.sendEmailVerification);

  @override
  Future<AuthSession> reloadSession() => _guard(
    () async => mapFirebaseUserToSession(await _service.reloadCurrentUser()),
  );

  @override
  Future<void> signOut() => _guard(_service.signOut);

  Future<T> _guard<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on FirebaseAuthException catch (error, stackTrace) {
      _logTechnicalError(error, stackTrace);
      throw mapFirebaseAuthException(error);
    } on Object catch (error, stackTrace) {
      _logTechnicalError(error, stackTrace);
      throw AuthFailure.unexpected();
    }
  }

  void _logTechnicalError(Object error, StackTrace stackTrace) {
    _logger.error(
      'Firebase Authentication operation failed',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

AuthSession mapFirebaseUserToSession(FirebaseAuthUserData? firebaseUser) {
  if (firebaseUser == null) {
    return const AuthSession.unauthenticated();
  }
  return AuthSession.authenticated(
    user: AuthUser(id: firebaseUser.id, email: firebaseUser.email ?? ''),
    emailVerified: firebaseUser.emailVerified,
  );
}

AuthFailure mapFirebaseAuthException(FirebaseAuthException error) {
  return switch (error.code) {
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' => AuthFailure.invalidCredentials(),
    'invalid-email' => AuthFailure.invalidEmail(),
    'email-already-in-use' => AuthFailure.emailAlreadyInUse(),
    'weak-password' => AuthFailure.weakPassword(),
    'too-many-requests' => AuthFailure.tooManyAttempts(),
    'network-request-failed' => AuthFailure.networkUnavailable(),
    'user-disabled' => AuthFailure.userDisabled(),
    'operation-not-allowed' => AuthFailure.operationNotAllowed(),
    _ => AuthFailure.unexpected(),
  };
}
