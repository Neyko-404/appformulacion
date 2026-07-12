import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/app/app.dart';
import 'package:focusly/app/router/app_router.dart';
import 'package:focusly/app/theme/theme_mode_provider.dart';

void main() {
  testWidgets('FocuslyApp opens the login route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FocuslyApp()));
    await tester.pumpAndSettle();

    expect(find.text('Inicia sesión'), findsOneWidget);
    expect(find.text('Crear una cuenta'), findsOneWidget);
  });

  test('theme mode can change without persistence', () {
    final container = ProviderContainer.test();
    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.system);
    container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
    expect(container.read(themeModeProvider), ThemeMode.dark);
  });

  testWidgets('router exposes public auth routes and unknown fallback', (
    tester,
  ) async {
    final container = ProviderContainer.test();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const FocuslyApp(),
      ),
    );
    await tester.pumpAndSettle();
    final router = container.read(routerProvider);

    expect(find.text('Inicia sesión'), findsOneWidget);

    router.go('/register');
    await tester.pumpAndSettle();
    expect(find.text('Crea tu cuenta'), findsOneWidget);

    router.go('/forgot-password');
    await tester.pumpAndSettle();
    expect(find.text('Recupera tu acceso'), findsOneWidget);

    router.go('/unknown');
    await tester.pumpAndSettle();
    expect(find.text('Ruta no encontrada'), findsOneWidget);
    expect(find.text('/unknown'), findsOneWidget);
  });
}
