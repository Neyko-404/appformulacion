import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/app/app.dart';
import 'package:focusly/app/router/app_router.dart';
import 'package:focusly/app/theme/theme_mode_provider.dart';

void main() {
  testWidgets('FocuslyApp renders the technical foundation', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FocuslyApp()));
    await tester.pumpAndSettle();

    expect(find.text('Focusly'), findsWidgets);
    expect(find.text('La fundación técnica está activa.'), findsOneWidget);
  });

  test('theme mode can change without persistence', () {
    final container = ProviderContainer.test();
    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.system);

    container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);

    expect(container.read(themeModeProvider), ThemeMode.dark);
  });

  testWidgets('router opens the initial route and handles an unknown route', (
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

    expect(find.text('La fundación técnica está activa.'), findsOneWidget);

    container.read(routerProvider).go('/unknown');
    await tester.pumpAndSettle();

    expect(find.text('Ruta no encontrada'), findsOneWidget);
    expect(find.text('/unknown'), findsOneWidget);
  });
}
