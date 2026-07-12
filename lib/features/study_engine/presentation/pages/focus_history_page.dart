import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/study_engine/study_engine_providers.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

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
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xLarge),
                  child: Text(
                    'Todavía no has realizado ninguna sesión.\n'
                    'Comienza una para verla aquí.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.xLarge),
                itemCount: state.recentSessions.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.small),
                itemBuilder: (context, index) {
                  final session = state.recentSessions[index];
                  final minutes = session.accumulatedFocusDuration.inMinutes;
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.access_time_outlined),
                      title: Text(_minutesLabel(minutes)),
                      subtitle: Text(
                        '${session.updatedAt.toLocal()} · ${session.status.name}'
                        '${session.courseId == null ? ' · Sesión libre' : ' · Curso'}',
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _minutesLabel(int minutes) =>
      minutes == 1 ? '1 minuto' : '$minutes minutos';
}
