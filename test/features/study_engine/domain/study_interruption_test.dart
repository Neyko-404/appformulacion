import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/study_engine/domain/entities/study_interruption.dart';

void main() {
  final start = DateTime.utc(2026, 7, 12, 10);

  test('supports open and closed interruptions with derived duration', () {
    final open = StudyInterruption(
      id: 'i-1',
      startedAt: start,
      reason: StudyInterruptionReason.appBackgrounded,
      createdAt: start,
    );
    expect(open.isOpen, isTrue);
    expect(open.duration, Duration.zero);

    final closed = open.close(start.add(const Duration(seconds: 8)));
    expect(closed.isOpen, isFalse);
    expect(closed.duration, const Duration(seconds: 8));
    expect(closed, open.close(start.add(const Duration(seconds: 8))));
  });

  test('rejects empty identity and incoherent dates', () {
    expect(
      () => StudyInterruption(
        id: ' ',
        startedAt: start,
        reason: StudyInterruptionReason.unknown,
        createdAt: start,
      ),
      throwsArgumentError,
    );
    expect(
      () => StudyInterruption(
        id: 'i-1',
        startedAt: start,
        endedAt: start.subtract(const Duration(seconds: 1)),
        reason: StudyInterruptionReason.screenInterrupted,
        createdAt: start,
      ),
      throwsArgumentError,
    );
  });
}
