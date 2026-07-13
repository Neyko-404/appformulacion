import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/repositories/companion_customization_repository.dart';

final class InMemoryCompanionCustomizationRepository
    implements CompanionCustomizationRepository {
  final Map<String, CompanionCustomization> _values = {};

  @override
  Future<CompanionCustomization?> get(String ownerId) async => _values[ownerId];

  @override
  Future<void> save(CompanionCustomization customization) async {
    _values[customization.ownerId] = customization;
  }
}
