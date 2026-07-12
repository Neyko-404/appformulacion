enum CourseFailureType {
  invalidData,
  duplicateCode,
  notFound,
  unauthorizedAccess,
  storage,
  corruptedData,
  unexpected,
}

final class CourseFailure implements Exception {
  const CourseFailure(this.type, this.safeMessage);

  final CourseFailureType type;
  final String safeMessage;

  factory CourseFailure.duplicateCode() => const CourseFailure(
    CourseFailureType.duplicateCode,
    'Ya existe un curso con ese código.',
  );
  factory CourseFailure.notFound() => const CourseFailure(
    CourseFailureType.notFound,
    'No pudimos encontrar ese curso.',
  );
  factory CourseFailure.storage() => const CourseFailure(
    CourseFailureType.storage,
    'No pudimos guardar los cursos.',
  );
  factory CourseFailure.corruptedData() => const CourseFailure(
    CourseFailureType.corruptedData,
    'Un curso guardado no se pudo validar.',
  );
}
