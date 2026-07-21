import 'package:focusly/core/logging/app_logger.dart';
import 'package:focusly/features/goals/data/mappers/focus_goal_local_mapper.dart';
import 'package:focusly/features/goals/data/models/focus_goal_local_model.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_failure.dart';
import 'package:focusly/features/goals/domain/repositories/focus_goal_repository.dart';
import 'package:isar_community/isar.dart';

final class IsarFocusGoalRepository implements FocusGoalRepository {
  const IsarFocusGoalRepository(
    this._isar, {
    this.mapper = const FocusGoalLocalMapper(),
    this.logger = const AppLogger(),
  });

  final Isar _isar;
  final FocusGoalLocalMapper mapper;
  final AppLogger logger;

  @override
  Future<FocusGoal?> getByOwnerId(String ownerId) async {
    if (ownerId.trim().isEmpty) throw FocusGoalFailure.invalidData();
    try {
      final model = await _isar.focusGoalLocalModels
          .where()
          .ownerIdEqualTo(ownerId)
          .findFirst();
      return model == null ? null : mapper.toDomain(model);
    } on FocusGoalFailure {
      rethrow;
    } on Object catch (error, stackTrace) {
      logger.error(
        'Failed to read focus goals',
        error: error,
        stackTrace: stackTrace,
      );
      throw FocusGoalFailure.storage();
    }
  }

  @override
  Future<void> save(FocusGoal goal) async {
    try {
      await _isar.writeTxn(() async {
        final existing = await _isar.focusGoalLocalModels
            .where()
            .ownerIdEqualTo(goal.ownerId)
            .findFirst();
        final model = mapper.toLocal(goal)
          ..id = existing?.id ?? Isar.autoIncrement;
        await _isar.focusGoalLocalModels.put(model);
      });
    } on FocusGoalFailure {
      rethrow;
    } on Object catch (error, stackTrace) {
      logger.error(
        'Failed to save focus goals',
        error: error,
        stackTrace: stackTrace,
      );
      throw FocusGoalFailure.storage();
    }
  }
}
