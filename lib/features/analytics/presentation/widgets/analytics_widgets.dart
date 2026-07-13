import 'package:flutter/material.dart';
import 'package:focusly/features/analytics/domain/entities/study_analytics.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

String analyticsDurationLabel(Duration duration) {
  final minutes = duration.inMinutes;
  if (minutes < 60) return minutes == 1 ? '1 minuto' : '$minutes minutos';
  final hours = minutes ~/ 60;
  final remainder = minutes.remainder(60);
  final hoursLabel = '$hours h';
  return remainder == 0 ? hoursLabel : '$hoursLabel $remainder min';
}

final class AnalyticsPeriodCard extends StatelessWidget {
  const AnalyticsPeriodCard({
    required this.title,
    required this.focusedDuration,
    required this.completedSessions,
    required this.interruptionCount,
    required this.interruptionDuration,
    super.key,
  });

  final String title;
  final Duration focusedDuration;
  final int completedSessions;
  final int interruptionCount;
  final Duration interruptionDuration;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label:
        '$title. ${analyticsDurationLabel(focusedDuration)} de estudio. '
        '$completedSessions sesiones completadas. $interruptionCount interrupciones.',
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.medium),
            _Metric(
              label: 'Tiempo de estudio',
              value: analyticsDurationLabel(focusedDuration),
            ),
            _Metric(label: 'Sesiones completadas', value: '$completedSessions'),
            _Metric(
              label: 'Interrupciones registradas',
              value:
                  '$interruptionCount · ${analyticsDurationLabel(interruptionDuration)}',
            ),
          ],
        ),
      ),
    ),
  );
}

final class CourseAnalyticsCard extends StatelessWidget {
  const CourseAnalyticsCard({required this.value, super.key});
  final CourseStudyAnalytics value;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const Icon(Icons.school_outlined),
      title: Text(value.courseName),
      subtitle: Text(
        '${analyticsDurationLabel(value.focusedDuration)} · '
        '${value.completedSessions == 1 ? '1 sesión' : '${value.completedSessions} sesiones'}',
      ),
      trailing: Text('${value.interruptionCount} int.'),
    ),
  );
}

final class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.small),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: Theme.of(context).textTheme.labelLarge),
      ],
    ),
  );
}
