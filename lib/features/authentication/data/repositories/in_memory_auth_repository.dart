import 'dart:async';

import 'package:focusly/features/authentication/domain/entities/auth_failure.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/authentication/domain/repositories/auth_repository.dart';

/// Fake determinista para pruebas. No ofrece seguridad ni persistencia real.
final class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository({Map<String, String> seedAccounts = const {}}) {
    for (final entry in seedAccounts.entries) {
      _addAccount(email: entry.key, password: entry.value, emailVerified: true);
    }
  }

  final _sessionController = StreamController<AuthSession>.broadcast(
    sync: true,
  );
  final Map<String, _AccountRecord> _accounts = {};
  _AccountRecord? _currentAccount;
  int _nextId = 1;

  @override
  Future<AuthSession> getCurrentSession() async => _currentSession;

  @override
  Stream<AuthSession> watchAuthState() {
    return Stream.multi((controller) {
      final subscription = _sessionController.stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
      controller
        ..onCancel = subscription.cancel
        ..add(_currentSession);
    });
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final account = _accounts[_normalizeEmail(email)];
    if (account == null ||
        account.passwordFingerprint != _fingerprint(password)) {
      throw AuthFailure.invalidCredentials();
    }
    _setCurrentAccount(account);
    return _currentSession;
  }

  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    if (_accounts.containsKey(normalizedEmail)) {
      throw AuthFailure.emailAlreadyInUse();
    }
    final account = _addAccount(
      email: normalizedEmail,
      password: password,
      emailVerified: false,
    );
    _setCurrentAccount(account);
    return _currentSession;
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    _normalizeEmail(email);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (_currentAccount == null) {
      throw AuthFailure.unexpected();
    }
  }

  @override
  Future<AuthSession> reloadSession() async => _currentSession;

  @override
  Future<void> signOut() async => _setCurrentAccount(null);

  void markCurrentEmailVerified() {
    final account = _currentAccount;
    if (account == null) {
      return;
    }
    account.emailVerified = true;
    _setCurrentAccount(account);
  }

  void dispose() {
    unawaited(_sessionController.close());
  }

  AuthSession get _currentSession {
    final account = _currentAccount;
    if (account == null) {
      return const AuthSession.unauthenticated();
    }
    return AuthSession.authenticated(
      user: account.user,
      emailVerified: account.emailVerified,
    );
  }

  _AccountRecord _addAccount({
    required String email,
    required String password,
    required bool emailVerified,
  }) {
    final normalizedEmail = _normalizeEmail(email);
    final account = _AccountRecord(
      user: AuthUser(id: 'memory-${_nextId++}', email: normalizedEmail),
      passwordFingerprint: _fingerprint(password),
      emailVerified: emailVerified,
    );
    _accounts[normalizedEmail] = account;
    return account;
  }

  void _setCurrentAccount(_AccountRecord? account) {
    _currentAccount = account;
    _sessionController.add(_currentSession);
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  int _fingerprint(String password) {
    var fingerprint = 0x811C9DC5;
    for (final codeUnit in password.codeUnits) {
      fingerprint ^= codeUnit;
      fingerprint = (fingerprint * 0x01000193) & 0x7FFFFFFF;
    }
    return fingerprint;
  }
}

final class _AccountRecord {
  _AccountRecord({
    required this.user,
    required this.passwordFingerprint,
    required this.emailVerified,
  });

  final AuthUser user;
  final int passwordFingerprint;
  bool emailVerified;
}
