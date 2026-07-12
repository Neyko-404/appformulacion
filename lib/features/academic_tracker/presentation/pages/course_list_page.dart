import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/router/route_names.dart';
import 'package:focusly/features/academic_tracker/academic_tracker_providers.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/academic_tracker/presentation/state/course_state.dart';
import 'package:focusly/features/academic_tracker/presentation/widgets/course_visuals.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';
import 'package:go_router/go_router.dart';

class CourseListPage extends ConsumerWidget {
  const CourseListPage({super.key});
  static const _maxWidth = 760.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(courseNotifierProvider);
    final notifier = ref.read(courseNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Mis cursos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RoutePaths.courseNew),
        icon: const Icon(Icons.add),
        label: const Text('Crear curso'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xLarge),
              child: state.isInitializing
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        SegmentedButton<CourseFilter>(
                          segments: const [
                            ButtonSegment(
                              value: CourseFilter.active,
                              label: Text('Activos'),
                            ),
                            ButtonSegment(
                              value: CourseFilter.archived,
                              label: Text('Archivados'),
                            ),
                          ],
                          selected: {state.filter},
                          onSelectionChanged: (values) =>
                              notifier.setFilter(values.single),
                        ),
                        const SizedBox(height: AppSpacing.xLarge),
                        Expanded(
                          child: state.visibleCourses.isEmpty
                              ? Center(
                                  child: Text(
                                    state.filter == CourseFilter.active
                                        ? 'Todavía no tienes cursos.\nAgrega uno para comenzar.'
                                        : 'Todavía no tienes cursos archivados.',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: state.visibleCourses.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: AppSpacing.small),
                                  itemBuilder: (context, index) => _CourseTile(
                                    course: state.visibleCourses[index],
                                  ),
                                ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseTile extends ConsumerWidget {
  const _CourseTile({required this.course});
  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(courseNotifierProvider.notifier);
    final archived = course.status == CourseStatus.archived;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: courseVisualColor(context, course.visualIdentity),
          child: const Icon(Icons.menu_book_outlined),
        ),
        title: Text(course.name),
        subtitle: Text(
          [
            if (course.code != null) course.code!,
            if (course.credits != null) _creditsLabel(course.credits!),
            archived ? 'Archivado' : 'Activo',
          ].join(' · '),
        ),
        onTap: archived
            ? null
            : () => context.push(RoutePaths.courseEdit(course.id)),
        trailing: PopupMenuButton<String>(
          tooltip: 'Acciones del curso',
          onSelected: (action) async {
            switch (action) {
              case 'edit':
                context.push(RoutePaths.courseEdit(course.id));
                break;
              case 'archive':
                if (await _confirm(context, '¿Archivar este curso?')) {
                  await notifier.archive(course.id);
                }
                break;
              case 'restore':
                await notifier.restore(course.id);
                break;
              case 'delete':
                if (await _confirm(
                  context,
                  '¿Eliminar definitivamente este curso?',
                )) {
                  await notifier.delete(course.id);
                }
                break;
            }
          },
          itemBuilder: (_) => [
            if (!archived)
              const PopupMenuItem(value: 'edit', child: Text('Editar')),
            if (!archived)
              const PopupMenuItem(value: 'archive', child: Text('Archivar')),
            if (archived)
              const PopupMenuItem(value: 'restore', child: Text('Restaurar')),
            if (archived)
              const PopupMenuItem(
                value: 'delete',
                child: Text('Eliminar definitivamente'),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirm(BuildContext context, String message) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => context.pop(true),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ) ??
      false;

  String _creditsLabel(int credits) =>
      credits == 1 ? '1 crédito' : '$credits créditos';
}
