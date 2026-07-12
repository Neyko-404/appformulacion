import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';

abstract interface class OnboardingRepository {
  Future<bool> isCompleted(String userId);

  Future<StudentProfile?> getProfile(String userId);

  Future<StudyCompanion?> getCompanion(String userId);

  Future<void> saveOnboarding({
    required StudentProfile profile,
    required StudyCompanion companion,
  });

  Future<void> clear(String userId);
}
