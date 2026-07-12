import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/onboarding/domain/services/onboarding_validator.dart';

void main() {
  const validator = OnboardingValidator();

  test('rejects empty university and career', () {
    expect(validator.requiredText('', 'La universidad'), isNotNull);
    expect(validator.requiredText(' ', 'La carrera'), isNotNull);
  });

  test('rejects invalid cycle', () {
    expect(validator.cycle(0), isNotNull);
    expect(validator.cycle(13), isNotNull);
  });

  test('requires goal and valid duration', () {
    expect(validator.goal(null), isNotNull);
    expect(validator.goal(PrimaryGoal.routine), isNull);
    expect(validator.focusMinutes(30), isNotNull);
    expect(validator.focusMinutes(25), isNull);
  });

  test('validates companion name and appearance', () {
    expect(validator.companionName(''), isNotNull);
    expect(validator.companionName('aaaaaaaaaaaaaaaaaaaaaaaaa'), isNotNull);
    expect(validator.companionName('Milo'), isNull);
    expect(validator.appearance(null), isNotNull);
    expect(validator.appearance(CompanionAppearance.amber), isNull);
  });

  test('normalizes companion spaces', () {
    expect(validator.normalizeName('  Mi   gato  '), 'Mi gato');
  });
}
