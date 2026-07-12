import 'package:focusly/features/onboarding/data/data_sources/onboarding_local_data_source.dart';
import 'package:focusly/features/onboarding/data/models/student_profile_local_model.dart';
import 'package:focusly/features/onboarding/data/models/study_companion_local_model.dart';
import 'package:isar_community/isar.dart';

final class IsarOnboardingLocalDataSource implements OnboardingLocalDataSource {
  const IsarOnboardingLocalDataSource(this._isar);

  final Isar _isar;

  @override
  Future<StudentProfileLocalModel?> getProfile(String userId) async {
    try {
      return await _isar.studentProfileLocalModels
          .where()
          .userIdEqualTo(userId)
          .findFirst();
    } on Object catch (error) {
      throw LocalDataSourceException('read profile', error);
    }
  }

  @override
  Future<StudyCompanionLocalModel?> getCompanion(String userId) async {
    try {
      return await _isar.studyCompanionLocalModels
          .where()
          .ownerIdEqualTo(userId)
          .findFirst();
    } on Object catch (error) {
      throw LocalDataSourceException('read companion', error);
    }
  }

  @override
  Future<void> save({
    required StudentProfileLocalModel profile,
    required StudyCompanionLocalModel companion,
  }) async {
    if (profile.userId != companion.ownerId) {
      throw const LocalDataSourceException('validate owners');
    }
    try {
      await _isar.writeTxn(() async {
        final existingProfile = await _isar.studentProfileLocalModels
            .where()
            .userIdEqualTo(profile.userId)
            .findFirst();
        final existingCompanion = await _isar.studyCompanionLocalModels
            .where()
            .ownerIdEqualTo(companion.ownerId)
            .findFirst();
        if (existingProfile != null) profile.id = existingProfile.id;
        if (existingCompanion != null) companion.id = existingCompanion.id;
        await _isar.studentProfileLocalModels.put(profile);
        await _isar.studyCompanionLocalModels.put(companion);
      });
    } on Object catch (error) {
      throw LocalDataSourceException('save onboarding', error);
    }
  }

  @override
  Future<void> clear(String userId) async {
    try {
      await _isar.writeTxn(() async {
        final profile = await _isar.studentProfileLocalModels
            .where()
            .userIdEqualTo(userId)
            .findFirst();
        final companion = await _isar.studyCompanionLocalModels
            .where()
            .ownerIdEqualTo(userId)
            .findFirst();
        if (profile != null) {
          await _isar.studentProfileLocalModels.delete(profile.id);
        }
        if (companion != null) {
          await _isar.studyCompanionLocalModels.delete(companion.id);
        }
      });
    } on Object catch (error) {
      throw LocalDataSourceException('clear onboarding', error);
    }
  }
}
