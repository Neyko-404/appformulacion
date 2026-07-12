import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/app.dart';
import 'package:focusly/config/firebase_config.dart';
import 'package:focusly/core/errors/error_reporter.dart';
import 'package:focusly/core/logging/app_logger.dart';

void bootstrap() {
  const logger = AppLogger();
  const errorReporter = ErrorReporter(logger);

  runZonedGuarded(
    () async {
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

      try {
        await FirebaseConfig(logger: logger).initialize();
      } on Object catch (error, stackTrace) {
        errorReporter.report(
          error,
          stackTrace,
          context: 'Firebase Core initialization error',
        );
        logger.warning('Focusly will continue without Firebase services');
      }

      logger.info('Starting Focusly foundation');
      runApp(const ProviderScope(child: FocuslyApp()));
    },
    (error, stackTrace) {
      errorReporter.report(error, stackTrace, context: 'Uncaught zone error');
    },
  );
}
