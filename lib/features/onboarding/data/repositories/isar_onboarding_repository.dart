import 'package:focusly/core/logging/app_logger.dart';
import 'package:focusly/features/onboarding/data/data_sources/onboarding_local_data_source.dart';
import 'package:focusly/features/onboarding/data/mappers/onboarding_local_mapper.dart';
import 'package:focusly/features/onboarding/domain/entities/onboarding_failure.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/onboarding/domain/repositories/onboarding_repository.dart';

final class IsarOnboardingRepository implements OnboardingRepository {
  const IsarOnboardingRepository(
    this._dataSource, {
    this.mapper = const OnboardingLocalMapper(),
    this.logger = const AppLogger(),
  });

  final OnboardingLocalDataSource _dataSource;
  final OnboardingLocalMapper mapper;
  final AppLogger logger;

  @override
  Future<bool> isCompleted(String userId) async {
    try {
      final profile = await _dataSource.getProfile(userId);
      final companion = await _dataSource.getCompanion(userId);
      if (profile == null || companion == null) return false;
      final domainProfile = mapper.profileToDomain(profile);
      final domainCompanion = mapper.companionToDomain(companion);
      if (domainProfile.userId != userId || domainCompanion.ownerId != userId) {
        throw const FormatException('Onboarding owner mismatch.');
      }
      return true;
    } on FormatException catch (error, stackTrace) {
      logger.error(
        'Corrupted local onboarding data',
        error: error,
        stackTrace: stackTrace,
      );
      throw OnboardingFailure.corruptedData();
    } on OnboardingFailure {
      rethrow;
    } on Object catch (error, stackTrace) {
      _throwStorageFailure('check onboarding completion', error, stackTrace);
    }
  }

  @override
  Future<StudentProfile?> getProfile(String userId) async {
    try {
      final model = await _dataSource.getProfile(userId);
      if (model == null) return null;
      final profile = mapper.profileToDomain(model);
      return profile.userId == userId ? profile : null;
    } on Object catch (error, stackTrace) {
      _throwStorageFailure('read profile', error, stackTrace);
    }
  }

  @override
  Future<StudyCompanion?> getCompanion(String userId) async {
    try {
      final model = await _dataSource.getCompanion(userId);
      if (model == null) return null;
      final companion = mapper.companionToDomain(model);
      return companion.ownerId == userId ? companion : null;
    } on Object catch (error, stackTrace) {
      _throwStorageFailure('read companion', error, stackTrace);
    }
  }

  @override
  Future<void> saveOnboarding({
    required StudentProfile profile,
    required StudyCompanion companion,
  }) async {
    if (profile.userId != companion.ownerId) {
      throw OnboardingFailure.storage();
    }
    try {
      final existingProfile = await _dataSource.getProfile(profile.userId);
      final existingCompanion = await _dataSource.getCompanion(profile.userId);
      final profileModel = mapper.profileToLocal(profile);
      final companionModel = mapper.companionToLocal(companion);
      if (existingProfile != null) {
        profileModel.createdAt = existingProfile.createdAt;
      }
      if (existingCompanion != null) {
        companionModel.createdAt = existingCompanion.createdAt;
      }
      await _dataSource.save(profile: profileModel, companion: companionModel);
    } on Object catch (error, stackTrace) {
      _throwStorageFailure('save onboarding', error, stackTrace);
    }
  }

  @override
  Future<void> clear(String userId) async {
    try {
      await _dataSource.clear(userId);
    } on Object catch (error, stackTrace) {
      _throwStorageFailure('clear onboarding', error, stackTrace);
    }
  }

  Never _throwStorageFailure(
    String operation,
    Object error,
    StackTrace stackTrace,
  ) {
    logger.error(
      'Local onboarding operation failed: $operation',
      error: error,
      stackTrace: stackTrace,
    );
    throw OnboardingFailure.storage();
  }
}
