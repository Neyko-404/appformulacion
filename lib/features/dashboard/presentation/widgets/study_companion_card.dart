import 'package:flutter/material.dart';
import 'package:focusly/features/companion/companion_customization_public.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/shared/presentation/focus_companion_card.dart';

class StudyCompanionCard extends StatelessWidget {
  const StudyCompanionCard({
    required this.companion,
    required this.message,
    required this.onCustomize,
    this.presentation,
    super.key,
  });

  final StudyCompanion companion;
  final String message;
  final CompanionPresentationModel? presentation;
  final VoidCallback onCustomize;

  @override
  Widget build(BuildContext context) {
    final state = presentation;
    final visual = state == null
        ? null
        : CompanionVisualMapper.map(
            context,
            theme: state.theme,
            avatar: state.avatar,
          );
    return Semantics(
      container: true,
      label: state == null
          ? null
          : 'Estado ${_moodLabel(state.mood)}. '
                'Expresión ${_expressionLabel(state.expression)}.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state == null)
            FocusCompanionCard(
              name: companion.name,
              appearance: companion.appearance,
              message: message,
            )
          else
            Card(
              color: visual!.background,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(visual.icon, size: 52, color: visual.foreground),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.displayName,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: visual.foreground),
                          ),
                          Text(
                            visual.themeLabel,
                            style: TextStyle(color: visual.foreground),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: TextStyle(color: visual.foreground),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (state != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: Icon(_expressionIcon(state.expression), size: 18),
                    label: Text(_expressionLabel(state.expression)),
                  ),
                  Chip(label: Text(_moodLabel(state.mood))),
                  const Chip(
                    avatar: Icon(Icons.animation_outlined, size: 18),
                    label: Text('Animación futura'),
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onCustomize,
              icon: const Icon(Icons.tune),
              label: const Text('Personalizar'),
            ),
          ),
        ],
      ),
    );
  }

  String _moodLabel(CompanionMood mood) => switch (mood) {
    CompanionMood.relaxed => 'Relajado',
    CompanionMood.focused => 'Enfocado',
    CompanionMood.encouraging => 'Acompañando',
    CompanionMood.celebrating => 'Celebrando',
    CompanionMood.resting => 'Descansando',
  };

  String _expressionLabel(CompanionExpression expression) =>
      switch (expression) {
        CompanionExpression.normal => 'Atento',
        CompanionExpression.happy => 'Contento',
        CompanionExpression.thinking => 'Reflexivo',
        CompanionExpression.cheering => 'Animando',
        CompanionExpression.sleeping => 'En reposo',
      };

  IconData _expressionIcon(CompanionExpression expression) =>
      switch (expression) {
        CompanionExpression.normal => Icons.sentiment_satisfied,
        CompanionExpression.happy => Icons.emoji_events_outlined,
        CompanionExpression.thinking => Icons.psychology_outlined,
        CompanionExpression.cheering => Icons.celebration_outlined,
        CompanionExpression.sleeping => Icons.self_improvement_outlined,
      };
}
