final class AuthValidator {
  const AuthValidator({this.minimumPasswordLength = 8});

  final int minimumPasswordLength;

  String? validateRequired(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio.';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final requiredError = validateRequired(value, fieldName: 'El correo');
    if (requiredError != null) {
      return requiredError;
    }

    final email = value!.trim();
    final atIndex = email.indexOf('@');
    final lastDotIndex = email.lastIndexOf('.');
    final hasBasicFormat =
        atIndex > 0 &&
        atIndex == email.lastIndexOf('@') &&
        lastDotIndex > atIndex + 1 &&
        lastDotIndex < email.length - 1;

    if (!hasBasicFormat) {
      return 'Ingresa un correo válido.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria.';
    }
    if (value.length < minimumPasswordLength) {
      return 'Usa al menos $minimumPasswordLength caracteres.';
    }
    return null;
  }

  String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'La confirmación es obligatoria.';
    }
    if (value != password) {
      return 'Las contraseñas no coinciden.';
    }
    return null;
  }

  String? validateTermsAccepted(bool? accepted) {
    if (accepted != true) {
      return 'Debes aceptar las condiciones provisionales.';
    }
    return null;
  }
}
