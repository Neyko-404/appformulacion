import 'package:flutter/material.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';

class FocusGoalCard extends StatelessWidget {
  const FocusGoalCard({required this.profile, super.key});

  final StudentProfile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Objetivo principal',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(_goalLabel(profile.primaryGoal)),
            const SizedBox(height: 4),
            Text('${profile.preferredFocusMinutes} minutos'),
          ],
        ),
      ),
    );
  }

  String _goalLabel(PrimaryGoal goal) => switch (goal) {
    PrimaryGoal.organization => 'Organizar mejor mis estudios',
    PrimaryGoal.concentration => 'Mejorar mi concentración',
    PrimaryGoal.examPreparation => 'Prepararme para evaluaciones',
    PrimaryGoal.routine => 'Crear una rutina',
    PrimaryGoal.memory => 'Recordar mejor lo aprendido',
  };
}
