import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kicko/services/database.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseMethods();
});
