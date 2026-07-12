import 'package:focusly/features/authentication/domain/entities/auth_user.dart';

final class AuthSession {
  const AuthSession._({required this.user, required this.emailVerified})
    : assert(user != null || !emailVerified);

  const AuthSession.unauthenticated()
    : this._(user: null, emailVerified: false);

  const AuthSession.authenticated({
    required AuthUser user,
    required bool emailVerified,
  }) : this._(user: user, emailVerified: emailVerified);

  final AuthUser? user;
  final bool emailVerified;

  bool get isAuthenticated => user != null;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AuthSession &&
            other.user == user &&
            other.emailVerified == emailVerified;
  }

  @override
  int get hashCode => Object.hash(user, emailVerified);
}
