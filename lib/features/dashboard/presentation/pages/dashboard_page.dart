import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/router/route_names.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/dashboard/dashboard_providers.dart';
import 'package:focusly/features/dashboard/presentation/widgets/courses_card.dart';
import 'package:focusly/features/dashboard/presentation/widgets/focus_goal_card.dart';
import 'package:focusly/features/dashboard/presentation/widgets/focus_streak_card.dart';
import 'package:focusly/features/dashboard/presentation/widgets/study_companion_card.dart';
import 'package:focusly/features/study_engine/companion_message_service.dart';
import 'package:focusly/features/study_engine/study_engine_public_providers.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  static const _maxContentWidth = 960.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardNotifierProvider);
    final email = ref.watch(publicAuthSessionProvider).user?.email;
    final study = ref.watch(activeStudySummaryProvider);
    final companionMessage = study.session == null
        ? '¿Listo para estudiar?'
        : const CompanionMessageService().message(
            status: study.session!.status,
            remaining: study.remaining,
            plannedDuration: study.session!.plannedDuration,
          );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Focusly'),
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.errorMessage != null
            ? _ErrorView(
                message: state.errorMessage!,
                onRetry: ref.read(dashboardNotifierProvider.notifier).load,
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xLarge),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _maxContentWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Semantics(
                          header: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_greeting()} 👋',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: AppSpacing.xSmall),
                              Text(
                                _displayName(email),
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.large),
                        StudyCompanionCard(
                          companion: state.companion!,
                          message: companionMessage,
                        ),
                        const SizedBox(height: AppSpacing.large),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final cards = [
                              FocusGoalCard(profile: state.profile!),
                              const FocusStreakCard(),
                            ];
                            if (constraints.maxWidth < 640) {
                              return Column(
                                children: [
                                  cards.first,
                                  const SizedBox(height: AppSpacing.large),
                                  cards.last,
                                ],
                              );
                            }
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: cards.first),
                                const SizedBox(width: AppSpacing.large),
                                Expanded(child: cards.last),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.large),
                        const CoursesCard(),
                        const SizedBox(height: AppSpacing.large),
                        FilledButton.icon(
                          onPressed: () =>
                              GoRouter.maybeOf(context)?.push(RoutePaths.focus),
                          icon: const Icon(Icons.play_arrow),
                          label: Text(
                            study.session == null
                                ? 'Comenzar sesión'
                                : 'Continuar sesión · ${study.isPaused ? 'En pausa' : _remaining(study.remaining)}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  String _displayName(String? email) {
    final localPart = email?.split('@').first.trim();
    if (localPart == null || localPart.isEmpty) return 'estudiante';
    return '${localPart[0].toUpperCase()}${localPart.substring(1)}';
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String _remaining(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
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
}
