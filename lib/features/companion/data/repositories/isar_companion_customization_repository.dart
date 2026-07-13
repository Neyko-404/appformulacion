import 'package:focusly/core/logging/app_logger.dart';
import 'package:focusly/features/companion/data/mappers/companion_customization_local_mapper.dart';
import 'package:focusly/features/companion/data/models/companion_customization_local_model.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization_failure.dart';
import 'package:focusly/features/companion/domain/repositories/companion_customization_repository.dart';
import 'package:isar_community/isar.dart';

final class IsarCompanionCustomizationRepository
    implements CompanionCustomizationRepository {
  const IsarCompanionCustomizationRepository(
    this._isar, {
    this.mapper = const CompanionCustomizationLocalMapper(),
    this.logger = const AppLogger(),
  });

  final Isar _isar;
  final CompanionCustomizationLocalMapper mapper;
  final AppLogger logger;

  @override
  Future<CompanionCustomization?> get(String ownerId) async {
    if (ownerId.trim().isEmpty) {
      throw CompanionCustomizationFailure.invalidData();
    }
    try {
      final model = await _isar.companionCustomizationLocalModels
          .where()
          .ownerIdEqualTo(ownerId)
          .findFirst();
      return model == null ? null : mapper.toDomain(model);
    } on CompanionCustomizationFailure catch (error, stackTrace) {
      logger.error(
        'Invalid companion customization data',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    } on Object catch (error, stackTrace) {
      logger.error(
        'Failed to read companion customization',
        error: error,
        stackTrace: stackTrace,
      );
      throw CompanionCustomizationFailure.storage();
    }
  }

  @override
  Future<void> save(CompanionCustomization customization) async {
    if (customization.ownerId.trim().isEmpty) {
      throw CompanionCustomizationFailure.invalidData();
    }
    try {
      await _isar.writeTxn(() async {
        final existing = await _isar.companionCustomizationLocalModels
            .where()
            .ownerIdEqualTo(customization.ownerId)
            .findFirst();
        final model = CompanionCustomizationLocalModel()
          ..id = existing?.id ?? Isar.autoIncrement
          ..ownerId = customization.ownerId
          ..displayName = customization.identity.displayName
          ..selectedTheme = customization.identity.selectedTheme.name
          ..selectedAvatar = customization.identity.selectedAvatar.name
          ..preferredExpressionStyle =
              customization.identity.preferredExpressionStyle.name;
        await _isar.companionCustomizationLocalModels.put(model);
      });
    } on CompanionCustomizationFailure {
      rethrow;
    } on Object catch (error, stackTrace) {
      logger.error(
        'Failed to save companion customization',
        error: error,
        stackTrace: stackTrace,
      );
      throw CompanionCustomizationFailure.storage();
    }
  }
}
