import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/router/route_names.dart';
import 'package:focusly/features/academic_tracker/course_public_providers.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/study_engine/companion_message_service.dart';
import 'package:focusly/features/study_engine/domain/entities/study_interruption.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/presentation/widgets/focus_experience_widgets.dart';
import 'package:focusly/features/study_engine/study_engine_providers.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';
import 'package:focusly/shared/presentation/focus_companion_card.dart';
import 'package:go_router/go_router.dart';

class FocusPage extends ConsumerStatefulWidget {
  const FocusPage({super.key});

  @override
  ConsumerState<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends ConsumerState<FocusPage> {
  bool _isExitDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studyEngineNotifierProvider);
    final notifier = ref.read(studyEngineNotifierProvider.notifier);
    final courses = ref.watch(activeCoursesProvider).courses;
    final active = state.activeSession;
    final selectedCourse = courses
        .where((course) => course.id == state.selectedCourseId)
        .firstOrNull;
    final activeCourse = courses
        .where((course) => course.id == active?.courseId)
        .firstOrNull;
    final companion = state.companion;
    const messageService = CompanionMessageService();

    return PopScope<void>(
      canPop: active == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && active != null) _showExitOptions();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modo enfoque'),
          actions: [
            IconButton(
              onPressed: _showInterruptionPrivacy,
              icon: const Icon(Icons.privacy_tip_outlined),
              tooltip: 'Privacidad de interrupciones',
            ),
            IconButton(
              onPressed: () => context.push(RoutePaths.focusHistory),
              icon: const Icon(Icons.history_outlined),
              tooltip: 'Ver historial de enfoque',
            ),
          ],
        ),
        body: SafeArea(
          child: state.isInitializing
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xLarge),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child:
                          state.activeSession == null &&
                              state.lastFinishedSession != null
                          ? Column(
                              children: [
                                SessionResultCard(
                                  session: state.lastFinishedSession!,
                                  courseLabel:
                                      courses
                                          .where(
                                            (course) =>
                                                course.id ==
                                                state
                                                    .lastFinishedSession!
                                                    .courseId,
                                          )
                                          .firstOrNull
                                          ?.name ??
                                      (state.lastFinishedSession!.courseId ==
                                              null
                                          ? 'Sesión libre'
                                          : 'Curso asociado'),
                                  onHome: () =>
                                      context.go(RoutePaths.dashboard),
                                  onRestart: notifier.clearFinishedResult,
                                ),
                                if (companion != null) ...[
                                  const SizedBox(height: AppSpacing.large),
                                  FocusCompanionCard(
                                    name: companion.name,
                                    appearance: companion.appearance,
                                    message: messageService.message(
                                      status: state.lastFinishedSession!.status,
                                      remaining: Duration.zero,
                                      plannedDuration: state
                                          .lastFinishedSession!
                                          .plannedDuration,
                                    ),
                                  ),
                                ],
                              ],
                            )
                          : active == null
                          ? _PreparationView(
                              selectedDuration: state.selectedDuration,
                              selectedCourseId: state.selectedCourseId,
                              selectedCourseName: selectedCourse?.name,
                              courses: courses
                                  .map(
                                    (course) => _CourseOption(
                                      id: course.id,
                                      name: course.name,
                                    ),
                                  )
                                  .toList(),
                              isOperating: state.isOperating,
                              errorMessage: state.errorMessage,
                              onDurationSelected: notifier.selectDuration,
                              onCourseSelected: notifier.selectCourse,
                              onStart: () async {
                                await HapticFeedback.selectionClick();
                                await notifier.start();
                              },
                              companionName: companion?.name,
                              companionAppearance: companion?.appearance,
                              companionMessage: messageService.message(
                                status: StudySessionStatus.ready,
                                remaining: state.selectedDuration,
                                plannedDuration: state.selectedDuration,
                              ),
                            )
                          : Column(
                              children: [
                                if (state.lastRelevantInterruption != null) ...[
                                  _InterruptionFeedback(
                                    interruption:
                                        state.lastRelevantInterruption!,
                                    isOperating: state.isOperating,
                                    onContinue:
                                        notifier.dismissInterruptionFeedback,
                                    onPause: () async {
                                      notifier.dismissInterruptionFeedback();
                                      await notifier.pause();
                                    },
                                    onCancel: _confirmCancellation,
                                  ),
                                  const SizedBox(height: AppSpacing.large),
                                ],
                                _ActiveSessionView(
                                  session: active,
                                  remaining: state.remaining,
                                  courseLabel:
                                      activeCourse?.name ??
                                      (active.courseId == null
                                          ? 'Sesión libre'
                                          : 'Curso asociado'),
                                  isOperating: state.isOperating,
                                  onPause: () async {
                                    await HapticFeedback.selectionClick();
                                    await notifier.pause();
                                  },
                                  onResume: () async {
                                    await HapticFeedback.selectionClick();
                                    await notifier.resume();
                                  },
                                  onCancel: _confirmCancellation,
                                  companionName: companion?.name,
                                  companionAppearance: companion?.appearance,
                                  companionMessage:
                                      state.lastRelevantInterruption != null
                                      ? messageService
                                            .interruptedReturnMessage()
                                      : messageService.message(
                                          status: active.status,
                                          remaining: state.remaining,
                                          plannedDuration:
                                              active.plannedDuration,
                                        ),
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

  Future<void> _showInterruptionPrivacy() => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Privacidad de interrupciones'),
      content: const Text(
        'Focusly solo registra cuando la aplicación deja de estar visible '
        'durante una sesión activa. No sabe qué aplicación usaste ni solicita '
        'acceso al uso de otras aplicaciones. Los registros se guardan '
        'localmente en tu dispositivo y no se envían a un servidor. El '
        'objetivo es ayudarte a retomar la sesión.',
      ),
      actions: [
        TextButton(
          onPressed: dialogContext.pop,
          child: const Text('Entendido'),
        ),
      ],
    ),
  );

  Future<void> _showExitOptions() async {
    if (_isExitDialogOpen || !mounted) return;
    _isExitDialogOpen = true;
    final action = await showDialog<_ExitAction>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tu sesión sigue activa'),
        content: const Text(
          'Puedes continuar estudiando, volver al inicio sin detener el tiempo '
          'o cancelar la sesión y conservar lo realizado en el historial.',
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(_ExitAction.continueSession),
            child: const Text('Continuar sesión'),
          ),
          TextButton(
            onPressed: () => dialogContext.pop(_ExitAction.keepActive),
            child: const Text('Salir y mantenerla activa'),
          ),
          TextButton(
            onPressed: () => dialogContext.pop(_ExitAction.cancelSession),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Cancelar sesión'),
          ),
        ],
      ),
    );
    _isExitDialogOpen = false;
    if (!mounted) return;
    switch (action) {
      case _ExitAction.keepActive:
        context.go(RoutePaths.dashboard);
      case _ExitAction.cancelSession:
        await _confirmCancellation();
      case _ExitAction.continueSession:
      case null:
        return;
    }
  }

  Future<void> _confirmCancellation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.info_outline),
        title: const Text('Cancelar sesión'),
        content: const Text(
          'La sesión se registrará como cancelada. El tiempo realizado se '
          'conservará en el historial.',
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(false),
            child: const Text('Seguir estudiando'),
          ),
          FilledButton(
            onPressed: () => dialogContext.pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Cancelar sesión'),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && mounted) {
      await ref.read(studyEngineNotifierProvider.notifier).cancel();
    }
  }
}

enum _ExitAction { continueSession, keepActive, cancelSession }

final class _PreparationView extends StatelessWidget {
  const _PreparationView({
    required this.selectedDuration,
    required this.selectedCourseId,
    required this.selectedCourseName,
    required this.courses,
    required this.isOperating,
    required this.errorMessage,
    required this.onDurationSelected,
    required this.onCourseSelected,
    required this.onStart,
    required this.companionName,
    required this.companionAppearance,
    required this.companionMessage,
  });

  final Duration selectedDuration;
  final String? selectedCourseId;
  final String? selectedCourseName;
  final List<_CourseOption> courses;
  final bool isOperating;
  final String? errorMessage;
  final ValueChanged<Duration> onDurationSelected;
  final ValueChanged<String?> onCourseSelected;
  final VoidCallback onStart;
  final String? companionName;
  final CompanionAppearance? companionAppearance;
  final String companionMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Prepara tu sesión',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.small),
        Text(
          'Elige cuánto tiempo quieres dedicar y, si lo deseas, un curso.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.xLarge),
        Text('Duración', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.small),
        Text(
          'Seleccionada: ${focusDurationLabel(selectedDuration)}',
          key: const ValueKey('selected-duration-label'),
        ),
        const SizedBox(height: AppSpacing.medium),
        DurationSelector(
          selected: selectedDuration,
          onSelected: onDurationSelected,
        ),
        const SizedBox(height: AppSpacing.xLarge),
        DropdownButtonFormField<String?>(
          initialValue: selectedCourseId,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Curso opcional',
            prefixIcon: Icon(Icons.menu_book_outlined),
          ),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('Sesión libre'),
            ),
            ...courses.map(
              (course) => DropdownMenuItem<String?>(
                value: course.id,
                child: Text(course.name, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
          onChanged: isOperating ? null : onCourseSelected,
        ),
        if (selectedCourseName != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(
            'Estudiarás: $selectedCourseName',
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (errorMessage != null) ...[
          const SizedBox(height: AppSpacing.medium),
          Text(
            errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: AppSpacing.xLarge),
        FilledButton.icon(
          onPressed: isOperating ? null : onStart,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Comenzar sesión'),
        ),
        if (companionName != null && companionAppearance != null) ...[
          const SizedBox(height: AppSpacing.large),
          FocusCompanionCard(
            name: companionName!,
            appearance: companionAppearance!,
            message: companionMessage,
          ),
        ],
      ],
    );
  }
}

final class _InterruptionFeedback extends StatelessWidget {
  const _InterruptionFeedback({
    required this.interruption,
    required this.isOperating,
    required this.onContinue,
    required this.onPause,
    required this.onCancel,
  });

  final StudyInterruption interruption;
  final bool isOperating;
  final VoidCallback onContinue;
  final VoidCallback onPause;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final durationLabel = _durationLabel(interruption.duration);
    return Semantics(
      container: true,
      label: 'Ya estás de vuelta. Interrupción de $durationLabel.',
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ya estás de vuelta.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xSmall),
              Text('Focusly no estuvo visible durante $durationLabel.'),
              const SizedBox(height: AppSpacing.medium),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: AppSpacing.small,
                children: [
                  TextButton(
                    onPressed: isOperating ? null : onCancel,
                    child: const Text('Cancelar sesión'),
                  ),
                  OutlinedButton(
                    onPressed: isOperating ? null : onPause,
                    child: const Text('Pausar'),
                  ),
                  FilledButton(
                    onPressed: isOperating ? null : onContinue,
                    child: const Text('Continuar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _durationLabel(Duration duration) {
    final seconds = duration.inSeconds;
    if (seconds < 60) return seconds == 1 ? '1 segundo' : '$seconds segundos';
    final minutes = duration.inMinutes;
    final remainingSeconds = seconds.remainder(60);
    final minutesLabel = minutes == 1 ? '1 minuto' : '$minutes minutos';
    if (remainingSeconds == 0) return minutesLabel;
    final secondsLabel = remainingSeconds == 1
        ? '1 segundo'
        : '$remainingSeconds segundos';
    return '$minutesLabel y $secondsLabel';
  }
}

final class _ActiveSessionView extends StatelessWidget {
  const _ActiveSessionView({
    required this.session,
    required this.remaining,
    required this.courseLabel,
    required this.isOperating,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
    required this.companionName,
    required this.companionAppearance,
    required this.companionMessage,
  });

  final StudySession session;
  final Duration remaining;
  final String courseLabel;
  final bool isOperating;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onCancel;
  final String? companionName;
  final CompanionAppearance? companionAppearance;
  final String companionMessage;

  @override
  Widget build(BuildContext context) {
    final paused = session.status == StudySessionStatus.paused;
    return AnimatedSwitcher(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 200),
      child: Column(
        key: ValueKey(session.status),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(child: SessionStatusLabel(paused: paused)),
          const SizedBox(height: AppSpacing.medium),
          Text(
            paused
                ? 'Tómate un momento y continúa cuando estés listo.'
                : 'Concéntrate en una sola cosa.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.large),
          Center(
            child: FocusTimerDisplay(
              remaining: remaining,
              planned: session.plannedDuration,
            ),
          ),
          if (companionName != null && companionAppearance != null) ...[
            const SizedBox(height: AppSpacing.large),
            FocusCompanionCard(
              name: companionName!,
              appearance: companionAppearance!,
              message: companionMessage,
            ),
          ],
          const SizedBox(height: AppSpacing.large),
          Text(
            courseLabel,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            'Duración total: ${focusDurationLabel(session.plannedDuration)}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xLarge),
          FilledButton.icon(
            onPressed: isOperating ? null : (paused ? onResume : onPause),
            icon: Icon(paused ? Icons.play_arrow : Icons.pause),
            label: Text(paused ? 'Continuar' : 'Pausar'),
          ),
          const SizedBox(height: AppSpacing.medium),
          TextButton.icon(
            onPressed: isOperating ? null : onCancel,
            icon: const Icon(Icons.close),
            label: const Text('Cancelar sesión'),
          ),
        ],
      ),
    );
  }
}

final class _CourseOption {
  const _CourseOption({required this.id, required this.name});
  final String id;
  final String name;
}
