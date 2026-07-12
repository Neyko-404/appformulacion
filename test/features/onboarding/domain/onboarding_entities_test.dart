import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';

void main() {
  final createdAt = DateTime.utc(2026, 7, 12);

  StudentProfile profile() => StudentProfile(
    userId: 'user-1',
    university: 'UNJFSC',
    career: 'Ingeniería',
    currentCycle: 5,
    primaryGoal: PrimaryGoal.organization,
    preferredFocusMinutes: 25,
    createdAt: createdAt,
    updatedAt: createdAt,
  );

  test('StudentProfile creates valid immutable data', () {
    final value = profile();
    expect(value.userId, 'user-1');
    expect(value.currentCycle, 5);
  });

  test('StudentProfile equality compares all fields', () {
    expect(profile(), profile());
  });

  test('StudentProfile copyWith preserves identity and creation', () {
    final updated = profile().copyWith(
      career: 'Medicina',
      updatedAt: createdAt.add(const Duration(days: 1)),
    );
    expect(updated.userId, 'user-1');
    expect(updated.career, 'Medicina');
    expect(updated.createdAt, createdAt);
  });

  test('StudyCompanion keeps appearance and ownership', () {
    final companion = StudyCompanion(
      id: 'cat-1',
      ownerId: 'user-1',
      name: 'Milo',
      appearance: CompanionAppearance.indigo,
      createdAt: createdAt,
    );
    expect(companion.name, 'Milo');
    expect(companion.ownerId, 'user-1');
    expect(companion.appearance, CompanionAppearance.indigo);
  });
}
