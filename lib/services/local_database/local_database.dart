import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

final class LocalDatabase {
  const LocalDatabase._();

  static const name = 'focusly';
  static Future<Isar> open({
    required List<CollectionSchema<dynamic>> schemas,
  }) async {
    final existing = Isar.getInstance(name);
    if (existing != null) return existing;
    final directory = await getApplicationDocumentsDirectory();
    return Isar.open(schemas, directory: directory.path, name: name);
  }
}
