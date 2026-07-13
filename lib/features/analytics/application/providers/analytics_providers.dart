import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/academic_tracker/course_analytics_read_api.dart';
import 'package:focusly/features/analytics/application/use_cases/get_analytics_summary.dart';
import 'package:focusly/features/analytics/data/repositories/read_only_analytics_repository.dart';
import 'package:focusly/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:focusly/features/analytics/domain/services/analytics_date_ranges.dart';
import 'package:focusly/features/analytics/presentation/notifiers/analytics_notifier.dart';
import 'package:focusly/features/analytics/presentation/state/analytics_state.dart';
import 'package:focusly/features/study_engine/study_analytics_read_api.dart';

final analyticsClockProvider = Provider<AnalyticsClock>(
  (ref) => const SystemAnalyticsClock(),
);

final analyticsRepositoryProvider = Provider<AnalyticsRepository>(
  (ref) => ReadOnlyAnalyticsRepository(
    studyReader: ref.watch(studyAnalyticsReaderProvider),
    courseReader: ref.watch(courseAnalyticsReaderProvider),
  ),
);

final getAnalyticsSummaryProvider = Provider<GetAnalyticsSummary>(
  (ref) => GetAnalyticsSummary(
    repository: ref.watch(analyticsRepositoryProvider),
    clock: ref.watch(analyticsClockProvider),
  ),
);

final analyticsNotifierProvider =
    NotifierProvider<AnalyticsNotifier, AnalyticsState>(AnalyticsNotifier.new);
