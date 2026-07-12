import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/authentication/domain/services/auth_validator.dart';

void main() {
  const validator = AuthValidator();

  group('AuthValidator', () {
    test('rejects an empty email', () {
      expect(validator.validateEmail(''), 'El correo es obligatorio.');
    });

    test('rejects an invalid email', () {
      expect(
        validator.validateEmail('student@focusly'),
        'Ingresa un correo válido.',
      );
    });

    test('accepts a valid email', () {
      expect(validator.validateEmail('student@focusly.dev'), isNull);
    });

    test('rejects an empty password', () {
      expect(validator.validatePassword(''), 'La contraseña es obligatoria.');
    });

    test('rejects a short password', () {
      expect(validator.validatePassword('short'), 'Usa al menos 8 caracteres.');
    });

    test('rejects a different confirmation', () {
      expect(
        validator.validatePasswordConfirmation('different', 'password123'),
        'Las contraseñas no coinciden.',
      );
    });

    test('accepts valid registration data', () {
      expect(validator.validateEmail('student@focusly.dev'), isNull);
      expect(validator.validatePassword('password123'), isNull);
      expect(
        validator.validatePasswordConfirmation('password123', 'password123'),
        isNull,
      );
      expect(validator.validateTermsAccepted(true), isNull);
    });
  });
}
