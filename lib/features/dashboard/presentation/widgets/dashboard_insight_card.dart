import 'package:flutter/material.dart';
import 'package:focusly/features/dashboard/presentation/models/dashboard_insight.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

final class DashboardInsightCard extends StatelessWidget {
  const DashboardInsightCard({
    required this.insight,
    required this.onAction,
    super.key,
  });

  final DashboardInsight insight;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (icon, color) = switch (insight.tone) {
      DashboardInsightTone.neutral => (
        Icons.self_improvement,
        colors.secondary,
      ),
      DashboardInsightTone.encouraging => (
        Icons.wb_sunny_outlined,
        colors.primary,
      ),
      DashboardInsightTone.informative => (
        Icons.lightbulb_outline,
        colors.tertiary,
      ),
    };
    return Semantics(
      container: true,
      label: '${insight.title}. ${insight.message}',
      child: Card(
        color: colors.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xSmall),
                    Text(insight.message),
                    if (onAction != null) ...[
                      const SizedBox(height: AppSpacing.small),
                      TextButton(
                        onPressed: onAction,
                        child: Text(_actionLabel(insight.actionType)),
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
  }

  String _actionLabel(DashboardInsightAction action) => switch (action) {
    DashboardInsightAction.startFocus => 'Comenzar sesión',
    DashboardInsightAction.continueFocus => 'Volver a la sesión',
    DashboardInsightAction.openCourses => 'Agregar curso',
    DashboardInsightAction.openAnalytics => 'Ver progreso',
    DashboardInsightAction.none => '',
  };
}
