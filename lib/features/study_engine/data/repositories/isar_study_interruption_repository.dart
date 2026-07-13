import 'package:focusly/core/logging/app_logger.dart';
import 'package:focusly/features/study_engine/data/data_sources/study_interruption_local_data_source.dart';
import 'package:focusly/features/study_engine/data/mappers/study_interruption_mapper.dart';
import 'package:focusly/features/study_engine/data/models/study_interruption_local_model.dart';
import 'package:focusly/features/study_engine/domain/entities/study_interruption.dart';
import 'package:focusly/features/study_engine/domain/failures/study_session_failure.dart';
import 'package:focusly/features/study_engine/domain/repositories/study_interruption_repository.dart';

final class IsarStudyInterruptionRepository
    implements StudyInterruptionRepository {
  const IsarStudyInterruptionRepository(
    this._source, {
    this.mapper = const StudyInterruptionMapper(),
    this.logger = const AppLogger(),
  });

  final StudyInterruptionLocalDataSource _source;
  final StudyInterruptionMapper mapper;
  final AppLogger logger;

  @override
  Future<void> saveOpen(
    String ownerId,
    String sessionId,
    StudyInterruption interruption,
  ) async {
    _validateScope(ownerId, sessionId);
    if (!interruption.isOpen || await open(ownerId, sessionId) != null) {
      throw StudySessionFailure.corrupted();
    }
    await _write(ownerId, sessionId, interruption);
  }

  @override
  Future<void> saveClosed(
    String ownerId,
    String sessionId,
    StudyInterruption interruption,
  ) async {
    _validateScope(ownerId, sessionId);
    if (interruption.isOpen) throw StudySessionFailure.corrupted();
    await _write(ownerId, sessionId, interruption);
  }

  void _validateScope(String ownerId, String sessionId) {
    if (ownerId.trim().isEmpty || sessionId.trim().isEmpty) {
      throw StudySessionFailure.corrupted();
    }
  }

  Future<void> _write(
    String ownerId,
    String sessionId,
    StudyInterruption value,
  ) async {
    try {
      await _source.put(mapper.toLocal(ownerId, sessionId, value));
    } on StudySessionFailure {
      rethrow;
    } on Object catch (error, stack) {
      logger.error(
        'Interruption write failed',
        error: error,
        stackTrace: stack,
      );
      throw StudySessionFailure.storage();
    }
  }

  StudyInterruption _map(StudyInterruptionLocalModel value) {
    try {
      return mapper.toDomain(value);
    } on Object catch (error, stack) {
      logger.error('Corrupted interruption', error: error, stackTrace: stack);
      throw StudySessionFailure.corrupted();
    }
  }

  @override
  Future<StudyInterruption?> open(String ownerId, String sessionId) async {
    try {
      final value = await _source.open(ownerId, sessionId);
      return value == null ? null : _map(value);
    } on StudySessionFailure {
      rethrow;
    } on Object catch (error, stack) {
      logger.error('Interruption read failed', error: error, stackTrace: stack);
      throw StudySessionFailure.storage();
    }
  }

  @override
  Future<List<StudyInterruption>> bySession(
    String ownerId,
    String sessionId,
  ) async {
    try {
      return (await _source.bySession(ownerId, sessionId)).map(_map).toList();
    } on StudySessionFailure {
      rethrow;
    } on Object catch (error, stack) {
      logger.error('Interruption read failed', error: error, stackTrace: stack);
      throw StudySessionFailure.storage();
    }
  }

  @override
  Future<int> count(String ownerId, String sessionId) async =>
      (await bySession(ownerId, sessionId)).length;

  @override
  Future<void> discard(String ownerId, String interruptionId) async {
    try {
      await _source.delete(ownerId, interruptionId);
    } on Object catch (error, stack) {
      logger.error(
        'Interruption delete failed',
        error: error,
        stackTrace: stack,
      );
      throw StudySessionFailure.storage();
    }
  }

  @override
  Future<void> clearForTests(String ownerId) => _source.clear(ownerId);
}
