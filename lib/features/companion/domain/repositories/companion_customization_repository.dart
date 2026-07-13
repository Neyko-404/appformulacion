import 'package:focusly/features/companion/domain/entities/companion_customization.dart';

abstract interface class CompanionCustomizationRepository {
  Future<CompanionCustomization?> get(String ownerId);

  Future<void> save(CompanionCustomization customization);
}
