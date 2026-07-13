import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/companion/companion_customization_public.dart';
import 'package:focusly/features/companion/data/repositories/in_memory_companion_customization_repository.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/presentation/pages/companion_customization_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  Future<InMemoryCompanionCustomizationRepository> pumpPage(
    WidgetTester tester, {
    ThemeData? theme,
    double textScale = 1,
  }) async {
    final repository = InMemoryCompanionCustomizationRepository();
    await repository.save(
      CompanionCustomization.defaults(ownerId: 'user-1', displayName: 'Kumo'),
    );
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const SizedBox()),
        GoRoute(
          path: '/customize',
          builder: (_, _) => MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
            child: const CompanionCustomizationPage(),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          publicAuthSessionProvider.overrideWithValue(
            const AuthSession.authenticated(
              user: AuthUser(id: 'user-1', email: 'user@focusly.dev'),
              emailVerified: true,
            ),
          ),
          companionCustomizationRepositoryProvider.overrideWithValue(
            repository,
          ),
        ],
        child: MaterialApp.router(theme: theme, routerConfig: router),
      ),
    );
    router.push('/customize');
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('preview updates immediately but persistence waits for save', (
    tester,
  ) async {
    final repository = await pumpPage(tester);
    await tester.enterText(find.byType(TextField), '  Nova  ');
    await tester.pump();
    expect(find.text('Nova'), findsOneWidget);
    expect((await repository.get('user-1'))?.identity.displayName, 'Kumo');

    await tester.tap(find.text('Océano'));
    await tester.tap(find.text('Naturaleza'));
    await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
    await tester.pumpAndSettle();
    final saved = await repository.get('user-1');
    expect(saved?.identity.displayName, 'Nova');
    expect(saved?.identity.selectedTheme, CompanionTheme.ocean);
    expect(saved?.identity.selectedAvatar, CompanionAppearance.nature);
  });

  testWidgets('invalid blank name keeps previous value and exposes error', (
    tester,
  ) async {
    final repository = await pumpPage(tester);
    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
    await tester.pump();
    expect(
      find.text('Ingresa un nombre de 1 a 20 caracteres.'),
      findsOneWidget,
    );
    expect(find.byType(CompanionCustomizationPage), findsOneWidget);
    expect((await repository.get('user-1'))?.identity.displayName, 'Kumo');
  });

  testWidgets('supports dark narrow layout and 200 percent text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpPage(tester, theme: ThemeData.dark(), textScale: 2);
    expect(tester.takeException(), isNull);
    expect(
      find.bySemanticsLabel(RegExp('Vista previa de Kumo')),
      findsOneWidget,
    );
    expect(find.text('Personalizar compañero'), findsOneWidget);
  });
}
