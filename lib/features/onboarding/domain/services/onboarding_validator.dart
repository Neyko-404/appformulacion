import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';

final class OnboardingValidator {
  const OnboardingValidator();

  static const allowedFocusMinutes = {15, 25, 40, 50};

  String? requiredText(String value, String field) {
    if (value.trim().isEmpty) {
      return '$field es obligatorio.';
    }
    return null;
  }

  String? cycle(int? value) {
    if (value == null || value < 1 || value > 12) {
      return 'Selecciona un ciclo entre 1 y 12.';
    }
    return null;
  }

  String? goal(PrimaryGoal? value) {
    return value == null ? 'Selecciona un objetivo principal.' : null;
  }

  String? focusMinutes(int value) {
    return allowedFocusMinutes.contains(value)
        ? null
        : 'Selecciona una duración disponible.';
  }

  String? companionName(String value) {
    final normalized = normalizeName(value);
    if (normalized.isEmpty) {
      return 'El nombre del compañero es obligatorio.';
    }
    if (normalized.length > 24) {
      return 'Usa un nombre de hasta 24 caracteres.';
    }
    if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ '-]+$").hasMatch(normalized)) {
      return 'Usa letras, espacios, apóstrofes o guiones.';
    }
    return null;
  }

  String? appearance(CompanionAppearance? value) {
    return value == null ? 'Selecciona una apariencia.' : null;
  }

  String normalizeName(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
