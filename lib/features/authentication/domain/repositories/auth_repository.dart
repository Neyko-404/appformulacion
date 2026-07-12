import 'package:focusly/features/authentication/domain/entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<AuthSession> getCurrentSession();

  Stream<AuthSession> watchAuthState();

  Future<AuthSession> signIn({required String email, required String password});

  Future<AuthSession> signUp({required String email, required String password});

  Future<void> requestPasswordReset({required String email});

  Future<void> sendEmailVerification();

  Future<AuthSession> reloadSession();

  Future<void> signOut();
}
