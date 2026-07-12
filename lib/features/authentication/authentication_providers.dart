import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/authentication/data/repositories/in_memory_auth_repository.dart';
import 'package:focusly/features/authentication/domain/repositories/auth_repository.dart';

/// Composition root temporal de Authentication para Sprint 1A.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final repository = InMemoryAuthRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final authSessionProvider = StreamProvider((ref) {
  return ref.watch(authRepositoryProvider).watchAuthState();
});
