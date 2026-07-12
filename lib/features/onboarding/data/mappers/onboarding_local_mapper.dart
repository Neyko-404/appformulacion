import 'package:focusly/features/onboarding/data/models/student_profile_local_model.dart';
import 'package:focusly/features/onboarding/data/models/study_companion_local_model.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';

final class OnboardingLocalMapper {
  const OnboardingLocalMapper();

  StudentProfileLocalModel profileToLocal(StudentProfile entity) {
    return StudentProfileLocalModel()
      ..userId = entity.userId
      ..university = entity.university
      ..career = entity.career
      ..currentCycle = entity.currentCycle
      ..primaryGoal = entity.primaryGoal.name
      ..preferredFocusMinutes = entity.preferredFocusMinutes
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
  }

  StudentProfile profileToDomain(StudentProfileLocalModel model) {
    return StudentProfile(
      userId: model.userId,
      university: model.university,
      career: model.career,
      currentCycle: model.currentCycle,
      primaryGoal: _primaryGoal(model.primaryGoal),
      preferredFocusMinutes: model.preferredFocusMinutes,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  StudyCompanionLocalModel companionToLocal(StudyCompanion entity) {
    return StudyCompanionLocalModel()
      ..companionId = entity.id
      ..ownerId = entity.ownerId
      ..name = entity.name
      ..appearance = entity.appearance.name
      ..createdAt = entity.createdAt;
  }

  StudyCompanion companionToDomain(StudyCompanionLocalModel model) {
    return StudyCompanion(
      id: model.companionId,
      ownerId: model.ownerId,
      name: model.name,
      appearance: _appearance(model.appearance),
      createdAt: model.createdAt,
    );
  }

  PrimaryGoal _primaryGoal(String value) {
    return PrimaryGoal.values.firstWhere(
      (item) => item.name == value,
      orElse: () => throw FormatException('Unknown primary goal: $value'),
    );
  }

  CompanionAppearance _appearance(String value) {
    return CompanionAppearance.values.firstWhere(
      (item) => item.name == value,
      orElse: () => throw FormatException('Unknown appearance: $value'),
    );
  }
}
