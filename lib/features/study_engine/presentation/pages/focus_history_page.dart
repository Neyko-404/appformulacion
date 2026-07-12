import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/study_engine/study_engine_providers.dart';

class FocusHistoryPage extends ConsumerWidget {
  const FocusHistoryPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyEngineNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de enfoque')),
      body: SafeArea(
        child: state.isInitializing
            ? const Center(child: CircularProgressIndicator())
            : state.recentSessions.isEmpty
            ? const Center(child: Text('Aún no hay sesiones registradas'))
            : ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: state.recentSessions.length,
                itemBuilder: (context, index) {
                  final session = state.recentSessions[index];
                  return ListTile(
                    leading: const Icon(Icons.timer_outlined),
                    title: Text(
                      '${session.accumulatedFocusDuration.inMinutes} minutos',
                    ),
                    subtitle: Text(
                      '${session.updatedAt.toLocal()} · ${session.status.name}'
                      '${session.courseId == null ? ' · Sesión libre' : ' · Curso'}',
                    ),
                  );
                },
              ),
      ),
    );
  }
}
