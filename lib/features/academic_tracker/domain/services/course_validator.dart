import 'package:focusly/features/academic_tracker/domain/entities/course.dart';

final class CourseValidator {
  const CourseValidator();

  String normalize(String value) =>
      value.trim().replaceAll(RegExp(r'\s+'), ' ');

  String normalizeCode(String value) => normalize(value).toUpperCase();

  String? ownerId(String value) =>
      value.trim().isEmpty ? 'El propietario es obligatorio.' : null;

  String? name(String value) {
    final normalized = normalize(value);
    if (normalized.isEmpty) return 'El nombre es obligatorio.';
    if (normalized.length < 2) return 'Usa al menos 2 caracteres.';
    if (normalized.length > 80) return 'Usa hasta 80 caracteres.';
    return null;
  }

  String? code(String? value) {
    final normalized = value == null ? '' : normalize(value);
    return normalized.length > 20
        ? 'Usa un código de hasta 20 caracteres.'
        : null;
  }

  String? credits(int? value) => value != null && (value < 0 || value > 30)
      ? 'Los créditos deben estar entre 0 y 30.'
      : null;

  String? validate({
    required String ownerId,
    required String name,
    required String? code,
    required int? credits,
    required CourseVisualIdentity? visualIdentity,
    required CourseStatus? status,
  }) =>
      this.ownerId(ownerId) ??
      this.name(name) ??
      this.code(code) ??
      this.credits(credits) ??
      (visualIdentity == null ? 'Selecciona una identidad visual.' : null) ??
      (status == null ? 'Selecciona un estado.' : null);
}
