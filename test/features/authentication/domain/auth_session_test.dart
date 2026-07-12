import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';

void main() {
  const user = AuthUser(id: 'user-1', email: 'student@focusly.dev');

  test('unauthenticated session has no user and is not verified', () {
    const session = AuthSession.unauthenticated();

    expect(session.user, isNull);
    expect(session.isAuthenticated, isFalse);
    expect(session.emailVerified, isFalse);
  });

  test('authenticated session exposes its user', () {
    const session = AuthSession.authenticated(user: user, emailVerified: false);

    expect(session.user, user);
    expect(session.isAuthenticated, isTrue);
    expect(session.emailVerified, isFalse);
  });

  test('verified session keeps verification in one location', () {
    const session = AuthSession.authenticated(user: user, emailVerified: true);

    expect(session.emailVerified, isTrue);
    expect(session.user, user);
  });

  test('sessions with the same values are equal', () {
    expect(
      const AuthSession.authenticated(user: user, emailVerified: true),
      const AuthSession.authenticated(user: user, emailVerified: true),
    );
  });
}
