import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/companion/companion_customization_public.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/repositories/companion_customization_repository.dart';

void main() {
  test(
    'concurrent save executes one write and preserves visible value',
    () async {
      final repository = _DelayedRepository(
        CompanionCustomization.defaults(ownerId: 'user-1', displayName: 'Kumo'),
      );
      final container = ProviderContainer(
        overrides: [
          publicAuthSessionProvider.overrideWithValue(
            const AuthSession.authenticated(
              user: AuthUser(id: 'user-1', email: 'user@focusly.dev'),
              emailVerified: true,
            ),
          ),
          companionCustomizationRepositoryProvider.overrideWithValue(
            repository,
          ),
        ],
      );
      addTearDown(container.dispose);
      await container.read(companionCustomizationProvider.future);
      final notifier = container.read(companionCustomizationProvider.notifier);
      final first = notifier.save(
        displayName: 'Nova',
        theme: CompanionTheme.ocean,
        avatar: CompanionAppearance.face,
      );
      final second = notifier.save(
        displayName: 'Lumi',
        theme: CompanionTheme.night,
        avatar: CompanionAppearance.nature,
      );
      expect(
        container
            .read(companionCustomizationProvider)
            .value
            ?.identity
            .displayName,
        'Kumo',
      );
      expect(await second, isFalse);
      repository.complete();
      expect(await first, isTrue);
      expect(repository.writes, 1);
      expect(
        container
            .read(companionCustomizationProvider)
            .value
            ?.identity
            .displayName,
        'Nova',
      );
    },
  );
}

final class _DelayedRepository implements CompanionCustomizationRepository {
  _DelayedRepository(this.value);

  CompanionCustomization value;
  final Completer<void> _gate = Completer<void>();
  int writes = 0;

  void complete() => _gate.complete();

  @override
  Future<CompanionCustomization?> get(String ownerId) async => value;

  @override
  Future<void> save(CompanionCustomization customization) async {
    writes++;
    await _gate.future;
    value = customization;
  }
}
