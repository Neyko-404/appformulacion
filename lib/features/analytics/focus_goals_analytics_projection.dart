/// Proyección pública mínima que Goals necesita para calcular progreso.
///
/// Los valores ya fueron calculados por Analytics. Esta clase no permite
/// acceder a repositorios ni modificar el estado analítico.
final class FocusGoalsAnalyticsProjection {
  const FocusGoalsAnalyticsProjection({
    required this.focusMinutesToday,
    required this.completedSessionsThisWeek,
    required this.activeDaysThisWeek,
  });

  final int focusMinutesToday;
  final int completedSessionsThisWeek;
  final int activeDaysThisWeek;
}
