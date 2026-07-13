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
}
