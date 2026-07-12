import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/authentication/data/repositories/in_memory_auth_repository.dart';
import 'package:focusly/features/authentication/domain/entities/auth_failure.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';

void main() {
  late InMemoryAuthRepository repository;

  setUp(() {
    repository = InMemoryAuthRepository(
      seedAccounts: const {'student@focusly.dev': 'password123'},
    );
  });
  tearDown(() => repository.dispose());

  test('starts unauthenticated', () async {
    expect(
      await repository.getCurrentSession(),
      const AuthSession.unauthenticated(),
    );
  });

  test('registers as unverified and never stores a plain password', () async {
    final session = await repository.signUp(
      email: 'new@focusly.dev',
      password: 'new-password',
    );
    expect(session.isAuthenticated, isTrue);
    expect(session.emailVerified, isFalse);
  });

  test('rejects duplicate email', () async {
    await expectLater(
      repository.signUp(
        email: 'student@focusly.dev',
        password: 'other-password',
      ),
      throwsA(isA<AuthFailure>()),
    );
  });

  test('signs in a seeded verified account', () async {
    final session = await repository.signIn(
      email: 'student@focusly.dev',
      password: 'password123',
    );
    expect(session.emailVerified, isTrue);
  });

  test('rejects invalid credentials safely', () async {
    await expectLater(
      repository.signIn(
        email: 'student@focusly.dev',
        password: 'incorrect-password',
      ),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.code,
          'code',
          AuthFailureCode.invalidCredentials,
        ),
      ),
    );
  });

  test('emits session changes and signs out', () async {
    final events = <AuthSession>[];
    final initialEvent = Completer<void>();
    final subscription = repository.watchAuthState().listen((session) {
      events.add(session);
      if (!initialEvent.isCompleted) {
        initialEvent.complete();
      }
    });
    addTearDown(subscription.cancel);
    await initialEvent.future;

    await repository.signIn(
      email: 'student@focusly.dev',
      password: 'password123',
    );
    await repository.signOut();

    expect(events.map((session) => session.isAuthenticated), [
      false,
      true,
      false,
    ]);
  });

  test('simulates verification and reload deterministically', () async {
    await repository.signUp(email: 'new@focusly.dev', password: 'new-password');
    await repository.sendEmailVerification();
    repository.markCurrentEmailVerified();

    expect((await repository.reloadSession()).emailVerified, isTrue);
  });

  test('password recovery never reveals account existence', () async {
    await expectLater(
      repository.requestPasswordReset(email: 'unknown@focusly.dev'),
      completes,
    );
  });
}
