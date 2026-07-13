import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/study_engine/study_engine_providers.dart';

/// Bridges application visibility events to Study Engine for the app lifetime.
final class StudyLifecycleObserver extends ConsumerStatefulWidget {
  const StudyLifecycleObserver({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<StudyLifecycleObserver> createState() =>
      _StudyLifecycleObserverState();
}

final class _StudyLifecycleObserverState
    extends ConsumerState<StudyLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notifier = ref.read(studyEngineNotifierProvider.notifier);
    switch (state) {
      case AppLifecycleState.resumed:
        notifier.handleAppResumed();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        notifier.handleAppBackgrounded();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
