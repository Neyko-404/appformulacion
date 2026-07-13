import 'package:flutter/material.dart';
import 'package:focusly/features/analytics/domain/entities/study_analytics.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';
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

final class TrendComparisonCard extends StatelessWidget {
  const TrendComparisonCard._({
    required this.title,
    required this.focusedMinutes,
    required this.completedSessions,
    required this.averageSessionMinutes,
    required this.interruptions,
    required this.activeDays,
    required this.currentDominantCourse,
    required this.previousDominantCourse,
    required this.courseTrends,
  });

  factory TrendComparisonCard.weekly(WeeklyTrend value) =>
      TrendComparisonCard._(
        title: 'Comparación semanal',
        focusedMinutes: value.focusedMinutes,
        completedSessions: value.completedSessions,
        averageSessionMinutes: value.averageSessionMinutes,
        interruptions: value.interruptions,
        activeDays: value.activeDays,
        currentDominantCourse: value.currentDominantCourse,
        previousDominantCourse: value.previousDominantCourse,
        courseTrends: value.courseTrends,
      );

  factory TrendComparisonCard.monthly(MonthlyTrend value) =>
      TrendComparisonCard._(
        title: 'Comparación mensual',
        focusedMinutes: value.focusedMinutes,
        completedSessions: value.completedSessions,
        averageSessionMinutes: value.averageSessionMinutes,
        interruptions: value.interruptions,
        activeDays: value.activeDays,
        currentDominantCourse: value.currentDominantCourse,
        previousDominantCourse: value.previousDominantCourse,
        courseTrends: value.courseTrends,
      );

  final String title;
  final TrendComparison focusedMinutes;
  final TrendComparison completedSessions;
  final TrendComparison averageSessionMinutes;
  final TrendComparison interruptions;
  final TrendComparison activeDays;
  final String? currentDominantCourse;
  final String? previousDominantCourse;
  final List<CourseTrend> courseTrends;

  @override
  Widget build(BuildContext context) {
    final growingCourse = courseTrends
        .where((value) => value.focusedMinutes.signedDifference > 0)
        .firstOrNull;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.medium),
            _TrendMetric(label: 'Tiempo estudiado', value: focusedMinutes),
            _TrendMetric(label: 'Sesiones', value: completedSessions),
            _TrendMetric(
              label: 'Promedio por sesión',
              value: averageSessionMinutes,
            ),
            _TrendMetric(label: 'Interrupciones', value: interruptions),
            _TrendMetric(label: 'Días activos', value: activeDays),
            const SizedBox(height: AppSpacing.small),
            Text(
              'Curso dominante: ${currentDominantCourse ?? 'Sin actividad'} '
              '(antes: ${previousDominantCourse ?? 'sin actividad'})',
            ),
            if (growingCourse != null)
              Text('Mayor crecimiento: ${growingCourse.courseName}'),
          ],
        ),
      ),
    );
  }
}

final class _TrendMetric extends StatelessWidget {
  const _TrendMetric({required this.label, required this.value});
  final String label;
  final TrendComparison value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.small),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(_icon(value.direction), size: 20),
        const SizedBox(width: AppSpacing.small),
        Expanded(child: Text(label)),
        Flexible(
          child: Text(
            '${_number(value.previousValue)} → ${_number(value.currentValue)} '
            '(${_variation(value)})',
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );

  String _number(double value) => value == value.roundToDouble()
      ? value.round().toString()
      : value.toStringAsFixed(1);

  String _variation(TrendComparison value) {
    final percentage = value.percentageVariation;
    if (percentage == null) {
      return value.direction == TrendDirection.stable
          ? 'sin cambio'
          : 'nuevo registro';
    }
    final prefix = percentage > 0 ? '+' : '';
    return '$prefix${percentage.toStringAsFixed(0)} %';
  }

  IconData _icon(TrendDirection direction) => switch (direction) {
    TrendDirection.up => Icons.trending_up,
    TrendDirection.down => Icons.trending_down,
    TrendDirection.stable => Icons.trending_flat,
  };
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
