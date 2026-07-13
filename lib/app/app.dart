import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/router/app_router.dart';
import 'package:focusly/app/theme/app_theme.dart';
import 'package:focusly/app/theme/theme_mode_provider.dart';
import 'package:focusly/config/app_config.dart';
import 'package:focusly/features/study_engine/presentation/widgets/study_lifecycle_observer.dart';

class FocuslyApp extends ConsumerWidget {
  const FocuslyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) =>
          StudyLifecycleObserver(child: child ?? const SizedBox.shrink()),
    );
  }
}
