import 'dart:async';

import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/domain/failures/study_session_failure.dart';
import 'package:focusly/features/study_engine/domain/repositories/study_session_repository.dart';

final class InMemoryStudySessionRepository implements StudySessionRepository {
  final Map<String, StudySession> _sessions = {};
  final StreamController<void> _changes = StreamController.broadcast(
    sync: true,
  );
  StudySession? _active(String ownerId) => _sessions.values
      .where((value) => value.ownerId == ownerId && value.isActive)
      .firstOrNull;
  @override
  Stream<StudySession?> watchActive(String ownerId) =>
      Stream.multi((controller) {
        final subscription = _changes.stream.listen(
          (_) => controller.add(_active(ownerId)),
          onDone: controller.close,
        );
        controller
          ..onCancel = subscription.cancel
          ..add(_active(ownerId));
      });
  @override
  Future<StudySession?> getActive(String ownerId) async => _active(ownerId);
  @override
  Future<void> save(StudySession session) async {
    final active = _active(session.ownerId);
    if (session.isActive && active != null && active.id != session.id) {
      throw StudySessionFailure.activeExists();
    }
    _sessions[session.id] = session;
    _changes.add(null);
  }

  @override
  Future<List<StudySession>> recent(String ownerId, {int limit = 30}) async {
    final values =
        _sessions.values
            .where((value) => value.ownerId == ownerId && !value.isActive)
            .toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return values.take(limit).toList();
  }

  @override
  Future<List<StudySession>> byCourse(String ownerId, String courseId) async =>
      _sessions.values
          .where(
            (value) => value.ownerId == ownerId && value.courseId == courseId,
          )
          .toList();
  @override
  Future<void> clearForTests(String ownerId) async {
    _sessions.removeWhere((_, value) => value.ownerId == ownerId);
    _changes.add(null);
  }

  void dispose() => unawaited(_changes.close());
}
