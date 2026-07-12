import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:focusly/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:focusly/features/onboarding/domain/services/onboarding_validator.dart';
import 'package:focusly/features/onboarding/presentation/notifiers/onboarding_notifier.dart';
import 'package:focusly/features/onboarding/presentation/state/onboarding_state.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => InMemoryOnboardingRepository(),
);

final onboardingValidatorProvider = Provider<OnboardingValidator>(
  (ref) => const OnboardingValidator(),
);

final onboardingClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final onboardingNotifierProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );
