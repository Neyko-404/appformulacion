import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/academic_tracker/academic_tracker_providers.dart';
import 'package:focusly/features/academic_tracker/data/repositories/in_memory_course_repository.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/academic_tracker/presentation/pages/course_form_page.dart';
import 'package:focusly/features/academic_tracker/presentation/pages/course_list_page.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';

void main() {
  const session = AuthSession.authenticated(
    user: AuthUser(id: 'user-1', email: 'student@focusly.dev'),
    emailVerified: true,
  );
  final now = DateTime.utc(2026, 7, 12);

  Future<void> pumpPage(
    WidgetTester tester,
    InMemoryCourseRepository repository,
    Widget page,
  ) => tester.pumpWidget(
    ProviderScope(
      overrides: [
        publicAuthSessionProvider.overrideWithValue(session),
        courseRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(home: page),
    ),
  );

  testWidgets('empty list and create form validation are visible', (
    tester,
  ) async {
    final repository = InMemoryCourseRepository();
    addTearDown(repository.dispose);
    await pumpPage(tester, repository, const CourseListPage());
    await tester.pumpAndSettle();
    expect(find.text('Mis cursos'), findsOneWidget);
    expect(
      find.text('Todavía no tienes cursos.\nAgrega uno para comenzar.'),
      findsOneWidget,
    );

    await pumpPage(tester, repository, const CourseFormPage());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Crear curso'));
    await tester.pump();
    expect(find.text('El nombre es obligatorio.'), findsOneWidget);
  });

  testWidgets('list shows active and archived courses', (tester) async {
    Course course(String id, CourseStatus status) => Course(
      id: id,
      ownerId: 'user-1',
      name: status == CourseStatus.active ? 'Matemática' : 'Historia',
      visualIdentity: CourseVisualIdentity.amber,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
    final repository = InMemoryCourseRepository(
      seed: [
        course('active', CourseStatus.active),
        course('old', CourseStatus.archived),
      ],
    );
    addTearDown(repository.dispose);
    await pumpPage(tester, repository, const CourseListPage());
    await tester.pumpAndSettle();
    expect(find.text('Matemática'), findsOneWidget);
    await tester.tap(find.text('Archivados'));
    await tester.pumpAndSettle();
    expect(find.text('Historia'), findsOneWidget);
    expect(find.text('Restaurar'), findsNothing);
  });
}
