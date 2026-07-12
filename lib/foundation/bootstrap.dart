import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/app.dart';
import 'package:focusly/config/firebase_config.dart';
import 'package:focusly/core/errors/error_reporter.dart';
import 'package:focusly/core/logging/app_logger.dart';
import 'package:focusly/features/academic_tracker/data/models/course_local_model.dart';
import 'package:focusly/features/onboarding/data/models/student_profile_local_model.dart';
import 'package:focusly/features/onboarding/data/models/study_companion_local_model.dart';
import 'package:focusly/services/local_database/local_database.dart';
import 'package:focusly/services/local_database/local_database_provider.dart';

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

      try {
        final database = await LocalDatabase.open(
          schemas: const [
            CourseLocalModelSchema,
            StudentProfileLocalModelSchema,
            StudyCompanionLocalModelSchema,
          ],
        );
        logger.info('Starting Focusly foundation');
        runApp(
          ProviderScope(
            overrides: [localDatabaseProvider.overrideWithValue(database)],
            child: const FocuslyApp(),
          ),
        );
      } on Object catch (error, stackTrace) {
        errorReporter.report(
          error,
          stackTrace,
          context: 'Local database initialization error',
        );
        rethrow;
      }
    },
    (error, stackTrace) {
      errorReporter.report(error, stackTrace, context: 'Uncaught zone error');
    },
  );
}
