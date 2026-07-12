import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/app.dart';
import 'package:focusly/core/errors/error_reporter.dart';
import 'package:focusly/core/logging/app_logger.dart';

void bootstrap() {
  const logger = AppLogger();
  const errorReporter = ErrorReporter(logger);

  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        errorReporter.report(
          details.exception,
          details.stack ?? StackTrace.current,
          context: 'Flutter framework error',
        );
      };

      PlatformDispatcher.instance.onError = (error, stackTrace) {
        errorReporter.report(
          error,
          stackTrace,
          context: 'Uncaught asynchronous error',
        );
        return true;
      };

      logger.info('Starting Focusly foundation');
      runApp(const ProviderScope(child: FocuslyApp()));
    },
    (error, stackTrace) {
      errorReporter.report(error, stackTrace, context: 'Uncaught zone error');
    },
  );
}
