import 'package:focusly/core/logging/app_logger.dart';
import 'package:focusly/features/study_engine/data/data_sources/study_session_local_data_source.dart';
import 'package:focusly/features/study_engine/data/mappers/study_session_mapper.dart';
import 'package:focusly/features/study_engine/data/models/study_session_local_model.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/domain/failures/study_session_failure.dart';
import 'package:focusly/features/study_engine/domain/repositories/study_session_repository.dart';

final class IsarStudySessionRepository implements StudySessionRepository {
  const IsarStudySessionRepository(
    this._source, {
    this.mapper = const StudySessionMapper(),
    this.logger = const AppLogger(),
  });
  final StudySessionLocalDataSource _source;
  final StudySessionMapper mapper;
  final AppLogger logger;

  @override
  Stream<StudySession?> watchActive(String ownerId) => _source
      .watchActive(ownerId)
      .map((model) => model == null ? null : _toDomain(model));
  @override
  Future<StudySession?> getActive(String ownerId) async {
    try {
      final model = await _source.getActive(ownerId);
      return model == null ? null : _toDomain(model);
    } on StudySessionFailure {
      rethrow;
    } on Object catch (error, stack) {
      logger.error(
        'Study session read failed',
        error: error,
        stackTrace: stack,
      );
      throw StudySessionFailure.storage();
    }
  }

  @override
  Future<void> save(StudySession session) async {
    try {
      final active = await getActive(session.ownerId);
      if (session.isActive && active != null && active.id != session.id) {
        throw StudySessionFailure.activeExists();
      }
      await _source.put(mapper.toLocal(session));
    } on StudySessionFailure {
      rethrow;
    } on Object catch (error, stack) {
      logger.error(
        'Study session save failed',
        error: error,
        stackTrace: stack,
      );
      throw StudySessionFailure.storage();
    }
  }

  @override
  Future<List<StudySession>> recent(String ownerId, {int limit = 30}) async {
    try {
      return (await _source.recent(ownerId, limit)).map(_toDomain).toList();
    } on StudySessionFailure {
      rethrow;
    } on Object catch (error, stack) {
      logger.error(
        'Study session read failed',
        error: error,
        stackTrace: stack,
      );
      throw StudySessionFailure.storage();
    }
  }

  @override
  Future<List<StudySession>> byCourse(String ownerId, String courseId) async {
    try {
      return (await _source.byCourse(
        ownerId,
        courseId,
      )).map(_toDomain).toList();
    } on StudySessionFailure {
      rethrow;
    } on Object catch (error, stack) {
      logger.error(
        'Study session read failed',
        error: error,
        stackTrace: stack,
      );
      throw StudySessionFailure.storage();
    }
  }

  @override
  Future<void> clearForTests(String ownerId) => _source.clear(ownerId);

  StudySession _toDomain(StudySessionLocalModel model) {
    try {
      return mapper.toDomain(model);
    } on FormatException catch (error, stack) {
      logger.error('Corrupted study session', error: error, stackTrace: stack);
      throw StudySessionFailure.corrupted();
    }
  }
}
