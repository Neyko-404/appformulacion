import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/presentation/companion_visual_mapper.dart';

void main() {
  testWidgets('every theme and avatar maps to accessible presentation values', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox();
          },
        ),
      ),
    );
    final themeLabels = <String>{};
    final icons = <IconData>{};
    for (final theme in CompanionTheme.values) {
      for (final avatar in CompanionAppearance.values) {
        final style = CompanionVisualMapper.map(
          context,
          theme: theme,
          avatar: avatar,
        );
        themeLabels.add(style.themeLabel);
        icons.add(style.icon);
        expect(style.background, isNot(style.foreground));
        expect(style.avatarLabel, isNotEmpty);
      }
    }
    expect(themeLabels, hasLength(5));
    expect(icons, hasLength(5));
  });
}
