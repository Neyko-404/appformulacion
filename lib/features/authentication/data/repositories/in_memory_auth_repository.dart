import 'dart:async';

import 'package:focusly/features/authentication/domain/entities/auth_failure.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/authentication/domain/repositories/auth_repository.dart';

/// Adaptador temporal para desarrollo. No ofrece seguridad ni persistencia real.
final class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository({Map<String, String> seedAccounts = const {}}) {
    for (final entry in seedAccounts.entries) {
      _addAccount(email: entry.key, password: entry.value);
    }
  }

  final _sessionController = StreamController<AuthUser?>.broadcast(sync: true);
  final Map<String, _AccountRecord> _accounts = {};
  AuthUser? _currentUser;
  int _nextId = 1;

  @override
  Future<AuthUser?> getCurrentUser() async => _currentUser;

  @override
  Stream<AuthUser?> watchAuthState() {
    return Stream.multi((controller) {
      final subscription = _sessionController.stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
      controller
        ..onCancel = subscription.cancel
        ..add(_currentUser);
    });
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    final account = _accounts[normalizedEmail];
    if (account == null ||
        account.passwordFingerprint != _fingerprint(password)) {
      throw AuthFailure.invalidCredentials();
    }

    _setCurrentUser(account.user);
    return account.user;
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    if (_accounts.containsKey(normalizedEmail)) {
      throw AuthFailure.emailAlreadyInUse();
    }

    final user = _addAccount(email: normalizedEmail, password: password);
    _setCurrentUser(user);
    return user;
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    _normalizeEmail(email);
    // Intencionalmente no informa si la cuenta existe.
  }

  @override
  Future<void> signOut() async => _setCurrentUser(null);

  void dispose() {
    unawaited(_sessionController.close());
  }

  AuthUser _addAccount({required String email, required String password}) {
    final normalizedEmail = _normalizeEmail(email);
    final user = AuthUser(id: 'memory-${_nextId++}', email: normalizedEmail);
    _accounts[normalizedEmail] = _AccountRecord(
      user: user,
      passwordFingerprint: _fingerprint(password),
    );
    return user;
  }

  void _setCurrentUser(AuthUser? user) {
    _currentUser = user;
    _sessionController.add(user);
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
  const _AccountRecord({required this.user, required this.passwordFingerprint});

  final AuthUser user;
  final int passwordFingerprint;
}
