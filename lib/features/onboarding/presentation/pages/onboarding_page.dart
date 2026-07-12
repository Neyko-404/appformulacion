import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/onboarding/onboarding_providers.dart';
import 'package:focusly/features/onboarding/presentation/notifiers/onboarding_notifier.dart';
import 'package:focusly/features/onboarding/presentation/state/onboarding_state.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final TextEditingController _universityController;
  late final TextEditingController _careerController;
  late final TextEditingController _companionController;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingNotifierProvider).draft;
    _universityController = TextEditingController(text: draft.university);
    _careerController = TextEditingController(text: draft.career);
    _companionController = TextEditingController(text: draft.companionName);
  }

  @override
  void dispose() {
    _universityController.dispose();
    _careerController.dispose();
    _companionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingNotifierProvider);
    final notifier = ref.read(onboardingNotifierProvider.notifier);

    if (state.isInitializing) {
      return const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Configura Focusly')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Semantics(
                        label:
                            'Paso ${state.stepNumber} de ${state.totalSteps}',
                        child: LinearProgressIndicator(
                          value: state.stepNumber / state.totalSteps,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Paso ${state.stepNumber} de ${state.totalSteps}',
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      _buildStep(context, state, notifier),
                      if (state.validationMessage != null ||
                          state.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            state.errorMessage ?? state.validationMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          if (state.step != OnboardingStep.welcome)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: state.isSaving
                                    ? null
                                    : notifier.previous,
                                child: const Text('Anterior'),
                              ),
                            ),
                          if (state.step != OnboardingStep.welcome)
                            const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: state.isSaving
                                  ? null
                                  : state.step == OnboardingStep.summary
                                  ? notifier.complete
                                  : notifier.next,
                              child: state.isSaving
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      state.step == OnboardingStep.summary
                                          ? 'Finalizar'
                                          : 'Continuar',
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    OnboardingState state,
    OnboardingNotifier notifier,
  ) {
    return switch (state.step) {
      OnboardingStep.welcome => _section(
        context,
        title: 'Te damos la bienvenida',
        description:
            'Responderás unas preguntas breves para personalizar tu inicio. '
            'Podrás modificar estos datos más adelante.',
        children: const [Icon(Icons.waving_hand_outlined, size: 64)],
      ),
      OnboardingStep.academic => _section(
        context,
        title: 'Perfil académico',
        description: 'Cuéntanos dónde y qué estás estudiando.',
        children: [
          TextField(
            controller: _universityController,
            decoration: const InputDecoration(labelText: 'Universidad'),
            textInputAction: TextInputAction.next,
            onChanged: notifier.updateUniversity,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _careerController,
            decoration: const InputDecoration(labelText: 'Carrera'),
            textInputAction: TextInputAction.done,
            onChanged: notifier.updateCareer,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: state.draft.currentCycle,
            decoration: const InputDecoration(labelText: 'Ciclo actual'),
            items: [
              for (var cycle = 1; cycle <= 12; cycle++)
                DropdownMenuItem(value: cycle, child: Text('Ciclo $cycle')),
            ],
            onChanged: (value) {
              if (value != null) {
                notifier.updateCycle(value);
              }
            },
          ),
        ],
      ),
      OnboardingStep.goal => _section(
        context,
        title: 'Tu objetivo principal',
        description: 'Elige aquello que más deseas mejorar primero.',
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final goal in PrimaryGoal.values)
                ChoiceChip(
                  label: Text(_goalLabel(goal)),
                  selected: state.draft.primaryGoal == goal,
                  onSelected: (_) => notifier.updateGoal(goal),
                ),
            ],
          ),
        ],
      ),
      OnboardingStep.preferences => _section(
        context,
        title: 'Preferencia de enfoque',
        description:
            'Selecciona una duración inicial. Esto no inicia sesiones.',
        children: [
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 15, label: Text('15 min')),
              ButtonSegment(value: 25, label: Text('25 min')),
              ButtonSegment(value: 40, label: Text('40 min')),
              ButtonSegment(value: 50, label: Text('50 min')),
            ],
            selected: {state.draft.preferredFocusMinutes},
            onSelectionChanged: (values) {
              notifier.updateFocusMinutes(values.single);
            },
          ),
        ],
      ),
      OnboardingStep.companion => _section(
        context,
        title: 'Crea tu compañero',
        description: 'Tu compañero provisional será un gato.',
        children: [
          Icon(
            Icons.pets_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _companionController,
            decoration: const InputDecoration(labelText: 'Nombre del gato'),
            maxLength: 24,
            onChanged: notifier.updateCompanionName,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final appearance in CompanionAppearance.values)
                ChoiceChip(
                  avatar: const Icon(Icons.pets_outlined),
                  label: Text(_appearanceLabel(appearance)),
                  selected: state.draft.appearance == appearance,
                  onSelected: (_) => notifier.updateAppearance(appearance),
                ),
            ],
          ),
        ],
      ),
      OnboardingStep.summary => _section(
        context,
        title: 'Revisa tu configuración',
        description:
            'Puedes volver y corregir cualquier dato antes de guardar.',
        children: [
          _summaryRow('Universidad', state.draft.university),
          _summaryRow('Carrera', state.draft.career),
          _summaryRow('Ciclo', '${state.draft.currentCycle ?? '-'}'),
          _summaryRow(
            'Objetivo',
            state.draft.primaryGoal == null
                ? '-'
                : _goalLabel(state.draft.primaryGoal!),
          ),
          _summaryRow(
            'Enfoque inicial',
            '${state.draft.preferredFocusMinutes} minutos',
          ),
          _summaryRow('Compañero', state.draft.companionName),
          _summaryRow(
            'Apariencia',
            state.draft.appearance == null
                ? '-'
                : _appearanceLabel(state.draft.appearance!),
          ),
        ],
      ),
    };
  }

  Widget _section(
    BuildContext context, {
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(description, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        ...children,
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value),
    );
  }

  String _goalLabel(PrimaryGoal goal) => switch (goal) {
    PrimaryGoal.organization => 'Organizar mejor mis estudios',
    PrimaryGoal.concentration => 'Mejorar mi concentración',
    PrimaryGoal.examPreparation => 'Prepararme para evaluaciones',
    PrimaryGoal.routine => 'Crear una rutina',
    PrimaryGoal.memory => 'Recordar mejor lo aprendido',
  };

  String _appearanceLabel(CompanionAppearance appearance) =>
      switch (appearance) {
        CompanionAppearance.indigo => 'Índigo',
        CompanionAppearance.amber => 'Ámbar',
        CompanionAppearance.emerald => 'Esmeralda',
      };
}
