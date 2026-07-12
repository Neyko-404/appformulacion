import 'package:flutter/material.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

class StudyCompanionCard extends StatelessWidget {
  const StudyCompanionCard({required this.companion, super.key});

  final StudyCompanion companion;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Row(
          children: [
            Icon(
              Icons.pets_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.large),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu compañero de estudio',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  Text(
                    companion.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  const Text('Estoy contigo. ¿Comenzamos a estudiar?'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
