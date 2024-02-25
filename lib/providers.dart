import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kicko/services/database.dart';

final FireBaseServiceInterfaceProvider =
    Provider<FireBaseServiceInterface>((ref) {
  return FireBaseService();
});
