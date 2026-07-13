import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Companion does not import forbidden feature internals', () {
    const forbidden = [
      'features/dashboard/',
      'features/onboarding/presentation/',
      'features/onboarding/data/',
    ];
    final violations = <String>[];
    for (final file
        in Directory('lib/features/companion')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))) {
      final content = file.readAsStringSync();
      for (final path in forbidden) {
        if (content.contains(path)) violations.add('${file.path}: $path');
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('Domain is framework free and consumers use public Companion APIs', () {
    final domain = Directory('lib/features/companion/domain')
        .listSync(recursive: true)
        .whereType<File>()
        .map((file) => file.readAsStringSync())
        .join('\n');
    expect(domain, isNot(contains('package:flutter/')));
    expect(domain, isNot(contains('flutter_riverpod')));
    final dashboard = Directory('lib/features/dashboard')
        .listSync(recursive: true)
        .whereType<File>()
        .map((file) => file.readAsStringSync())
        .join('\n');
    expect(dashboard, isNot(contains('features/companion/presentation/')));
    final studyEngine = Directory('lib/features/study_engine')
        .listSync(recursive: true)
        .whereType<File>()
        .map((file) => file.readAsStringSync())
        .join('\n');
    expect(studyEngine, isNot(contains('features/companion/data/')));
    expect(studyEngine, isNot(contains('dart:math')));
  });
}
