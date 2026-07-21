import 'package:flutter/material.dart';
import 'package:focusly/features/goals/goals_public_providers.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

class FocusGoalCard extends StatelessWidget {
  const FocusGoalCard({
    required this.profile,
    required this.goals,
    required this.onOpen,
    required this.onRetry,
    super.key,
  });

  final StudentProfile profile;
  final GoalsDashboardSummary goals;
  final VoidCallback onOpen;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.track_changes_outlined),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    'Tus metas',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            if (goals.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (goals.errorMessage != null) ...[
              Text(goals.errorMessage!),
              const SizedBox(height: AppSpacing.small),
              OutlinedButton(
                onPressed: onRetry,
                child: const Text('Reintentar'),
              ),
            ] else if (!goals.hasConfiguredGoals) ...[
              const Text('Todavía no configuraste metas de estudio.'),
              const SizedBox(height: AppSpacing.small),
              FilledButton.tonal(
                onPressed: onOpen,
                child: const Text('Configurar metas'),
              ),
            ] else ...[
              if (goals.progress == null)
                const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.medium),
                  child: Text('Preparando tu progreso.'),
                ),
              if (goals.progress?.dailyMinutes case final progress?
                  when progress.isEnabled)
                _SummaryProgress(
                  title: 'Meta diaria',
                  progress: progress,
                  unit: 'min',
                ),
              if (goals.progress?.weeklySessions case final progress?
                  when progress.isEnabled)
                _SummaryProgress(
                  title: 'Sesiones esta semana',
                  progress: progress,
                  unit: 'sesiones',
                ),
              if (goals.progress?.weeklyActiveDays case final progress?
                  when progress.isEnabled)
                _SummaryProgress(
                  title: 'Días activos',
                  progress: progress,
                  unit: 'días',
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onOpen,
                  child: const Text('Editar metas'),
                ),
              ),
            ],
            const Divider(),
            Text('Objetivo personal: ${_goalLabel(profile.primaryGoal)}'),
          ],
        ),
      ),
    );
  }

  String _goalLabel(PrimaryGoal goal) => switch (goal) {
    PrimaryGoal.organization => 'Organizar mejor mis estudios',
    PrimaryGoal.concentration => 'Mejorar mi concentración',
    PrimaryGoal.examPreparation => 'Prepararme para evaluaciones',
    PrimaryGoal.routine => 'Construir una rutina de estudio',
    PrimaryGoal.memory => 'Recordar mejor lo aprendido',
  };
}

final class _SummaryProgress extends StatelessWidget {
  const _SummaryProgress({
    required this.title,
    required this.progress,
    required this.unit,
  });

  final String title;
  final FocusGoalProgress progress;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final label = '${progress.current} / ${progress.target} $unit';
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title · $label'),
          const SizedBox(height: AppSpacing.xSmall),
          GoalProgressIndicator(value: progress.completionRatio, label: label),
          if (progress.isCompleted)
            Text(
              title == 'Meta diaria'
                  ? 'Meta alcanzada por hoy.'
                  : 'Meta alcanzada esta semana.',
            ),
        ],
      ),
    );
  }
}
