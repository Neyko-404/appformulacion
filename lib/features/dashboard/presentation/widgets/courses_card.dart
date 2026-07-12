import 'package:flutter/material.dart';

class CoursesCard extends StatelessWidget {
  const CoursesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Cursos', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('No hay cursos registrados'),
            const SizedBox(height: 16),
            const OutlinedButton(
              onPressed: null,
              child: Text('Agregar cursos'),
            ),
          ],
        ),
      ),
    );
  }
}
