import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/study_engine/domain/services/interruption_policy.dart';

void main() {
  const policy = InterruptionPolicy();

  test('uses one centralized inclusive five-second threshold', () {
    expect(InterruptionPolicy.relevantThreshold, const Duration(seconds: 5));
    expect(policy.isRelevant(const Duration(seconds: 4)), isFalse);
    expect(policy.isRelevant(const Duration(seconds: 5)), isTrue);
    expect(policy.isRelevant(const Duration(seconds: 6)), isTrue);
    expect(policy.isRelevant(const Duration(seconds: -1)), isFalse);
  });
}
