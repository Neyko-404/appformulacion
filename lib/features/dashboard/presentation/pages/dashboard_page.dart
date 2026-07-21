import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/router/route_names.dart';
import 'package:focusly/features/academic_tracker/course_public_providers.dart';
import 'package:focusly/features/analytics/analytics_public_providers.dart';
import 'package:focusly/features/analytics/domain/entities/study_insight.dart';
import 'package:focusly/features/analytics/insights_public_widgets.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/companion/companion_customization_public.dart';
import 'package:focusly/features/dashboard/dashboard_providers.dart';
import 'package:focusly/features/dashboard/presentation/models/dashboard_insight.dart';
import 'package:focusly/features/dashboard/presentation/services/dashboard_insight_service.dart';
import 'package:focusly/features/dashboard/presentation/state/dashboard_state.dart';
import 'package:focusly/features/dashboard/presentation/widgets/analytics_summary_card.dart';
import 'package:focusly/features/dashboard/presentation/widgets/courses_card.dart';
import 'package:focusly/features/dashboard/presentation/widgets/dashboard_insight_card.dart';
import 'package:focusly/features/dashboard/presentation/widgets/focus_goal_card.dart';
import 'package:focusly/features/dashboard/presentation/widgets/primary_study_action_card.dart';
import 'package:focusly/features/dashboard/presentation/widgets/study_companion_card.dart';
import 'package:focusly/features/goals/goals_public_providers.dart';
import 'package:focusly/features/study_engine/companion_message_service.dart';
import 'package:focusly/features/study_engine/study_engine_public_providers.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  static const _maxContentWidth = 960.0;

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

final class _DashboardPageState extends ConsumerState<DashboardPage> {
  Future<void>? _refreshOperation;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardNotifierProvider);
    final email = ref.watch(publicAuthSessionProvider).user?.email;
    final study = ref.watch(activeStudySummaryProvider);
    final courses = ref.watch(activeCoursesProvider);
    final analyticsAsync = ref.watch(dashboardTodayAnalyticsProvider);
    final goals = ref.watch(goalsDashboardSummaryProvider);
    final analyticsValue = analyticsAsync.value;
    final analytics = analyticsValue == null
        ? TodayAnalyticsProjection(
            isLoading: analyticsAsync.isLoading,
            hasData: false,
            focusedDuration: Duration.zero,
            completedSessions: 0,
            interruptionCount: 0,
            interruptionDuration: Duration.zero,
            errorMessage: analyticsAsync.hasError
                ? 'No pudimos actualizar el resumen de hoy.'
                : null,
          )
        : TodayAnalyticsProjection(
            isLoading: analyticsAsync.isLoading,
            hasData: true,
            focusedDuration: analyticsValue.focusedDuration,
            completedSessions: analyticsValue.completedSessions,
            interruptionCount: analyticsValue.interruptionCount,
            interruptionDuration: analyticsValue.interruptionDuration,
            mostStudiedCourseName: analyticsValue.mostStudiedCourseName,
            errorMessage: analyticsAsync.hasError
                ? 'No pudimos actualizar el resumen de hoy.'
                : analyticsValue.errorMessage,
            weeklyTrend: analyticsValue.weeklyTrend,
            insights: analyticsValue.insights,
          );
    final companionPresentation = ref.watch(
      companionContextPresentationProvider(
        CompanionExpressionInput(
          isRunning: study.isRunning,
          isPaused: study.isPaused,
          remainingDuration: study.remaining,
          plannedDuration: study.session?.plannedDuration,
          hasWeeklyProgress:
              study.session == null && analytics.completedSessions > 0,
          hasNoActivity:
              study.session == null &&
              analytics.completedSessions == 0 &&
              analytics.focusedDuration == Duration.zero,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Focusly'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar inicio',
          ),
        ],
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.errorMessage != null
            ? _EssentialError(
                message: state.errorMessage!,
                onRetry: ref.read(dashboardNotifierProvider.notifier).load,
              )
            : RefreshIndicator(
                onRefresh: _refresh,
                child: LayoutBuilder(
                  builder: (context, viewport) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.xLarge),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: DashboardPage._maxContentWidth,
                          minHeight: viewport.maxHeight - AppSpacing.xLarge * 2,
                        ),
                        child: _DashboardContent(
                          email: email,
                          state: state,
                          study: study,
                          courses: courses,
                          analytics: analytics,
                          goals: goals,
                          companionPresentation: companionPresentation,
                          analyticsAvailable:
                              analyticsAsync.hasValue &&
                              !analyticsAsync.hasError,
                          onRefreshAnalytics: () {
                            ref.read(analyticsRefreshProvider)();
                          },
                          onRefreshGoals: () {
                            ref.read(goalsRefreshProvider)();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _refresh() {
    final activeOperation = _refreshOperation;
    if (activeOperation != null) return activeOperation;
    final operation = _performRefresh();
    _refreshOperation = operation;
    operation.whenComplete(() {
      if (identical(_refreshOperation, operation)) _refreshOperation = null;
    });
    return operation;
  }

  Future<void> _performRefresh() async {
    final analytics = ref.read(analyticsRefreshProvider)();
    final goals = ref.read(goalsRefreshProvider)();
    await ref.read(dashboardNotifierProvider.notifier).load();
    try {
      await Future.wait([analytics, goals]);
    } on Object {
      // Secondary sections render their own safe, recoverable errors.
    }
  }
}

final class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.email,
    required this.state,
    required this.study,
    required this.courses,
    required this.analytics,
    required this.goals,
    required this.companionPresentation,
    required this.analyticsAvailable,
    required this.onRefreshAnalytics,
    required this.onRefreshGoals,
  });

  final String? email;
  final DashboardState state;
  final ActiveStudySummary study;
  final ActiveCoursesSnapshot courses;
  final TodayAnalyticsProjection analytics;
  final GoalsDashboardSummary goals;
  final CompanionPresentationModel? companionPresentation;
  final bool analyticsAvailable;
  final VoidCallback onRefreshAnalytics;
  final VoidCallback onRefreshGoals;

  @override
  Widget build(BuildContext context) {
    final profile = state.profile!;
    final insight = const DashboardInsightService().select(
      DashboardInsightInput(
        focusedDurationToday: analytics.focusedDuration,
        completedSessionsToday: analytics.completedSessions,
        activeSessionStatus: study.session?.status,
        interruptionCountToday: analytics.interruptionCount,
        preferredFocusMinutes: profile.preferredFocusMinutes,
        primaryGoal: profile.primaryGoal,
        hasCourses: courses.courses.isNotEmpty,
        analyticsAvailable: analyticsAvailable,
        coursesAvailable: !courses.isLoading && courses.errorMessage == null,
      ),
    );
    final courseLabel = study.session?.courseId == null
        ? 'Sesión libre'
        : courses.courses
                  .where((course) => course.id == study.session?.courseId)
                  .firstOrNull
                  ?.name ??
              'Curso no disponible';
    final companionMessage = study.session == null
        ? _companionMessage(insight)
        : const CompanionMessageService().message(
            status: study.session!.status,
            remaining: study.remaining,
            plannedDuration: study.session!.plannedDuration,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(email: email),
        const SizedBox(height: AppSpacing.large),
        PrimaryStudyActionCard(
          study: study,
          preferredMinutes: profile.preferredFocusMinutes,
          courseLabel: courseLabel,
          onOpen: () => context.push(RoutePaths.focus),
        ),
        const SizedBox(height: AppSpacing.large),
        DashboardInsightCard(
          insight: insight,
          onAction: insight.actionType == DashboardInsightAction.none
              ? null
              : () => _openInsight(context, insight.actionType),
        ),
        const SizedBox(height: AppSpacing.large),
        StudyCompanionCard(
          companion: state.companion!,
          message: companionPresentation?.message ?? companionMessage,
          presentation: companionPresentation,
          onCustomize: () => context.push(RoutePaths.companionCustomization),
        ),
        const SizedBox(height: AppSpacing.large),
        AnalyticsSummaryCard(
          analytics: analytics,
          onOpen: () => context.push(RoutePaths.analytics),
          onRetry: onRefreshAnalytics,
        ),
        if (analytics.insights.values.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.large),
          StudyInsightsSection(
            title: 'Recomendaciones',
            collection: analytics.insights,
            maxItems: 2,
            onAction: (action) => _openRecommendation(context, action),
          ),
        ],
        const SizedBox(height: AppSpacing.large),
        FocusGoalCard(
          profile: profile,
          goals: goals,
          onOpen: () => context.push(RoutePaths.goals),
          onRetry: onRefreshGoals,
        ),
        const SizedBox(height: AppSpacing.large),
        const CoursesCard(),
      ],
    );
  }

  String _companionMessage(DashboardInsight insight) =>
      switch (insight.actionType) {
        DashboardInsightAction.openCourses => 'Organicemos tu próximo paso.',
        DashboardInsightAction.openAnalytics => 'Tu avance está aquí.',
        _ => 'Comienza cuando quieras.',
      };

  void _openInsight(BuildContext context, DashboardInsightAction action) {
    final path = switch (action) {
      DashboardInsightAction.startFocus ||
      DashboardInsightAction.continueFocus => RoutePaths.focus,
      DashboardInsightAction.openCourses => RoutePaths.courseNew,
      DashboardInsightAction.openAnalytics => RoutePaths.analytics,
      DashboardInsightAction.none => null,
    };
    if (path != null) context.push(path);
  }

  void _openRecommendation(BuildContext context, InsightAction action) {
    final path = switch (action) {
      InsightAction.continueFocus ||
      InsightAction.startFocus => RoutePaths.focus,
      InsightAction.openCourses => RoutePaths.courses,
      InsightAction.openAnalytics ||
      InsightAction.reviewProgress => RoutePaths.analytics,
      InsightAction.none => null,
    };
    if (path != null) context.push(path);
  }
}

final class _Header extends StatelessWidget {
  const _Header({required this.email});
  final String? email;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_greeting(), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xSmall),
        Text(
          _displayName(email),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.xSmall),
        const Text('¿Qué te gustaría avanzar hoy?'),
      ],
    ),
  );

  String _displayName(String? email) {
    final localPart = email?.split('@').first.trim();
    if (localPart == null || localPart.isEmpty) return 'Estudiante';
    return '${localPart[0].toUpperCase()}${localPart.substring(1)}';
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días 👋';
    if (hour < 19) return 'Buenas tardes 👋';
    return 'Buenas noches 👋';
  }
}

final class _EssentialError extends StatelessWidget {
  const _EssentialError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.large),
          FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    ),
  );
}
