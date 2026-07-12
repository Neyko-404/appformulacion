import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/authentication/authentication_providers.dart';
import 'package:focusly/features/authentication/domain/entities/auth_failure.dart';
import 'package:focusly/features/authentication/presentation/state/auth_state.dart';

final class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthInitial();

  Future<void> signIn({required String email, required String password}) async {
    if (!_beginOperation()) {
      return;
    }
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
      state = Authenticated(user);
    } on AuthFailure catch (failure) {
      state = AuthError(failure.safeMessage);
    } on Object {
      state = AuthError(AuthFailure.unexpected().safeMessage);
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    if (!_beginOperation()) {
      return;
    }
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .signUp(email: email, password: password);
      state = Authenticated(user);
    } on AuthFailure catch (failure) {
      state = AuthError(failure.safeMessage);
    } on Object {
      state = AuthError(AuthFailure.unexpected().safeMessage);
    }
  }

  Future<void> requestPasswordReset({required String email}) async {
    if (!_beginOperation()) {
      return;
    }
    try {
      await ref.read(authRepositoryProvider).requestPasswordReset(email: email);
      state = const PasswordResetSent();
    } on AuthFailure catch (failure) {
      state = AuthError(failure.safeMessage);
    } on Object {
      state = AuthError(AuthFailure.unexpected().safeMessage);
    }
  }

  Future<void> signOut() async {
    if (!_beginOperation()) {
      return;
    }
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const Unauthenticated();
    } on Object {
      state = AuthError(AuthFailure.unexpected().safeMessage);
    }
  }

  void reset() {
    if (state is AuthLoading) {
      return;
    }
    state = const AuthInitial();
  }

  bool _beginOperation() {
    if (state is AuthLoading) {
      return false;
    }
    state = const AuthLoading();
    return true;
  }
}
