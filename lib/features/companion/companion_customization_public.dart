import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/companion/companion_public_providers.dart';
import 'package:focusly/features/companion/data/repositories/in_memory_companion_customization_repository.dart';
import 'package:focusly/features/companion/data/repositories/isar_companion_customization_repository.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/domain/entities/companion_presentation_model.dart';
import 'package:focusly/features/companion/domain/repositories/companion_customization_repository.dart';
import 'package:focusly/features/companion/domain/services/companion_expression_engine.dart';
import 'package:focusly/features/companion/domain/services/companion_presentation_mapper.dart';
import 'package:focusly/features/onboarding/onboarding_companion_read_api.dart';
import 'package:focusly/services/local_database/local_database_provider.dart';

export 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
export 'package:focusly/features/companion/domain/entities/companion_presentation_model.dart';
export 'package:focusly/features/companion/domain/entities/companion_state.dart'
    show CompanionExpression, CompanionMood;
export 'package:focusly/features/companion/presentation/companion_visual_mapper.dart';
export 'package:focusly/features/companion/presentation/models/companion_card_variant.dart';
export 'package:focusly/features/companion/presentation/widgets/animated_companion_avatar.dart';
export 'package:focusly/features/companion/presentation/widgets/companion_presence_card.dart';

final companionCustomizationRepositoryProvider =
    Provider<CompanionCustomizationRepository>((ref) {
      final database = ref.watch(localDatabaseProvider);
      return database == null
          ? InMemoryCompanionCustomizationRepository()
          : IsarCompanionCustomizationRepository(database);
    });

final companionCustomizationProvider =
    AsyncNotifierProvider<
      CompanionCustomizationNotifier,
      CompanionCustomization?
    >(CompanionCustomizationNotifier.new);

final companionPresentationProvider = Provider<CompanionPresentationModel?>((
  ref,
) {
  final snapshot = ref.watch(companionSnapshotProvider);
  final customization = ref.watch(companionCustomizationProvider).value;
  if (snapshot == null || customization == null) return null;
  return const CompanionPresentationMapper().map(
    snapshot: snapshot,
    customization: customization,
  );
});

final companionContextPresentationProvider = Provider.autoDispose
    .family<CompanionPresentationModel?, CompanionExpressionInput>((
      ref,
      input,
    ) {
      final customization = ref.watch(companionCustomizationProvider).value;
      if (customization == null) return null;
      final expression = const CompanionExpressionEngine().derive(input);
      return const CompanionPresentationMapper().mapExpression(
        expressionState: expression,
        customization: customization,
      );
    });

final class CompanionCustomizationNotifier
    extends AsyncNotifier<CompanionCustomization?> {
  bool _isSaving = false;
  @override
  Future<CompanionCustomization?> build() async {
    final user = ref.watch(publicAuthSessionProvider).user;
    if (user == null) return null;
    final stored = await ref
        .watch(companionCustomizationRepositoryProvider)
        .get(user.id);
    if (stored != null) return stored;
    final onboarding = ref.watch(onboardingCompanionReadApiProvider);
    final companion = await onboarding.getInitialCompanion(user.id);
    return CompanionCustomization.defaults(
      ownerId: user.id,
      displayName: companion?.name ?? 'Compañero',
    );
  }

  Future<bool> save({
    required String displayName,
    required CompanionTheme theme,
    required CompanionAppearance avatar,
  }) async {
    if (_isSaving) return false;
    final previous = state.value;
    if (previous == null) return false;
    final trimmed = displayName.trim();
    if (trimmed.isEmpty || trimmed.length > 20) return false;
    final updated = CompanionCustomization(
      ownerId: previous.ownerId,
      identity: CompanionIdentity(
        displayName: trimmed,
        selectedTheme: theme,
        selectedAvatar: avatar,
        preferredExpressionStyle: previous.identity.preferredExpressionStyle,
      ),
    );
    final userId = ref.read(publicAuthSessionProvider).user?.id;
    if (userId == null || userId != previous.ownerId) return false;
    _isSaving = true;
    try {
      await ref.read(companionCustomizationRepositoryProvider).save(updated);
      if (ref.read(publicAuthSessionProvider).user?.id != userId) return false;
      state = AsyncData(updated);
      return true;
    } on Object {
      return false;
    } finally {
      _isSaving = false;
    }
  }
}
