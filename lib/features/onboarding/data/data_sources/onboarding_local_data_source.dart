import 'package:focusly/features/onboarding/data/models/student_profile_local_model.dart';
import 'package:focusly/features/onboarding/data/models/study_companion_local_model.dart';

abstract interface class OnboardingLocalDataSource {
  Future<StudentProfileLocalModel?> getProfile(String userId);

  Future<StudyCompanionLocalModel?> getCompanion(String userId);

  Future<void> save({
    required StudentProfileLocalModel profile,
    required StudyCompanionLocalModel companion,
  });

  Future<void> clear(String userId);
}

final class LocalDataSourceException implements Exception {
  const LocalDataSourceException(this.operation, [this.cause]);

  final String operation;
  final Object? cause;
}
