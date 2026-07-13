import 'package:flutter/material.dart';
import 'package:focusly/features/analytics/analytics_public_providers.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

final class AnalyticsSummaryCard extends StatelessWidget {
  const AnalyticsSummaryCard({
    required this.analytics,
    required this.onOpen,
    this.onRetry,
    super.key,
  });

  final TodayAnalyticsProjection analytics;
  final VoidCallback onOpen;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights_outlined),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Text(
                  'Hoy',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onOpen,
              child: const Text('Ver progreso'),
            ),
          ),
          if (analytics.isLoading)
            const LinearProgressIndicator(
              semanticsLabel: 'Cargando resumen de hoy',
            ),
          if (analytics.errorMessage != null)
            _SectionError(onRetry: onRetry)
          else if (analytics.hasData)
            Wrap(
              spacing: AppSpacing.large,
              runSpacing: AppSpacing.medium,
              children: [
                _TodayMetric(
                  icon: Icons.timer_outlined,
                  label: 'Tiempo de estudio',
                  value: _durationLabel(analytics.focusedDuration),
                ),
                _TodayMetric(
                  icon: Icons.check_circle_outline,
                  label: 'Sesiones',
                  value: '${analytics.completedSessions}',
                ),
                _TodayMetric(
                  icon: Icons.pause_circle_outline,
                  label: 'Interrupciones',
                  value: '${analytics.interruptionCount}',
                ),
                _TodayMetric(
                  icon: Icons.school_outlined,
                  label: 'Curso destacado',
                  value: analytics.mostStudiedCourseName ?? 'Sin datos todavía',
                ),
              ],
            ),
        ],
      ),
    ),
  );

  String _durationLabel(Duration duration) {
    final minutes = duration.inMinutes;
    if (minutes < 60) return minutes == 1 ? '1 minuto' : '$minutes minutos';
    final hours = minutes ~/ 60;
    final remainder = minutes.remainder(60);
    return remainder == 0 ? '$hours h' : '$hours h $remainder min';
  }
}

final class _TodayMetric extends StatelessWidget {
  const _TodayMetric({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label: $value',
    child: SizedBox(
      width: 190,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                Text(value, overflow: TextOverflow.ellipsis, maxLines: 2),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

final class _SectionError extends StatelessWidget {
  const _SectionError({this.onRetry});
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('No pudimos actualizar el resumen de hoy.'),
      if (onRetry != null)
        TextButton(onPressed: onRetry, child: const Text('Reintentar')),
    ],
  );
}
