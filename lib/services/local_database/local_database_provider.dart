import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

/// Bootstrap reemplaza este provider con la única instancia productiva.
///
/// El valor nulo permite montar widgets aislados sin abrir almacenamiento real.
final localDatabaseProvider = Provider<Isar?>((ref) => null);
