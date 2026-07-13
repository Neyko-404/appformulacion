import 'package:flutter/material.dart';
import 'package:focusly/features/analytics/analytics_public_providers.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

final class AnalyticsSummaryCard extends StatelessWidget {
  const AnalyticsSummaryCard({
    required this.analytics,
    required this.onOpen,
    super.key,
  });

  final TodayAnalyticsProjection analytics;
  final VoidCallback onOpen;

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
                  'Resumen de hoy',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(onPressed: onOpen, child: const Text('Ver progreso')),
            ],
          ),
          if (analytics.isLoading)
            const LinearProgressIndicator(
              semanticsLabel: 'Cargando resumen de hoy',
            )
          else ...[
            Text(
              'Tiempo estudiado: ${_durationLabel(analytics.focusedDuration)}',
            ),
            Text('Sesiones completadas: ${analytics.completedSessions}'),
            Text(
              'Curso con más tiempo: '
              '${analytics.mostStudiedCourseName ?? 'Sin datos todavía'}',
            ),
            Text(
              'Interrupciones registradas: ${analytics.interruptionCount} '
              '(${_durationLabel(analytics.interruptionDuration)})',
            ),
          ],
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
