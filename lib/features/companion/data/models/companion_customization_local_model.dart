import 'package:isar_community/isar.dart';

part 'companion_customization_local_model.g.dart';

@collection
class CompanionCustomizationLocalModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String ownerId;

  late String displayName;
  late String selectedTheme;
  late String selectedAvatar;
  late String preferredExpressionStyle;
}
