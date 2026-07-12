import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/authentication/data/repositories/firebase_auth_repository.dart';
import 'package:focusly/features/authentication/data/services/firebase_auth_service.dart';
import 'package:focusly/features/authentication/domain/entities/auth_failure.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';

void main() {
  const unverified = FirebaseAuthUserData(
    id: 'firebase-1',
    email: 'student@focusly.dev',
    emailVerified: false,
  );
  const verified = FirebaseAuthUserData(
    id: 'firebase-1',
    email: 'student@focusly.dev',
    emailVerified: true,
  );

  test('maps null user to unauthenticated session', () {
    expect(mapFirebaseUserToSession(null).isAuthenticated, isFalse);
  });

  test('maps Firebase user and verification to Domain', () {
    final session = mapFirebaseUserToSession(verified);

    expect(session.user?.id, 'firebase-1');
    expect(session.user?.email, 'student@focusly.dev');
    expect(session.emailVerified, isTrue);
  });

  test('maps a null Firebase email safely', () {
    final session = mapFirebaseUserToSession(
      const FirebaseAuthUserData(
        id: 'firebase-2',
        email: null,
        emailVerified: false,
      ),
    );

    expect(session.user?.email, isEmpty);
  });

  group('error translation', () {
    final cases = {
      'invalid-credential': AuthFailureCode.invalidCredentials,
      'email-already-in-use': AuthFailureCode.emailAlreadyInUse,
      'weak-password': AuthFailureCode.weakPassword,
      'too-many-requests': AuthFailureCode.tooManyAttempts,
      'network-request-failed': AuthFailureCode.networkUnavailable,
      'unknown-code': AuthFailureCode.unexpected,
    };

    for (final entry in cases.entries) {
      test('maps ${entry.key}', () {
        final failure = mapFirebaseAuthException(
          FirebaseAuthException(code: entry.key),
        );
        expect(failure.code, entry.value);
      });
    }
  });

  group('FirebaseAuthRepository', () {
    late _FakeFirebaseAuthService service;
    late FirebaseAuthRepository repository;

    setUp(() {
      service = _FakeFirebaseAuthService(current: unverified);
      repository = FirebaseAuthRepository(service);
    });

    tearDown(() => service.dispose());

    test('returns the current session', () async {
      final session = await repository.getCurrentSession();
      expect(session.user?.id, 'firebase-1');
      expect(session.emailVerified, isFalse);
    });

    test('maps session stream', () async {
      final expectation = expectLater(
        repository.watchAuthState().take(2),
        emitsInOrder([
          isA<AuthSession>().having(
            (session) => session.emailVerified,
            'verified',
            false,
          ),
          isA<AuthSession>().having(
            (session) => session.emailVerified,
            'verified',
            true,
          ),
        ]),
      );
      service.emit(verified);
      await expectation;
    });

    test('signs in', () async {
      service.signInResult = verified;
      final session = await repository.signIn(
        email: 'student@focusly.dev',
        password: 'password123',
      );
      expect(session.emailVerified, isTrue);
    });

    test('registers', () async {
      service.signUpResult = unverified;
      final session = await repository.signUp(
        email: 'student@focusly.dev',
        password: 'password123',
      );
      expect(session.emailVerified, isFalse);
    });

    test('requests password recovery', () async {
      await repository.requestPasswordReset(email: 'student@focusly.dev');
      expect(service.passwordResetCalls, 1);
    });

    test('does not reveal user-not-found during recovery', () async {
      service.failure = FirebaseAuthException(code: 'user-not-found');
      await expectLater(
        repository.requestPasswordReset(email: 'unknown@focusly.dev'),
        completes,
      );
    });

    test('sends verification', () async {
      await repository.sendEmailVerification();
      expect(service.verificationCalls, 1);
    });

    test('reloads session', () async {
      service.reloadResult = verified;
      final session = await repository.reloadSession();
      expect(session.emailVerified, isTrue);
    });

    test('signs out', () async {
      await repository.signOut();
      expect(service.signOutCalls, 1);
    });

    test('translates Firebase failures', () async {
      service.failure = FirebaseAuthException(code: 'network-request-failed');
      await expectLater(
        repository.signIn(
          email: 'student@focusly.dev',
          password: 'password123',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.code,
            'code',
            AuthFailureCode.networkUnavailable,
          ),
        ),
      );
    });
  });
}

class _FakeFirebaseAuthService implements FirebaseAuthService {
  _FakeFirebaseAuthService({this.current}) {
    _controller.add(current);
  }

  final _controller = StreamController<FirebaseAuthUserData?>.broadcast(
    sync: true,
  );
  FirebaseAuthUserData? current;
  FirebaseAuthUserData? signInResult;
  FirebaseAuthUserData? signUpResult;
  FirebaseAuthUserData? reloadResult;
  FirebaseAuthException? failure;
  int passwordResetCalls = 0;
  int verificationCalls = 0;
  int signOutCalls = 0;

  void emit(FirebaseAuthUserData? user) {
    current = user;
    _controller.add(user);
  }

  void dispose() => unawaited(_controller.close());

  void _throwIfNeeded() {
    final value = failure;
    if (value != null) {
      throw value;
    }
  }

  @override
  FirebaseAuthUserData? get currentUser => current;

  @override
  Stream<FirebaseAuthUserData?> authStateChanges() {
    return Stream.multi((controller) {
      final subscription = _controller.stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
      controller
        ..onCancel = subscription.cancel
        ..add(current);
    });
  }

  @override
  Future<FirebaseAuthUserData> signIn({
    required String email,
    required String password,
  }) async {
    _throwIfNeeded();
    return signInResult ?? current!;
  }

  @override
  Future<FirebaseAuthUserData> signUp({
    required String email,
    required String password,
  }) async {
    _throwIfNeeded();
    return signUpResult ?? current!;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    _throwIfNeeded();
    passwordResetCalls++;
  }

  @override
  Future<void> sendEmailVerification() async {
    _throwIfNeeded();
    verificationCalls++;
  }

  @override
  Future<FirebaseAuthUserData?> reloadCurrentUser() async {
    _throwIfNeeded();
    return reloadResult ?? current;
  }

  @override
  Future<void> signOut() async {
    _throwIfNeeded();
    signOutCalls++;
  }
}
