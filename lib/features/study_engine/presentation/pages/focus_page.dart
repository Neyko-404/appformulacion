import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/router/route_names.dart';
import 'package:focusly/features/academic_tracker/course_public_providers.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/study_engine_providers.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';
import 'package:go_router/go_router.dart';

class FocusPage extends ConsumerStatefulWidget {
  const FocusPage({super.key});
  @override
  ConsumerState<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends ConsumerState<FocusPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(studyEngineNotifierProvider.notifier).reconcile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studyEngineNotifierProvider);
    final notifier = ref.read(studyEngineNotifierProvider.notifier);
    final courses = ref.watch(activeCoursesProvider).courses;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo enfoque'),
        actions: [
          IconButton(
            onPressed: () => context.push(RoutePaths.focusHistory),
            icon: const Icon(Icons.history),
            tooltip: 'Historial',
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
                    constraints: const BoxConstraints(maxWidth: 680),
                    child:
                        state.activeSession == null &&
                            state.lastFinishedSession != null
                        ? _FinishedSessionView(
                            session: state.lastFinishedSession!,
                            courseName: courses
                                .where(
                                  (course) =>
                                      course.id ==
                                      state.lastFinishedSession!.courseId,
                                )
                                .firstOrNull
                                ?.name,
                          )
                        : state.activeSession == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Prepara tu sesión',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: AppSpacing.xLarge),
                              if (state.errorMessage != null) ...[
                                Text(
                                  state.errorMessage!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.medium),
                              ],
                              SegmentedButton<int>(
                                segments: const [
                                  ButtonSegment(
                                    value: 15,
                                    label: Text('15 min'),
                                  ),
                                  ButtonSegment(
                                    value: 25,
                                    label: Text('25 min'),
                                  ),
                                  ButtonSegment(
                                    value: 40,
                                    label: Text('40 min'),
                                  ),
                                  ButtonSegment(
                                    value: 50,
                                    label: Text('50 min'),
                                  ),
                                ],
                                selected: {state.selectedDuration.inMinutes},
                                onSelectionChanged: (values) =>
                                    notifier.selectDuration(
                                      Duration(minutes: values.single),
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.xLarge),
                              DropdownButtonFormField<String?>(
                                initialValue: state.selectedCourseId,
                                decoration: const InputDecoration(
                                  labelText: 'Curso opcional',
                                ),
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Sesión libre'),
                                  ),
                                  ...courses.map(
                                    (course) => DropdownMenuItem<String?>(
                                      value: course.id,
                                      child: Text(course.name),
                                    ),
                                  ),
                                ],
                                onChanged: notifier.selectCourse,
                              ),
                              const SizedBox(height: AppSpacing.medium),
                              const Text(
                                'El tiempo se reconcilia al volver a la aplicación.',
                              ),
                              const SizedBox(height: AppSpacing.xLarge),
                              FilledButton(
                                onPressed: state.isOperating
                                    ? null
                                    : notifier.start,
                                child: const Text('Comenzar sesión'),
                              ),
                            ],
                          )
                        : _ActiveSessionView(
                            session: state.activeSession!,
                            remaining: state.remaining,
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _FinishedSessionView extends ConsumerWidget {
  const _FinishedSessionView({required this.session, this.courseName});

  final StudySession session;
  final String? courseName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = session.status == StudySessionStatus.completed;
    final focused = session.accumulatedFocusDuration;
    final minutes = focused.inMinutes;
    final seconds = focused.inSeconds.remainder(60);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          completed ? Icons.check_circle : Icons.info_outline,
          size: 72,
          color: completed
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(height: AppSpacing.large),
        Text(
          completed ? 'Â¡SesiÃ³n completada!' : 'SesiÃ³n cancelada',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.medium),
        Text(
          completed
              ? 'Tiempo enfocado: $minutes min ${seconds.toString().padLeft(2, '0')} s'
              : 'La sesiÃ³n se cerrÃ³ de forma segura.',
          textAlign: TextAlign.center,
        ),
        if (session.courseId != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(
            'Curso: ${courseName ?? 'Curso asociado'}',
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.xLarge),
        FilledButton(
          onPressed: () => context.go(RoutePaths.dashboard),
          child: const Text('Volver al Dashboard'),
        ),
        const SizedBox(height: AppSpacing.medium),
        OutlinedButton(
          onPressed: ref
              .read(studyEngineNotifierProvider.notifier)
              .clearFinishedResult,
          child: const Text('Iniciar otra sesiÃ³n'),
        ),
      ],
    );
  }
}

class _ActiveSessionView extends ConsumerWidget {
  const _ActiveSessionView({required this.session, required this.remaining});
  final StudySession session;
  final Duration remaining;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(studyEngineNotifierProvider.notifier);
    final total = session.plannedDuration.inSeconds;
    final progress = total == 0 ? 0.0 : 1 - remaining.inSeconds / total;
    final minutes = remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final paused = session.status == StudySessionStatus.paused;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$minutes:$seconds',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: AppSpacing.xLarge),
        LinearProgressIndicator(value: progress.clamp(0, 1)),
        const SizedBox(height: AppSpacing.medium),
        Text(
          session.courseId == null ? 'Sesión libre' : 'Curso seleccionado',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xLarge),
        FilledButton(
          onPressed: paused ? notifier.resume : notifier.pause,
          child: Text(paused ? 'Reanudar' : 'Pausar'),
        ),
        if (paused) ...[
          const SizedBox(height: AppSpacing.medium),
          OutlinedButton(
            onPressed: remaining == Duration.zero ? notifier.complete : null,
            child: const Text('Completar'),
          ),
        ],
        const SizedBox(height: AppSpacing.medium),
        TextButton(
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¿Cancelar esta sesión?'),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(false),
                    child: const Text('Volver'),
                  ),
                  FilledButton(
                    onPressed: () => context.pop(true),
                    child: const Text('Cancelar sesión'),
                  ),
                ],
              ),
            );
            if (confirmed ?? false) await notifier.cancel();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
