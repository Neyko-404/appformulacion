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
    final model = presentation;
    if (model != null) {
      return CompanionPresenceCard(
        model: model,
        action: IconButton(
          onPressed: onCustomize,
          icon: const Icon(Icons.tune),
          tooltip: 'Personalizar',
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FocusCompanionCard(
          name: companion.name,
          appearance: companion.appearance,
          message: message,
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
    );
  }
}
