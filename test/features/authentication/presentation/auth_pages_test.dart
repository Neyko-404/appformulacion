import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/app/app.dart';
import 'package:focusly/features/authentication/data/repositories/in_memory_auth_repository.dart';
import 'package:focusly/features/authentication/presentation/providers/auth_providers.dart';

void main() {
  Future<void> pumpApp(
    WidgetTester tester,
    InMemoryAuthRepository repository,
  ) async {
    addTearDown(repository.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const FocuslyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('login is connected to auth state and validates input', (
    tester,
  ) async {
    await pumpApp(tester, InMemoryAuthRepository());

    expect(find.text('Inicia sesión'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pump();
    expect(find.text('El correo es obligatorio.'), findsOneWidget);
    expect(find.text('La contraseña es obligatoria.'), findsOneWidget);
  });

  testWidgets('registration shows a safe repository error', (tester) async {
    await pumpApp(
      tester,
      InMemoryAuthRepository(
        seedAccounts: const {'existing@focusly.dev': 'password123'},
      ),
    );
    await tester.tap(find.text('Crear una cuenta'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'existing@focusly.dev');
    await tester.enterText(fields.at(1), 'password123');
    await tester.enterText(fields.at(2), 'password123');
    await tester.tap(find.byType(Checkbox));
    await tester.tap(find.widgetWithText(FilledButton, 'Crear cuenta'));
    await tester.pumpAndSettle();

    expect(
      find.text('No pudimos crear la cuenta con ese correo.'),
      findsOneWidget,
    );
  });

  testWidgets('recovery shows a non-revealing confirmation', (tester) async {
    await pumpApp(tester, InMemoryAuthRepository());
    await tester.tap(find.text('Olvidé mi contraseña'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'unknown@focusly.dev');
    await tester.tap(find.widgetWithText(FilledButton, 'Enviar instrucciones'));
    await tester.pumpAndSettle();

    expect(
      find.text('Si el correo está registrado, recibirás instrucciones.'),
      findsOneWidget,
    );
  });

  testWidgets('verify email renders actions and reaches authenticated route', (
    tester,
  ) async {
    final repository = InMemoryAuthRepository();
    await repository.signUp(
      email: 'student@focusly.dev',
      password: 'password123',
    );
    await pumpApp(tester, repository);

    expect(find.text('Verifica tu correo'), findsOneWidget);
    expect(find.text('Reenviar verificación'), findsOneWidget);
    expect(find.text('Ya verifiqué'), findsOneWidget);

    repository.markCurrentEmailVerified();
    await tester.tap(find.widgetWithText(FilledButton, 'Ya verifiqué'));
    await tester.pumpAndSettle();

    expect(
      find.text('Autenticación completada. Onboarding pendiente.'),
      findsOneWidget,
    );
  });

  testWidgets('authenticated provisional page logs out to login', (
    tester,
  ) async {
    final repository = InMemoryAuthRepository(
      seedAccounts: const {'student@focusly.dev': 'password123'},
    );
    await repository.signIn(
      email: 'student@focusly.dev',
      password: 'password123',
    );
    await pumpApp(tester, repository);

    expect(
      find.text('Autenticación completada. Onboarding pendiente.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('Inicia sesión'), findsOneWidget);
  });
}
