import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/presentation/providers/auth_providers.dart';

/// API pública de solo lectura para features que necesitan observar la sesión.
///
/// No expone operaciones ni el estado de presentación de Authentication.
final publicAuthSessionProvider = Provider<AuthSession>(
  (ref) =>
      ref.watch(authNotifierProvider.select((authState) => authState.session)),
);
