import 'package:flutter/material.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/shared/presentation/focus_companion_card.dart';

class StudyCompanionCard extends StatelessWidget {
  const StudyCompanionCard({
    required this.companion,
    required this.message,
    super.key,
  });

  final StudyCompanion companion;
  final String message;

  @override
  Widget build(BuildContext context) {
    return FocusCompanionCard(
      name: companion.name,
      appearance: companion.appearance,
      message: message,
    );
  }
}
