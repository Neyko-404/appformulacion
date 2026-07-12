import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/authentication/domain/entities/auth_failure.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/authentication/domain/repositories/auth_repository.dart';
import 'package:focusly/features/authentication/presentation/providers/auth_providers.dart';
import 'package:focusly/features/authentication/presentation/state/auth_state.dart';

void main() {
  const user = AuthUser(id: 'test-user', email: 'student@focusly.dev');

  ProviderContainer createContainer(AuthRepository repository) {
    final container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('starts with AuthInitial', () {
    final container = createContainer(_FakeAuthRepository(user: user));

    expect(container.read(authNotifierProvider), isA<AuthInitial>());
  });

  test('emits loading and authenticated on successful login', () async {
    final container = createContainer(_FakeAuthRepository(user: user));
    final notifier = container.read(authNotifierProvider.notifier);

    final operation = notifier.signIn(
      email: user.email,
      password: 'password123',
    );
    expect(container.read(authNotifierProvider), isA<AuthLoading>());

    await operation;

    expect(
      container.read(authNotifierProvider),
      isA<Authenticated>().having((state) => state.user, 'user', user),
    );
  });

  test('emits a safe error on failed login', () async {
    final container = createContainer(
      _FakeAuthRepository(signInFailure: AuthFailure.invalidCredentials()),
    );

    await container
        .read(authNotifierProvider.notifier)
        .signIn(email: user.email, password: 'incorrect-password');

    expect(
      container.read(authNotifierProvider),
      isA<AuthError>().having(
        (state) => state.message,
        'message',
        'No pudimos iniciar sesión con esos datos.',
      ),
    );
  });

  test('registers a user', () async {
    final container = createContainer(_FakeAuthRepository(user: user));

    await container
        .read(authNotifierProvider.notifier)
        .signUp(email: user.email, password: 'password123');

    expect(container.read(authNotifierProvider), isA<Authenticated>());
  });

  test('emits the safe password reset confirmation', () async {
    final container = createContainer(_FakeAuthRepository(user: user));

    await container
        .read(authNotifierProvider.notifier)
        .requestPasswordReset(email: 'unknown@focusly.dev');

    expect(
      container.read(authNotifierProvider),
      isA<PasswordResetSent>().having(
        (state) => state.message,
        'message',
        'Si el correo está registrado, recibirás instrucciones.',
      ),
    );
  });

  test('signs out and becomes unauthenticated', () async {
    final container = createContainer(_FakeAuthRepository(user: user));

    await container.read(authNotifierProvider.notifier).signOut();

    expect(container.read(authNotifierProvider), isA<Unauthenticated>());
  });

  test('ignores a concurrent submission while loading', () async {
    final repository = _PendingAuthRepository();
    final container = createContainer(repository);
    final notifier = container.read(authNotifierProvider.notifier);

    final first = notifier.signIn(email: user.email, password: 'password123');
    final second = notifier.signIn(email: user.email, password: 'password123');

    expect(repository.signInCalls, 1);
    repository.complete(user);
    await Future.wait([first, second]);
  });

  test('reset restores AuthInitial outside loading', () async {
    final container = createContainer(
      _FakeAuthRepository(signInFailure: AuthFailure.invalidCredentials()),
    );
    final notifier = container.read(authNotifierProvider.notifier);
    await notifier.signIn(email: user.email, password: 'incorrect-password');
    expect(container.read(authNotifierProvider), isA<AuthError>());

    notifier.reset();

    expect(container.read(authNotifierProvider), isA<AuthInitial>());
  });

  test('reset does not interrupt AuthLoading', () async {
    final repository = _PendingAuthRepository();
    final container = createContainer(repository);
    final notifier = container.read(authNotifierProvider.notifier);
    final operation = notifier.signIn(
      email: user.email,
      password: 'password123',
    );
    expect(container.read(authNotifierProvider), isA<AuthLoading>());

    notifier.reset();

    expect(container.read(authNotifierProvider), isA<AuthLoading>());
    repository.complete(user);
    await operation;
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.user, this.signInFailure});

  final AuthUser? user;
  final AuthFailure? signInFailure;

  @override
  Future<AuthUser?> getCurrentUser() async => user;

  @override
  Stream<AuthUser?> watchAuthState() => Stream.value(user);

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final failure = signInFailure;
    if (failure != null) {
      throw failure;
    }
    return user!;
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async => user!;

  @override
  Future<void> requestPasswordReset({required String email}) async {}

  @override
  Future<void> signOut() async {}
}

class _PendingAuthRepository implements AuthRepository {
  final _signInCompleter = Completer<AuthUser>();
  int signInCalls = 0;

  void complete(AuthUser user) => _signInCompleter.complete(user);

  @override
  Future<AuthUser?> getCurrentUser() async => null;

  @override
  Stream<AuthUser?> watchAuthState() => const Stream.empty();

  @override
  Future<AuthUser> signIn({required String email, required String password}) {
    signInCalls++;
    return _signInCompleter.future;
  }

  @override
  Future<AuthUser> signUp({required String email, required String password}) =>
      _signInCompleter.future;

  @override
  Future<void> requestPasswordReset({required String email}) async {}

  @override
  Future<void> signOut() async {}
}
