import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';

void main() {
  final now = DateTime.utc(2026, 7, 12);
  late InMemoryOnboardingRepository repository;

  setUp(() => repository = InMemoryOnboardingRepository());

  StudentProfile profile(String userId, {String career = 'Ingeniería'}) {
    return StudentProfile(
      userId: userId,
      university: 'UNJFSC',
      career: career,
      currentCycle: 5,
      primaryGoal: PrimaryGoal.organization,
      preferredFocusMinutes: 25,
      createdAt: now,
      updatedAt: now,
    );
  }

  StudyCompanion companion(String userId) => StudyCompanion(
    id: 'cat-$userId',
    ownerId: userId,
    name: 'Milo',
    appearance: CompanionAppearance.indigo,
    createdAt: now,
  );

  test('user starts without onboarding', () async {
    expect(await repository.isCompleted('user-1'), isFalse);
  });

  test('saves and retrieves complete onboarding', () async {
    await repository.saveOnboarding(
      profile: profile('user-1'),
      companion: companion('user-1'),
    );
    expect(await repository.isCompleted('user-1'), isTrue);
    expect((await repository.getProfile('user-1'))?.career, 'Ingeniería');
    expect((await repository.getCompanion('user-1'))?.name, 'Milo');
  });

  test('isolates users', () async {
    await repository.saveOnboarding(
      profile: profile('user-1'),
      companion: companion('user-1'),
    );
    expect(await repository.getProfile('user-2'), isNull);
    expect(await repository.getCompanion('user-2'), isNull);
  });

  test('replaces same user data in a controlled way', () async {
    await repository.saveOnboarding(
      profile: profile('user-1'),
      companion: companion('user-1'),
    );
    await repository.saveOnboarding(
      profile: profile('user-1', career: 'Medicina'),
      companion: companion('user-1'),
    );
    expect((await repository.getProfile('user-1'))?.career, 'Medicina');
  });

  test('does not partially save mismatched owners', () async {
    await expectLater(
      repository.saveOnboarding(
        profile: profile('user-1'),
        companion: companion('user-2'),
      ),
      throwsArgumentError,
    );
    expect(await repository.isCompleted('user-1'), isFalse);
    expect(await repository.getCompanion('user-2'), isNull);
  });
}
