import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/onboarding/data/mappers/onboarding_local_mapper.dart';
import 'package:focusly/features/onboarding/data/models/study_companion_local_model.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';

void main() {
  const mapper = OnboardingLocalMapper();
  final createdAt = DateTime.utc(2026, 7, 12);

  test('profile round trip preserves every domain field', () {
    final profile = StudentProfile(
      userId: 'user-1',
      university: 'UNJFSC',
      career: 'Ingeniería',
      currentCycle: 5,
      primaryGoal: PrimaryGoal.concentration,
      preferredFocusMinutes: 40,
      createdAt: createdAt,
      updatedAt: createdAt.add(const Duration(days: 1)),
    );

    final local = mapper.profileToLocal(profile)..id = 42;
    expect(mapper.profileToDomain(local), profile);
    expect(local.id, 42);
    expect(profile.userId, isNot('42'));
  });

  test('companion round trip uses stable textual appearance', () {
    final companion = StudyCompanion(
      id: 'cat-domain-id',
      ownerId: 'user-1',
      name: 'Milo',
      appearance: CompanionAppearance.emerald,
      createdAt: createdAt,
    );

    final local = mapper.companionToLocal(companion)..id = 99;
    expect(local.appearance, 'emerald');
    expect(mapper.companionToDomain(local), companion);
    expect(local.companionId, isNot('${local.id}'));
  });

  test('unknown appearance is rejected', () {
    final local = StudyCompanionLocalModel()
      ..companionId = 'cat-1'
      ..ownerId = 'user-1'
      ..name = 'Milo'
      ..appearance = 'unknown-future-value'
      ..createdAt = createdAt;

    expect(() => mapper.companionToDomain(local), throwsFormatException);
  });
}
