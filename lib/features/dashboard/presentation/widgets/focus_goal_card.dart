import 'package:flutter/material.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

class FocusGoalCard extends StatelessWidget {
  const FocusGoalCard({required this.profile, super.key});

  final StudentProfile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.track_changes_outlined),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    'Tu objetivo',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(_goalLabel(profile.primaryGoal)),
            const SizedBox(height: AppSpacing.xSmall),
            Text('Sesiones sugeridas de ${profile.preferredFocusMinutes} min'),
          ],
        ),
      ),
    );
  }

  String _goalLabel(PrimaryGoal goal) => switch (goal) {
    PrimaryGoal.organization => 'Organizar mejor mis estudios',
    PrimaryGoal.concentration => 'Mejorar mi concentración',
    PrimaryGoal.examPreparation => 'Prepararme para evaluaciones',
    PrimaryGoal.routine => 'Construir una rutina de estudio',
    PrimaryGoal.memory => 'Recordar mejor lo aprendido',
  };
}
