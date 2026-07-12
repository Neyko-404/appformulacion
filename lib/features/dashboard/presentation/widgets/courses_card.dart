import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/router/route_names.dart';
import 'package:focusly/features/academic_tracker/course_public_providers.dart';
import 'package:go_router/go_router.dart';

class CoursesCard extends ConsumerWidget {
  const CoursesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(activeCoursesProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Cursos', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (snapshot.isLoading)
              const LinearProgressIndicator()
            else if (snapshot.courses.isEmpty)
              const Text('No hay cursos registrados')
            else ...[
              Text('${snapshot.count} cursos activos'),
              const SizedBox(height: 8),
              for (final course in snapshot.courses.take(3)) Text(course.name),
            ],
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.go(
                snapshot.courses.isEmpty
                    ? RoutePaths.courseNew
                    : RoutePaths.courses,
              ),
              child: Text(
                snapshot.courses.isEmpty ? 'Agregar cursos' : 'Ver todos',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
