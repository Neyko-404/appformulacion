import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/study_engine/data/repositories/in_memory_study_interruption_repository.dart';
import 'package:focusly/features/study_engine/domain/entities/study_interruption.dart';

void main() {
  final start = DateTime.utc(2026, 7, 12, 10);
  late InMemoryStudyInterruptionRepository repository;

  setUp(() => repository = InMemoryStudyInterruptionRepository());

  StudyInterruption value(String id) => StudyInterruption(
    id: id,
    startedAt: start,
    reason: StudyInterruptionReason.appBackgrounded,
    createdAt: start,
  );

  test('stores one open interruption then closes and counts it', () async {
    await repository.saveOpen('user-1', 'session-1', value('i-1'));
    expect((await repository.open('user-1', 'session-1'))?.id, 'i-1');
    await expectLater(
      repository.saveOpen('user-1', 'session-1', value('i-2')),
      throwsA(isA<Exception>()),
    );
    await repository.saveClosed(
      'user-1',
      'session-1',
      value('i-1').close(start.add(const Duration(seconds: 6))),
    );
    expect(await repository.open('user-1', 'session-1'), isNull);
    expect(await repository.count('user-1', 'session-1'), 1);
    expect(await repository.bySession('user-1', 'session-1'), hasLength(1));
  });

  test('isolates owners and validates identity', () async {
    await repository.saveOpen('user-1', 'session-1', value('i-1'));
    expect(await repository.open('user-2', 'session-1'), isNull);
    await expectLater(
      repository.saveOpen('', 'session-1', value('i-2')),
      throwsA(isA<Exception>()),
    );
  });
}
