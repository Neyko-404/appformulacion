import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Adaptador temporal para Sprint 2A. No persiste al reiniciar la aplicación.
final class InMemoryOnboardingRepository implements OnboardingRepository {
  final Map<String, StudentProfile> _profiles = {};
  final Map<String, StudyCompanion> _companions = {};

  @override
  Future<bool> isCompleted(String userId) async {
    return _profiles.containsKey(userId) && _companions.containsKey(userId);
  }

  @override
  Future<StudentProfile?> getProfile(String userId) async => _profiles[userId];

  @override
  Future<StudyCompanion?> getCompanion(String userId) async {
    return _companions[userId];
  }

  @override
  Future<void> saveOnboarding({
    required StudentProfile profile,
    required StudyCompanion companion,
  }) async {
    if (profile.userId != companion.ownerId) {
      throw ArgumentError('Profile and companion must share the same owner.');
    }
    _profiles[profile.userId] = profile;
    _companions[profile.userId] = companion;
  }

  @override
  Future<void> clear(String userId) async {
    _profiles.remove(userId);
    _companions.remove(userId);
  }
}
