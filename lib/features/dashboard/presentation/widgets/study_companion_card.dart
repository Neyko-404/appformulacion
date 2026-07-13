import 'package:flutter/material.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart'
    hide StudyCompanion;
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/shared/presentation/focus_companion_card.dart';

class StudyCompanionCard extends StatelessWidget {
  const StudyCompanionCard({
    required this.companion,
    required this.message,
    this.snapshot,
    super.key,
  });

  final StudyCompanion companion;
  final String message;
  final CompanionSnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    final state = snapshot;
    return Semantics(
      container: true,
      label: state == null
          ? null
          : 'Estado ${_moodLabel(state.mood)}. '
                'Expresión ${_expressionLabel(state.expression)}.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FocusCompanionCard(
            name: companion.name,
            appearance: companion.appearance,
            message: message,
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
