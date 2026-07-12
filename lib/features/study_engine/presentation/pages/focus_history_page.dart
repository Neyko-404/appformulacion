import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/academic_tracker/course_public_providers.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/presentation/widgets/focus_experience_widgets.dart';
import 'package:focusly/features/study_engine/study_engine_providers.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

class FocusHistoryPage extends ConsumerWidget {
  const FocusHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyEngineNotifierProvider);
    final notifier = ref.read(studyEngineNotifierProvider.notifier);
    final courses = ref.watch(activeCoursesProvider).courses;

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de enfoque')),
      body: SafeArea(
        child: state.isInitializing
            ? const Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Cargando historial',
                ),
              )
            : state.errorMessage != null && state.recentSessions.isEmpty
            ? _HistoryError(
                message: state.errorMessage!,
                isRetrying: state.isOperating,
                onRetry: notifier.refreshHistory,
              )
            : state.recentSessions.isEmpty
            ? const _EmptyHistory()
            : RefreshIndicator(
                onRefresh: notifier.refreshHistory,
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.xLarge),
                  itemCount: state.recentSessions.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.small),
                  itemBuilder: (context, index) {
                    final session = state.recentSessions[index];
                    final courseName = courses
                        .where((course) => course.id == session.courseId)
                        .firstOrNull
                        ?.name;
                    return _HistoryTile(
                      session: session,
                      courseLabel:
                          courseName ??
                          (session.courseId == null
                              ? 'Sesión libre'
                              : 'Curso asociado'),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

final class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history_toggle_off_outlined, size: 48),
          const SizedBox(height: AppSpacing.large),
          Text(
            'Todavía no has realizado ninguna sesión.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.small),
          const Text(
            'Comienza una para verla aquí.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

final class _HistoryError extends StatelessWidget {
  const _HistoryError({
    required this.message,
    required this.isRetrying,
    required this.onRetry,
  });

  final String message;
  final bool isRetrying;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_outlined, size: 48),
          const SizedBox(height: AppSpacing.large),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.large),
          FilledButton.icon(
            onPressed: isRetrying ? null : onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    ),
  );
}

final class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.session, required this.courseLabel});

  final StudySession session;
  final String courseLabel;

  @override
  Widget build(BuildContext context) {
    final completed = session.status == StudySessionStatus.completed;
    final local = session.updatedAt.toLocal();
    final date = '${local.day}/${local.month}/${local.year}';
    return Card(
      child: ListTile(
        isThreeLine: true,
        leading: Icon(
          completed ? Icons.check_circle_outline : Icons.cancel_outlined,
          color: completed
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
        ),
        title: Text(completed ? 'Sesión completada' : 'Sesión cancelada'),
        subtitle: Text(
          '$courseLabel\n'
          '${focusDurationLabel(session.accumulatedFocusDuration)} · $date',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
