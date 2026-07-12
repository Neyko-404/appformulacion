import 'package:focusly/features/authentication/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthUser?> getCurrentUser();

  Stream<AuthUser?> watchAuthState();

  Future<AuthUser> signIn({required String email, required String password});

  Future<AuthUser> signUp({required String email, required String password});

  Future<void> requestPasswordReset({required String email});

  Future<void> signOut();
}
