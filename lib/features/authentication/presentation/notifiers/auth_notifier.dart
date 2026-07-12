import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/authentication/authentication_providers.dart';
import 'package:focusly/features/authentication/domain/entities/auth_failure.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/presentation/state/auth_state.dart';

final class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    final subscription = ref
        .watch(authRepositoryProvider)
        .watchAuthState()
        .listen(
          (session) => state = state.withSession(session),
          onError: (Object error, StackTrace stackTrace) {
            state = state.fail(AuthFailure.unexpected().safeMessage);
          },
        );
    ref.onDispose(() => unawaited(subscription.cancel()));
    return const AuthState.initializing();
  }

  Future<void> signIn({required String email, required String password}) async {
    await _runSessionOperation(
      AuthOperation.signIn,
      () => ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password),
    );
  }

  Future<void> signUp({required String email, required String password}) async {
    if (!_begin(AuthOperation.signUp)) {
      return;
    }
    try {
      final repository = ref.read(authRepositoryProvider);
      final session = await repository.signUp(email: email, password: password);
      await repository.sendEmailVerification();
      state = state.finish(
        updatedSession: session,
        successMessage: 'Te enviamos un correo de verificación.',
      );
    } on AuthFailure catch (failure) {
      state = state.fail(failure.safeMessage);
    } on Object {
      state = state.fail(AuthFailure.unexpected().safeMessage);
    }
  }

  Future<void> requestPasswordReset({required String email}) async {
    if (!_begin(AuthOperation.passwordReset)) {
      return;
    }
    try {
      await ref.read(authRepositoryProvider).requestPasswordReset(email: email);
      state = state.finish(
        successMessage:
            'Si el correo está registrado, recibirás instrucciones.',
      );
    } on AuthFailure catch (failure) {
      state = state.fail(failure.safeMessage);
    } on Object {
      state = state.fail(AuthFailure.unexpected().safeMessage);
    }
  }

  Future<void> sendEmailVerification() async {
    if (!_begin(AuthOperation.emailVerification)) {
      return;
    }
    try {
      await ref.read(authRepositoryProvider).sendEmailVerification();
      state = state.finish(
        successMessage: 'Enviamos un nuevo correo de verificación.',
      );
    } on AuthFailure catch (failure) {
      state = state.fail(failure.safeMessage);
    } on Object {
      state = state.fail(AuthFailure.unexpected().safeMessage);
    }
  }

  Future<void> reloadSession() async {
    await _runSessionOperation(
      AuthOperation.reloadSession,
      ref.read(authRepositoryProvider).reloadSession,
    );
  }

  Future<void> signOut() async {
    if (!_begin(AuthOperation.signOut)) {
      return;
    }
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = state.finish(updatedSession: const AuthSession.unauthenticated());
    } on AuthFailure catch (failure) {
      state = state.fail(failure.safeMessage);
    } on Object {
      state = state.fail(AuthFailure.unexpected().safeMessage);
    }
  }

  void reset() {
    if (!state.isLoading) {
      state = state.clearFeedback();
    }
  }

  Future<void> _runSessionOperation(
    AuthOperation operation,
    Future<AuthSession> Function() action,
  ) async {
    if (!_begin(operation)) {
      return;
    }
    try {
      state = state.finish(updatedSession: await action());
    } on AuthFailure catch (failure) {
      state = state.fail(failure.safeMessage);
    } on Object {
      state = state.fail(AuthFailure.unexpected().safeMessage);
    }
  }

  bool _begin(AuthOperation operation) {
    if (state.isLoading) {
      return false;
    }
    state = state.begin(operation);
    return true;
  }
}
