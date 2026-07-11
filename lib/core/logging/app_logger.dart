import 'dart:developer' as developer;

class AppLogger {
  const AppLogger({this.name = 'Focusly'});

  final String name;

  void debug(String message) => _log(message, level: 500);

  void info(String message) => _log(message, level: 800);

  void warning(String message, {Object? error, StackTrace? stackTrace}) =>
      _log(message, level: 900, error: error, stackTrace: stackTrace);

  void error(String message, {Object? error, StackTrace? stackTrace}) =>
      _log(message, level: 1000, error: error, stackTrace: stackTrace);

  void fatal(String message, {Object? error, StackTrace? stackTrace}) =>
      _log(message, level: 1200, error: error, stackTrace: stackTrace);

  void _log(
    String message, {
    required int level,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name,
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
