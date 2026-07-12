import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/authentication/domain/services/auth_validator.dart';
import 'package:focusly/features/authentication/presentation/notifiers/auth_notifier.dart';
import 'package:focusly/features/authentication/presentation/state/auth_state.dart';

export 'package:focusly/features/authentication/authentication_providers.dart';

final authValidatorProvider = Provider<AuthValidator>(
  (ref) => const AuthValidator(),
);

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
