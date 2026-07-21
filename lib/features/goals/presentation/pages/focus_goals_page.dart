import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/goals/application/goals_providers.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/presentation/widgets/goal_editor.dart';
import 'package:focusly/features/goals/presentation/widgets/goal_progress_card.dart';
import 'package:focusly/features/goals/presentation/widgets/goals_section_error.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

class FocusGoalsPage extends ConsumerStatefulWidget {
  const FocusGoalsPage({super.key});

  @override
  ConsumerState<FocusGoalsPage> createState() => _FocusGoalsPageState();
}

final class _FocusGoalsPageState extends ConsumerState<FocusGoalsPage> {
  final _formKey = GlobalKey<FormState>();
  final _dailyController = TextEditingController(text: '25');
  final _sessionsController = TextEditingController(text: '3');
  final _daysController = TextEditingController(text: '3');
  bool _dailyEnabled = false;
  bool _sessionsEnabled = false;
  bool _daysEnabled = false;
  DateTime? _syncedAt;

  @override
  void dispose() {
    _dailyController.dispose();
    _sessionsController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(focusGoalsNotifierProvider);
    final goal = state.goal;
    if (goal != null && goal.updatedAt != _syncedAt) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _sync(goal));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Metas de estudio')),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xLarge),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Define metas flexibles para orientar tu estudio.',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.small),
                          const Text(
                            'Puedes ajustar tus metas cuando quieras. Las sugerencias no se activan hasta que guardes.',
                          ),
                          if (state.errorMessage != null) ...[
                            const SizedBox(height: AppSpacing.large),
                            GoalsSectionError(
                              message: state.errorMessage!,
                              onRetry: ref
                                  .read(focusGoalsNotifierProvider.notifier)
                                  .refresh,
                            ),
                          ],
                          const SizedBox(height: AppSpacing.large),
                          GoalEditor(
                            title: 'Meta diaria',
                            description: 'Minutos de estudio al día',
                            enabled: _dailyEnabled,
                            controller: _dailyController,
                            minimum: 5,
                            maximum: 480,
                            unit: 'minutos',
                            onEnabledChanged: (value) =>
                                setState(() => _dailyEnabled = value),
                          ),
                          GoalEditor(
                            title: 'Sesiones esta semana',
                            description: 'Sesiones completadas por semana',
                            enabled: _sessionsEnabled,
                            controller: _sessionsController,
                            minimum: 1,
                            maximum: 35,
                            unit: 'sesiones',
                            onEnabledChanged: (value) =>
                                setState(() => _sessionsEnabled = value),
                          ),
                          GoalEditor(
                            title: 'Días activos',
                            description:
                                'Días con actividad de estudio por semana',
                            enabled: _daysEnabled,
                            controller: _daysController,
                            minimum: 1,
                            maximum: 7,
                            unit: 'días',
                            onEnabledChanged: (value) =>
                                setState(() => _daysEnabled = value),
                          ),
                          if (state.progress case final progress?) ...[
                            const SizedBox(height: AppSpacing.large),
                            Text(
                              'Tu progreso',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            GoalProgressCard(
                              title: 'Meta diaria',
                              progress: progress.dailyMinutes,
                              unit: 'min',
                            ),
                            GoalProgressCard(
                              title: 'Sesiones esta semana',
                              progress: progress.weeklySessions,
                              unit: 'sesiones',
                            ),
                            GoalProgressCard(
                              title: 'Días activos',
                              progress: progress.weeklyActiveDays,
                              unit: 'días',
                            ),
                          ],
                          if (state.successMessage != null) ...[
                            const SizedBox(height: AppSpacing.medium),
                            Semantics(
                              liveRegion: true,
                              child: Text(state.successMessage!),
                            ),
                          ],
                          const SizedBox(height: AppSpacing.xLarge),
                          FilledButton(
                            onPressed: state.isSaving ? null : _save,
                            child: state.isSaving
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Guardar'),
                          ),
                          TextButton(
                            onPressed: state.isSaving
                                ? null
                                : () => Navigator.of(context).maybePop(),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void _sync(FocusGoal goal) {
    if (!mounted || goal.updatedAt == _syncedAt) return;
    setState(() {
      _syncedAt = goal.updatedAt;
      _dailyEnabled = goal.dailyMinutesTarget != null;
      _sessionsEnabled = goal.weeklyCompletedSessionsTarget != null;
      _daysEnabled = goal.weeklyActiveDaysTarget != null;
      _dailyController.text = '${goal.dailyMinutesTarget ?? 25}';
      _sessionsController.text = '${goal.weeklyCompletedSessionsTarget ?? 3}';
      _daysController.text = '${goal.weeklyActiveDaysTarget ?? 3}';
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(focusGoalsNotifierProvider.notifier)
        .save(
          dailyMinutesTarget: _dailyEnabled
              ? int.parse(_dailyController.text.trim())
              : null,
          weeklyCompletedSessionsTarget: _sessionsEnabled
              ? int.parse(_sessionsController.text.trim())
              : null,
          weeklyActiveDaysTarget: _daysEnabled
              ? int.parse(_daysController.text.trim())
              : null,
        );
  }
}
