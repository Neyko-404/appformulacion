import 'package:focusly/core/errors/app_error.dart';
import 'package:focusly/core/logging/app_logger.dart';

class ErrorReporter {
  const ErrorReporter(this._logger);

  final AppLogger _logger;

  void report(
    Object error,
    StackTrace stackTrace, {
    String context = 'Unhandled application error',
  }) {
    final appError = _normalize(error);
    _logger.fatal(
      '$context: ${appError.message}',
      error: appError.cause ?? error,
      stackTrace: stackTrace,
    );
  }

  AppError _normalize(Object error) {
    if (error is AppError) {
      return error;
    }

    return AppError(
      message: 'Ocurrió un error inesperado.',
      code: 'unexpected_error',
      cause: error,
    );
  }
}
