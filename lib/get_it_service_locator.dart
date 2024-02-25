import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<Dio>(() => Dio());

  // Register DioAdapter with Dio for mocking
  getIt.registerLazySingleton<DioAdapter>(() => DioAdapter(dio: getIt<Dio>()));
}
