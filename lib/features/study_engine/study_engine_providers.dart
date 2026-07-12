import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/study_engine/data/data_sources/isar_study_session_local_data_source.dart';
import 'package:focusly/features/study_engine/data/data_sources/study_session_local_data_source.dart';
import 'package:focusly/features/study_engine/data/repositories/in_memory_study_session_repository.dart';
import 'package:focusly/features/study_engine/data/repositories/isar_study_session_repository.dart';
import 'package:focusly/features/study_engine/domain/repositories/study_session_repository.dart';
import 'package:focusly/features/study_engine/domain/services/study_clock.dart';
import 'package:focusly/features/study_engine/domain/services/study_session_engine.dart';
import 'package:focusly/features/study_engine/presentation/notifiers/study_engine_notifier.dart';
import 'package:focusly/features/study_engine/presentation/state/study_engine_state.dart';
import 'package:focusly/services/local_database/local_database_provider.dart';

final studySessionLocalDataSourceProvider =
    Provider<StudySessionLocalDataSource>((ref) {
      final database = ref.watch(localDatabaseProvider);
      if (database == null) throw StateError('Local database unavailable');
      return IsarStudySessionLocalDataSource(database);
    });
final studySessionRepositoryProvider = Provider<StudySessionRepository>((ref) {
  if (ref.watch(localDatabaseProvider) == null) {
    return InMemoryStudySessionRepository();
  }
  return IsarStudySessionRepository(
    ref.watch(studySessionLocalDataSourceProvider),
  );
});
final studyClockProvider = Provider<StudyClock>(
  (ref) => const SystemStudyClock(),
);
final studySessionEngineProvider = Provider<StudySessionEngine>(
  (ref) => StudySessionEngine(ref.watch(studyClockProvider)),
);
final studyEngineNotifierProvider =
    NotifierProvider<StudyEngineNotifier, StudyEngineState>(
      StudyEngineNotifier.new,
    );
