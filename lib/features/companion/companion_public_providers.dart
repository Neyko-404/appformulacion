import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/analytics/analytics_public_providers.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart';
import 'package:focusly/features/companion/domain/services/companion_state_engine.dart';

final companionSnapshotProvider = Provider<CompanionSnapshot?>((ref) {
  final analytics = ref.watch(companionAnalyticsProvider);
  if (analytics == null) return null;
  return const CompanionStateEngine().derive(
    analyticsSummary: CompanionAnalyticsSummary(
      focusMinutesToday: analytics.focusMinutesToday,
      completedSessionsToday: analytics.completedSessionsToday,
      interruptionCountToday: analytics.interruptionCountToday,
      activeDaysThisWeek: analytics.activeDaysThisWeek,
    ),
    trendSummary: analytics.weeklyTrend,
    studyInsights: ref.watch(analyticsInsightsProvider),
  );
});
