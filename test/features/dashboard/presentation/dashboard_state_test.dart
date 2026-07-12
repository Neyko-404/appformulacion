import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/dashboard/presentation/state/dashboard_state.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';

void main() {
  final now = DateTime.utc(2026, 7, 12);
  final profile = StudentProfile(
    userId: 'user-1',
    university: 'UNJFSC',
    career: 'Ingeniería',
    currentCycle: 4,
    primaryGoal: PrimaryGoal.examPreparation,
    preferredFocusMinutes: 25,
    createdAt: now,
    updatedAt: now,
  );
  final companion = StudyCompanion(
    id: 'cat-1',
    ownerId: 'user-1',
    name: 'Kumo',
    appearance: CompanionAppearance.indigo,
    createdAt: now,
  );

  test('initial state contains only loading dashboard data', () {
    expect(const DashboardState().isLoading, isTrue);
    expect(const DashboardState().profile, isNull);
    expect(const DashboardState().companion, isNull);
  });

  test('state equality includes profile, companion, loading, and error', () {
    expect(
      DashboardState(profile: profile, companion: companion, isLoading: false),
      DashboardState(profile: profile, companion: companion, isLoading: false),
    );
  });
}
