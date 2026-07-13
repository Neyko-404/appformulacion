import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/router/route_names.dart';
import 'package:focusly/features/academic_tracker/course_public_providers.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';
import 'package:go_router/go_router.dart';

class CoursesCard extends ConsumerWidget {
  const CoursesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(activeCoursesProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.menu_book_outlined),
                const SizedBox(width: AppSpacing.small),
                Text('Cursos', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.small),
            if (snapshot.isLoading)
              const LinearProgressIndicator(semanticsLabel: 'Cargando cursos')
            else if (snapshot.errorMessage != null) ...[
              const Text('No pudimos actualizar tus cursos.'),
              const SizedBox(height: AppSpacing.small),
              OutlinedButton(
                onPressed: () => context.push(RoutePaths.courses),
                child: const Text('Abrir cursos'),
              ),
            ] else if (snapshot.courses.isEmpty)
              const Text('Todavía no tienes cursos.\nAgrega uno para comenzar.')
            else ...[
              Text(_activeCoursesLabel(snapshot.count)),
              const SizedBox(height: AppSpacing.small),
              for (final course in snapshot.courses.take(3)) Text(course.name),
            ],
            const SizedBox(height: AppSpacing.large),
            OutlinedButton(
              onPressed: () => context.push(
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

  String _activeCoursesLabel(int count) =>
      count == 1 ? '1 curso activo' : '$count cursos activos';
}
