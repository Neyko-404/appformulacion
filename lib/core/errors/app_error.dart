class AppError implements Exception {
  const AppError({required this.message, this.code, this.cause});

  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() {
    final errorCode = code;
    return errorCode == null
        ? 'AppError: $message'
        : 'AppError($errorCode): $message';
  }
}
