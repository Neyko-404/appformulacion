import 'package:focusly/features/analytics/domain/entities/study_analytics.dart';
import 'package:focusly/features/analytics/domain/entities/study_insight.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';
import 'package:focusly/features/analytics/domain/services/study_insight_rule.dart';

final class StudyInsightEngine {
  const StudyInsightEngine({this.rules = defaultStudyInsightRules});

  final List<StudyInsightRule> rules;

  InsightCollection generate({
    required StudyAnalyticsSummary analyticsSummary,
    required StudyTrendSummary trendSummary,
    required InsightDashboardSummary dashboardSummary,
    required InsightProfileProjection profileProjection,
  }) {
    final candidates =
        rules
            .map(
              (rule) => rule.evaluate(
                analyticsSummary: analyticsSummary,
                trendSummary: trendSummary,
                dashboardSummary: dashboardSummary,
                profileProjection: profileProjection,
              ),
            )
            .nonNulls
            .toList()
          ..sort((a, b) => a.priority.index.compareTo(b.priority.index));
    final ids = <String>{};
    final categories = <InsightCategory>{};
    final selected = <StudyInsight>[];
    for (final value in candidates) {
      if (!ids.add(value.id) || !categories.add(value.category)) continue;
      selected.add(value);
      if (selected.length == 3) break;
    }
    return InsightCollection(List.unmodifiable(selected));
  }
}
