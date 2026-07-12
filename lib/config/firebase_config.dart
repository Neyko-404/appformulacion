import 'package:firebase_core/firebase_core.dart';
import 'package:focusly/core/logging/app_logger.dart';
import 'package:focusly/firebase_options.dart';

typedef FirebaseInitializer =
    Future<FirebaseApp> Function(FirebaseOptions options);

final class FirebaseConfig {
  FirebaseConfig({
    this.logger = const AppLogger(),
    FirebaseInitializer? initializer,
  }) : _initializer = initializer ?? _initializeFirebase;

  final AppLogger logger;
  final FirebaseInitializer _initializer;

  Future<FirebaseApp> initialize() async {
    logger.info('Initializing Firebase Core');
    try {
      final app = await _initializer(DefaultFirebaseOptions.currentPlatform);
      logger.info('Firebase Core initialized');
      return app;
    } on Object catch (error, stackTrace) {
      logger.error(
        'Firebase Core initialization failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  static Future<FirebaseApp> _initializeFirebase(FirebaseOptions options) {
    return Firebase.initializeApp(options: options);
  }
}
