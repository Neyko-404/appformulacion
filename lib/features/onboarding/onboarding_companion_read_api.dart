import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:focusly/features/onboarding/onboarding_providers.dart';

abstract interface class OnboardingCompanionReadApi {
  Future<StudyCompanion?> getInitialCompanion(String userId);
}

final onboardingCompanionReadApiProvider = Provider<OnboardingCompanionReadApi>(
  (ref) => _RepositoryOnboardingCompanionReadApi(
    ref.watch(onboardingRepositoryProvider),
  ),
);

final class _RepositoryOnboardingCompanionReadApi
    implements OnboardingCompanionReadApi {
  const _RepositoryOnboardingCompanionReadApi(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<StudyCompanion?> getInitialCompanion(String userId) =>
      _repository.getCompanion(userId);
}
