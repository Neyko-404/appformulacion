import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/authentication/data/repositories/in_memory_auth_repository.dart';
import 'package:focusly/features/authentication/presentation/providers/auth_providers.dart';
import 'package:focusly/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:focusly/features/onboarding/onboarding_providers.dart';
import 'package:focusly/features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  Future<void> pumpOnboarding(WidgetTester tester) async {
    final authRepository = InMemoryAuthRepository(
      seedAccounts: const {'student@focusly.dev': 'password123'},
    );
    await authRepository.signIn(
      email: 'student@focusly.dev',
      password: 'password123',
    );
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          onboardingRepositoryProvider.overrideWithValue(
            InMemoryOnboardingRepository(),
          ),
        ],
        child: const MaterialApp(home: OnboardingPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows welcome and progress', (tester) async {
    await pumpOnboarding(tester);

    expect(find.text('Te damos la bienvenida'), findsOneWidget);
    expect(find.text('Paso 1 de 6'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('requires academic data before advancing', (tester) async {
    await pumpOnboarding(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 2 de 6'), findsOneWidget);
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Continuar'));
    await tester.tap(find.widgetWithText(FilledButton, 'Continuar'));
    await tester.pumpAndSettle();

    expect(find.textContaining('obligatori'), findsOneWidget);
    expect(find.text('Paso 2 de 6'), findsOneWidget);
  });

  testWidgets('supports every step, review, and back navigation', (
    tester,
  ) async {
    await pumpOnboarding(tester);

    Future<void> continueFlow() async {
      final button = find.widgetWithText(FilledButton, 'Continuar');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
    }

    await continueFlow();
    expect(find.text('Perfil académico'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, 'Carrera'),
      'Ingeniería',
    );
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ciclo 4').last);
    await tester.pumpAndSettle();
    await continueFlow();

    expect(find.text('Tu objetivo principal'), findsOneWidget);
    await tester.tap(find.text('Mejorar mi concentración'));
    await continueFlow();

    expect(find.text('Preferencia de enfoque'), findsOneWidget);
    await tester.tap(find.text('40 min'));
    await continueFlow();

    expect(find.text('Crea tu compañero'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del gato'),
      'Milo',
    );
    await tester.tap(find.text('Esmeralda'));
    await continueFlow();

    expect(find.text('Revisa tu configuración'), findsOneWidget);
    expect(find.text('Milo'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Finalizar'), findsOneWidget);
    await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Anterior'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'Anterior'));
    await tester.pumpAndSettle();
    expect(find.text('Crea tu compañero'), findsOneWidget);
  });
}
