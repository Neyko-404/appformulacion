import 'package:flutter/material.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';

class StudyCompanionCard extends StatelessWidget {
  const StudyCompanionCard({required this.companion, super.key});

  final StudyCompanion companion;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.pets_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companion.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(_appearanceLabel(companion.appearance)),
                  const SizedBox(height: 4),
                  const Text('¿Listo para estudiar hoy?'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _appearanceLabel(CompanionAppearance appearance) =>
      switch (appearance) {
        CompanionAppearance.indigo => 'Apariencia índigo',
        CompanionAppearance.amber => 'Apariencia ámbar',
        CompanionAppearance.emerald => 'Apariencia esmeralda',
      };
}
