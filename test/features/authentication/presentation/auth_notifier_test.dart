import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/authentication/domain/entities/auth_failure.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/authentication/domain/repositories/auth_repository.dart';
import 'package:focusly/features/authentication/presentation/providers/auth_providers.dart';

void main() {
  const user = AuthUser(id: 'test-user', email: 'student@focusly.dev');
  const unverified = AuthSession.authenticated(
    user: user,
    emailVerified: false,
  );
  const verified = AuthSession.authenticated(user: user, emailVerified: true);

  ProviderContainer createContainer(_FakeAuthRepository repository) {
    final container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    addTearDown(repository.dispose);
    return container;
  }

  Future<void> initialize(ProviderContainer container) async {
    final initialized = Completer<void>();
    final subscription = container.listen(authNotifierProvider, (
      previous,
      next,
    ) {
      if (!next.isInitializing && !initialized.isCompleted) {
        initialized.complete();
      }
    }, fireImmediately: true);
    addTearDown(subscription.close);
    await initialized.future;
  }

  test('starts initializing and resolves unauthenticated session', () async {
    final container = createContainer(_FakeAuthRepository());
    expect(container.read(authNotifierProvider).isInitializing, isTrue);

    await initialize(container);

    expect(container.read(authNotifierProvider).isInitializing, isFalse);
    expect(
      container.read(authNotifierProvider).session.isAuthenticated,
      isFalse,
    );
  });

  test('reflects successful login', () async {
    final repository = _FakeAuthRepository(signInResult: verified);
    final container = createContainer(repository);
    await initialize(container);

    await container
        .read(authNotifierProvider.notifier)
        .signIn(email: user.email, password: 'password123');

    expect(container.read(authNotifierProvider).session, verified);
  });

  test('reflects an external session change', () async {
    final repository = _FakeAuthRepository();
    final container = createContainer(repository);
    await initialize(container);

    repository.emitSession(unverified);
    await Future<void>.value();

    expect(container.read(authNotifierProvider).session, unverified);
  });

  test('exposes safe login failure without losing session', () async {
    final repository = _FakeAuthRepository(
      failure: AuthFailure.invalidCredentials(),
    );
    final container = createContainer(repository);
    await initialize(container);

    await container
        .read(authNotifierProvider.notifier)
        .signIn(email: user.email, password: 'incorrect-password');

    expect(
      container.read(authNotifierProvider).errorMessage,
      'No pudimos iniciar sesión con esos datos.',
    );
    expect(
      container.read(authNotifierProvider).session.isAuthenticated,
      isFalse,
    );
  });

  test('registration sends verification and remains pending', () async {
    final repository = _FakeAuthRepository(signUpResult: unverified);
    final container = createContainer(repository);
    await initialize(container);

    await container
        .read(authNotifierProvider.notifier)
        .signUp(email: user.email, password: 'password123');

    final state = container.read(authNotifierProvider);
    expect(state.session, unverified);
    expect(repository.verificationCalls, 1);
    expect(state.message, 'Te enviamos un correo de verificación.');
  });

  test('resends email verification', () async {
    final repository = _FakeAuthRepository(initial: unverified);
    final container = createContainer(repository);
    await initialize(container);

    await container.read(authNotifierProvider.notifier).sendEmailVerification();

    expect(repository.verificationCalls, 1);
    expect(
      container.read(authNotifierProvider).message,
      'Enviamos un nuevo correo de verificación.',
    );
  });

  test('reload reflects verified session', () async {
    final repository = _FakeAuthRepository(
      initial: unverified,
      reloadResult: verified,
    );
    final container = createContainer(repository);
    await initialize(container);

    await container.read(authNotifierProvider.notifier).reloadSession();

    expect(container.read(authNotifierProvider).session.emailVerified, isTrue);
  });

  test('password recovery uses non-revealing confirmation', () async {
    final container = createContainer(_FakeAuthRepository());
    await initialize(container);

    await container
        .read(authNotifierProvider.notifier)
        .requestPasswordReset(email: 'unknown@focusly.dev');

    expect(
      container.read(authNotifierProvider).message,
      'Si el correo está registrado, recibirás instrucciones.',
    );
  });

  test('logout becomes unauthenticated', () async {
    final repository = _FakeAuthRepository(initial: verified);
    final container = createContainer(repository);
    await initialize(container);

    await container.read(authNotifierProvider.notifier).signOut();

    expect(
      container.read(authNotifierProvider).session.isAuthenticated,
      isFalse,
    );
  });

  test('prevents concurrent operations', () async {
    final repository = _FakeAuthRepository(pendingSignIn: true);
    final container = createContainer(repository);
    await initialize(container);
    final notifier = container.read(authNotifierProvider.notifier);

    final first = notifier.signIn(email: user.email, password: 'password123');
    final second = notifier.signIn(email: user.email, password: 'password123');

    expect(repository.signInCalls, 1);
    repository.completeSignIn(verified);
    await Future.wait([first, second]);
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    AuthSession initial = const AuthSession.unauthenticated(),
    this.signInResult,
    this.signUpResult,
    this.reloadResult,
    this.failure,
    this.pendingSignIn = false,
  }) : _session = initial;

  final _controller = StreamController<AuthSession>.broadcast(sync: true);
  final _pendingCompleter = Completer<AuthSession>();
  AuthSession _session;
  final AuthSession? signInResult;
  final AuthSession? signUpResult;
  final AuthSession? reloadResult;
  final AuthFailure? failure;
  final bool pendingSignIn;
  int signInCalls = 0;
  int verificationCalls = 0;

  void dispose() => unawaited(_controller.close());

  void completeSignIn(AuthSession session) =>
      _pendingCompleter.complete(session);

  void emitSession(AuthSession session) => _setSession(session);

  void _throwIfNeeded() {
    final value = failure;
    if (value != null) {
      throw value;
    }
  }

  void _setSession(AuthSession session) {
    _session = session;
    _controller.add(session);
  }

  @override
  Future<AuthSession> getCurrentSession() async => _session;

  @override
  Stream<AuthSession> watchAuthState() {
    return Stream.multi((controller) {
      final subscription = _controller.stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
      controller
        ..onCancel = subscription.cancel
        ..add(_session);
    });
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    _throwIfNeeded();
    final result = pendingSignIn
        ? await _pendingCompleter.future
        : signInResult ?? _session;
    _setSession(result);
    return result;
  }

  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
  }) async {
    _throwIfNeeded();
    final result = signUpResult ?? _session;
    _setSession(result);
    return result;
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    _throwIfNeeded();
  }

  @override
  Future<void> sendEmailVerification() async {
    _throwIfNeeded();
    verificationCalls++;
  }

  @override
  Future<AuthSession> reloadSession() async {
    _throwIfNeeded();
    final result = reloadResult ?? _session;
    _setSession(result);
    return result;
  }

  @override
  Future<void> signOut() async {
    _throwIfNeeded();
    _setSession(const AuthSession.unauthenticated());
  }
}
