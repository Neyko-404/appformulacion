import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Goals Domain remains pure and does not import internal Analytics', () {
    final files = Directory('lib/features/goals/domain')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
    for (final file in files) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains('package:flutter/')), reason: file.path);
      expect(source, isNot(contains('flutter_riverpod')), reason: file.path);
      expect(
        source,
        isNot(contains('features/analytics/data/')),
        reason: file.path,
      );
      expect(
        source,
        isNot(contains('features/analytics/presentation/')),
        reason: file.path,
      );
    }
  });

  test('Dashboard imports only the public Goals contract', () {
    final files = Directory('lib/features/dashboard')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
    for (final file in files) {
      final goalImports = RegExp(
        "import 'package:focusly/features/goals/([^']+)'",
      ).allMatches(file.readAsStringSync());
      for (final match in goalImports) {
        expect(
          match.group(1),
          'goals_public_providers.dart',
          reason: file.path,
        );
      }
    }
  });

  test('local schema persists configuration, never progress', () {
    final source = File(
      'lib/features/goals/data/models/focus_goal_local_model.dart',
    ).readAsStringSync();
    expect(source, contains('dailyMinutesTarget'));
    expect(source, isNot(contains('Progress')));
    expect(source, isNot(contains('completionRatio')));
  });
}
