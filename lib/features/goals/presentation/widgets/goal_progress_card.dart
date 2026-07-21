import 'package:flutter/material.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_progress.dart';
import 'package:focusly/features/goals/presentation/widgets/goal_progress_indicator.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

class GoalProgressCard extends StatelessWidget {
  const GoalProgressCard({
    required this.title,
    required this.progress,
    required this.unit,
    super.key,
  });

  final String title;
  final FocusGoalProgress progress;
  final String unit;

  @override
  Widget build(BuildContext context) {
    if (!progress.isEnabled) return const SizedBox.shrink();
    final valueLabel = '${progress.current} / ${progress.target} $unit';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.small),
            Text(valueLabel),
            const SizedBox(height: AppSpacing.small),
            GoalProgressIndicator(
              value: progress.completionRatio,
              label: '$title: $valueLabel',
            ),
            if (progress.isCompleted) ...[
              const SizedBox(height: AppSpacing.small),
              Text(
                title == 'Meta diaria'
                    ? 'Hoy ya alcanzaste tu meta.'
                    : 'Meta alcanzada esta semana.',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
