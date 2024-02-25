import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() async {
  //// Exact body check 
  // final dio = Dio(BaseOptions(contentType: Headers.jsonContentType));
  // dioAdapter = DioAdapter(
  //  dio: dio,
  //  matcher: const FullHttpRequestMatcher(needsExactBody: true),
  // );

  // Basic setup
  final dio = Dio(BaseOptions());
  final dioAdapter = DioAdapter(dio: dio);

  const path = 'https://example.com';

  dioAdapter.onGet(
    path,
    (server) => server.reply(
      200,
      {'message': 'Success!'},
      // Reply would wait for one-sec before returning data.
      delay: const Duration(seconds: 1),
    ),
  );

  final response = await dio.get(path);

  print(response.data); // {message: Success!}
}