import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/study_engine/data/mappers/study_interruption_mapper.dart';
import 'package:focusly/features/study_engine/domain/entities/study_interruption.dart';

void main() {
  const mapper = StudyInterruptionMapper();
  final start = DateTime.utc(2026, 7, 12, 10);
  final interruption = StudyInterruption(
    id: 'domain-id',
    startedAt: start,
    endedAt: start.add(const Duration(seconds: 7)),
    reason: StudyInterruptionReason.appBackgrounded,
    createdAt: start,
  );

  test('round trip preserves domain data independently from Isar id', () {
    final local = mapper.toLocal('user-1', 'session-1', interruption)..id = 42;
    expect(local.durationSeconds, 7);
    expect(mapper.toDomain(local), interruption);
    expect(mapper.toLocal('user-1', 'session-1', interruption).id, isNot(42));
  });

  test('rejects unknown reasons and incoherent persisted dates', () {
    final local = mapper.toLocal('user-1', 'session-1', interruption)
      ..reason = 'futureReason';
    expect(() => mapper.toDomain(local), throwsFormatException);
    local
      ..reason = StudyInterruptionReason.appBackgrounded.name
      ..endedAt = start.subtract(const Duration(seconds: 1));
    expect(() => mapper.toDomain(local), throwsA(isA<ArgumentError>()));
  });
}
