import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/onboarding/data/data_sources/onboarding_local_data_source.dart';
import 'package:focusly/features/onboarding/data/models/student_profile_local_model.dart';
import 'package:focusly/features/onboarding/data/models/study_companion_local_model.dart';
import 'package:focusly/features/onboarding/data/repositories/isar_onboarding_repository.dart';
import 'package:focusly/features/onboarding/domain/entities/onboarding_failure.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';

void main() {
  final now = DateTime.utc(2026, 7, 12);

  StudentProfile profile({String career = 'Ingeniería', DateTime? updatedAt}) {
    return StudentProfile(
      userId: 'user-1',
      university: 'UNJFSC',
      career: career,
      currentCycle: 4,
      primaryGoal: PrimaryGoal.routine,
      preferredFocusMinutes: 25,
      createdAt: now,
      updatedAt: updatedAt ?? now,
    );
  }

  StudyCompanion companion() => StudyCompanion(
    id: 'cat-1',
    ownerId: 'user-1',
    name: 'Milo',
    appearance: CompanionAppearance.amber,
    createdAt: now,
  );

  test('starts incomplete, saves, and recovers both entities', () async {
    final source = _MemoryLocalDataSource();
    final repository = IsarOnboardingRepository(source);
    expect(await repository.isCompleted('user-1'), isFalse);

    await repository.saveOnboarding(profile: profile(), companion: companion());

    expect(await repository.isCompleted('user-1'), isTrue);
    expect(await repository.getProfile('user-1'), profile());
    expect(await repository.getCompanion('user-1'), companion());
  });

  test('only profile remains incomplete', () async {
    final source = _MemoryLocalDataSource();
    final repository = IsarOnboardingRepository(source);
    await repository.saveOnboarding(profile: profile(), companion: companion());
    source.companion = null;

    expect(await repository.isCompleted('user-1'), isFalse);
  });

  test('only companion remains incomplete', () async {
    final source = _MemoryLocalDataSource();
    final repository = IsarOnboardingRepository(source);
    await repository.saveOnboarding(profile: profile(), companion: companion());
    source.profile = null;

    expect(await repository.isCompleted('user-1'), isFalse);
  });

  test('update preserves original creation and changes updatedAt', () async {
    final source = _MemoryLocalDataSource();
    final repository = IsarOnboardingRepository(source);
    await repository.saveOnboarding(profile: profile(), companion: companion());
    final later = now.add(const Duration(days: 2));
    await repository.saveOnboarding(
      profile: profile(career: 'Medicina', updatedAt: later),
      companion: companion(),
    );

    final stored = await repository.getProfile('user-1');
    expect(stored?.createdAt, now);
    expect(stored?.updatedAt, later);
    expect(stored?.career, 'Medicina');
  });

  test('unknown persisted enum becomes a corrupted data failure', () async {
    final corruptProfile = StudentProfileLocalModel()
      ..userId = 'user-1'
      ..university = 'UNJFSC'
      ..career = 'Ing'
      ..currentCycle = 4
      ..primaryGoal = 'unknown'
      ..preferredFocusMinutes = 25
      ..createdAt = now
      ..updatedAt = now;
    final validCompanion = StudyCompanionLocalModel()
      ..companionId = 'cat-1'
      ..ownerId = 'user-1'
      ..name = 'Milo'
      ..appearance = 'amber'
      ..createdAt = now;
    final source = _MemoryLocalDataSource()
      ..profile = corruptProfile
      ..companion = validCompanion;
    final repository = IsarOnboardingRepository(source);
    await expectLater(
      repository.isCompleted('user-1'),
      throwsA(
        isA<OnboardingFailure>().having(
          (failure) => failure.type,
          'type',
          OnboardingFailureType.corruptedData,
        ),
      ),
    );
  });

  test('completion read errors become storage failures', () async {
    final repository = IsarOnboardingRepository(
      _MemoryLocalDataSource(throwOnRead: true),
    );
    await expectLater(
      repository.isCompleted('user-1'),
      throwsA(
        isA<OnboardingFailure>().having(
          (failure) => failure.type,
          'type',
          OnboardingFailureType.storage,
        ),
      ),
    );
  });
}

final class _MemoryLocalDataSource implements OnboardingLocalDataSource {
  _MemoryLocalDataSource({this.throwOnRead = false});

  final bool throwOnRead;
  StudentProfileLocalModel? profile;
  StudyCompanionLocalModel? companion;

  @override
  Future<StudentProfileLocalModel?> getProfile(String userId) async {
    if (throwOnRead) throw const LocalDataSourceException('test read');
    return profile?.userId == userId ? profile : null;
  }

  @override
  Future<StudyCompanionLocalModel?> getCompanion(String userId) async =>
      companion?.ownerId == userId ? companion : null;

  @override
  Future<void> save({
    required StudentProfileLocalModel profile,
    required StudyCompanionLocalModel companion,
  }) async {
    this.profile = profile;
    this.companion = companion;
  }

  @override
  Future<void> clear(String userId) async {
    if (profile?.userId == userId) profile = null;
    if (companion?.ownerId == userId) companion = null;
  }
}
