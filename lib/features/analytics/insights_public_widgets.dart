import 'package:flutter/material.dart';
import 'package:focusly/features/analytics/domain/entities/study_insight.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

final class StudyInsightsSection extends StatelessWidget {
  const StudyInsightsSection({
    required this.title,
    required this.collection,
    required this.maxItems,
    required this.onAction,
    super.key,
  });

  final String title;
  final InsightCollection collection;
  final int maxItems;
  final ValueChanged<InsightAction> onAction;

  @override
  Widget build(BuildContext context) {
    final values = collection.values.take(maxItems).toList();
    if (values.isEmpty) return const SizedBox.shrink();
    return Semantics(
      container: true,
      label: '$title. ${values.length} recomendaciones.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.small),
          for (final value in values)
            _InsightCard(value: value, onAction: onAction),
        ],
      ),
    );
  }
}

final class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.value, required this.onAction});
  final StudyInsight value;
  final ValueChanged<InsightAction> onAction;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '${value.title}. ${value.message}',
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_icon(value.category)),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  Text(value.message),
                  if (value.action != InsightAction.none) ...[
                    const SizedBox(height: AppSpacing.small),
                    TextButton(
                      onPressed: () => onAction(value.action),
                      child: Text(_actionLabel(value.action)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  IconData _icon(InsightCategory category) => switch (category) {
    InsightCategory.progress => Icons.trending_up,
    InsightCategory.consistency => Icons.calendar_today_outlined,
    InsightCategory.focus => Icons.center_focus_strong_outlined,
    InsightCategory.interruption => Icons.pause_circle_outline,
    InsightCategory.course => Icons.school_outlined,
    InsightCategory.motivation => Icons.lightbulb_outline,
    InsightCategory.general => Icons.insights_outlined,
  };

  String _actionLabel(InsightAction action) => switch (action) {
    InsightAction.continueFocus => 'Continuar sesión',
    InsightAction.startFocus => 'Comenzar sesión',
    InsightAction.openAnalytics ||
    InsightAction.reviewProgress => 'Ver progreso',
    InsightAction.openCourses => 'Ver cursos',
    InsightAction.none => '',
  };
}
