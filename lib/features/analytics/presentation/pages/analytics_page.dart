import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/analytics/application/providers/analytics_providers.dart';
import 'package:focusly/features/analytics/presentation/widgets/analytics_widgets.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

final class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analyticsNotifierProvider);
    final notifier = ref.read(analyticsNotifierProvider.notifier);
    final summary = state.summary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progreso de estudio'),
        actions: [
          IconButton(
            onPressed: state.isRefreshing ? null : notifier.refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar resumen',
          ),
        ],
      ),
      body: SafeArea(
        child: state.isLoading && summary == null
            ? const Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Cargando progreso de estudio',
                ),
              )
            : state.errorMessage != null && summary == null
            ? _AnalyticsError(
                message: state.errorMessage!,
                onRetry: notifier.refresh,
              )
            : summary == null || summary.isEmpty
            ? const _EmptyAnalytics()
            : RefreshIndicator(
                onRefresh: notifier.refresh,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.xLarge),
                  children: [
                    AnalyticsPeriodCard(
                      title: 'Hoy',
                      focusedDuration: summary.daily.focusedDuration,
                      completedSessions: summary.daily.completedSessions,
                      interruptionCount: summary.daily.interruptionCount,
                      interruptionDuration: summary.daily.interruptionDuration,
                    ),
                    AnalyticsPeriodCard(
                      title: 'Esta semana',
                      focusedDuration: summary.weekly.focusedDuration,
                      completedSessions: summary.weekly.completedSessions,
                      interruptionCount: summary.weekly.interruptionCount,
                      interruptionDuration: summary.weekly.interruptionDuration,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    TrendComparisonCard.weekly(summary.trends.weekly),
                    AnalyticsPeriodCard(
                      title: 'Este mes',
                      focusedDuration: summary.monthly.focusedDuration,
                      completedSessions: summary.monthly.completedSessions,
                      interruptionCount: summary.monthly.interruptionCount,
                      interruptionDuration:
                          summary.monthly.interruptionDuration,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    TrendComparisonCard.monthly(summary.trends.monthly),
                    if (summary.courses.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.large),
                      Text(
                        'Por curso',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.small),
                      ...summary.courses.map(
                        (value) => CourseAnalyticsCard(value: value),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

final class _EmptyAnalytics extends StatelessWidget {
  const _EmptyAnalytics();
  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(AppSpacing.xLarge),
      child: Text(
        'Todavía no hay suficiente actividad para mostrar un resumen.\n'
        'Completa una sesión y vuelve aquí.',
        textAlign: TextAlign.center,
      ),
    ),
  );
}

final class _AnalyticsError extends StatelessWidget {
  const _AnalyticsError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.large),
        FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
      ],
    ),
  );
}
