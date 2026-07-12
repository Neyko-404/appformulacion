import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/app/app.dart';
import 'package:focusly/features/authentication/domain/entities/auth_failure.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/authentication/domain/repositories/auth_repository.dart';
import 'package:focusly/features/authentication/presentation/providers/auth_providers.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester, AuthRepository repository) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const FocuslyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('login renders fields and public actions', (tester) async {
    await pumpApp(tester, _TestAuthRepository());

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Crear una cuenta'), findsOneWidget);
    expect(find.text('Olvidé mi contraseña'), findsOneWidget);
  });

  testWidgets('login validation prevents an invalid submission', (
    tester,
  ) async {
    final repository = _TestAuthRepository();
    await pumpApp(tester, repository);

    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pump();

    expect(find.text('El correo es obligatorio.'), findsOneWidget);
    expect(find.text('La contraseña es obligatoria.'), findsOneWidget);
    expect(repository.signInCalls, 0);
  });

  testWidgets('login navigates to registration', (tester) async {
    await pumpApp(tester, _TestAuthRepository());

    await tester.tap(find.text('Crear una cuenta'));
    await tester.pumpAndSettle();

    expect(find.text('Crea tu cuenta'), findsOneWidget);
  });

  testWidgets('login navigates to password recovery', (tester) async {
    await pumpApp(tester, _TestAuthRepository());

    await tester.tap(find.text('Olvidé mi contraseña'));
    await tester.pumpAndSettle();

    expect(find.text('Recupera tu acceso'), findsOneWidget);
  });

  testWidgets('registration validates password confirmation', (tester) async {
    await pumpApp(tester, _TestAuthRepository());
    await tester.tap(find.text('Crear una cuenta'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'student@focusly.dev');
    await tester.enterText(fields.at(1), 'password123');
    await tester.enterText(fields.at(2), 'different-password');
    await tester.tap(find.byType(Checkbox));
    await tester.tap(find.widgetWithText(FilledButton, 'Crear cuenta'));
    await tester.pump();

    expect(find.text('Las contraseñas no coinciden.'), findsOneWidget);
  });

  testWidgets('loading disables the login submit button', (tester) async {
    final repository = _PendingAuthRepository();
    await pumpApp(tester, repository);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'student@focusly.dev');
    await tester.enterText(fields.at(1), 'password123');
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pump();

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);

    repository.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('recovery shows the same safe confirmation', (tester) async {
    await pumpApp(tester, _TestAuthRepository());
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

  testWidgets('password reset confirmation is cleared on return to login', (
    tester,
  ) async {
    await pumpApp(tester, _TestAuthRepository());
    await tester.tap(find.text('Olvidé mi contraseña'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'unknown@focusly.dev');
    await tester.tap(find.widgetWithText(FilledButton, 'Enviar instrucciones'));
    await tester.pumpAndSettle();
    expect(
      find.text('Si el correo está registrado, recibirás instrucciones.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Volver a iniciar sesión'));
    await tester.pumpAndSettle();

    expect(
      find.text('Si el correo está registrado, recibirás instrucciones.'),
      findsNothing,
    );
  });

  testWidgets('authentication error is cleared when opening registration', (
    tester,
  ) async {
    await pumpApp(tester, _TestAuthRepository());
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'error@focusly.dev');
    await tester.enterText(fields.at(1), 'password123');
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pumpAndSettle();
    expect(
      find.text('No pudimos iniciar sesión con esos datos.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Crear una cuenta'));
    await tester.pumpAndSettle();

    expect(find.text('Crea tu cuenta'), findsOneWidget);
    expect(
      find.text('No pudimos iniciar sesión con esos datos.'),
      findsNothing,
    );
  });
}

class _TestAuthRepository implements AuthRepository {
  int signInCalls = 0;

  @override
  Future<AuthUser?> getCurrentUser() async => null;

  @override
  Stream<AuthUser?> watchAuthState() => const Stream.empty();

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    if (email == 'error@focusly.dev') {
      throw AuthFailure.invalidCredentials();
    }
    return AuthUser(id: 'test-user', email: email);
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async => AuthUser(id: 'test-user', email: email);

  @override
  Future<void> requestPasswordReset({required String email}) async {}

  @override
  Future<void> signOut() async {}
}

class _PendingAuthRepository extends _TestAuthRepository {
  final _completer = Completer<AuthUser>();

  void complete() {
    _completer.complete(
      const AuthUser(id: 'test-user', email: 'student@focusly.dev'),
    );
  }

  @override
  Future<AuthUser> signIn({required String email, required String password}) {
    signInCalls++;
    return _completer.future;
  }
}
