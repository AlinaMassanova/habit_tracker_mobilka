import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class ApiClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:3001',
    contentType: 'application/json',
    validateStatus: (_) => true,
  ));

  static Future<void> setup() async {
    final dir = await getApplicationDocumentsDirectory();
    final cookieJar = PersistCookieJar(
      storage: FileStorage('${dir.path}/.cookies/'),
    );
    dio.interceptors.add(CookieManager(cookieJar));
  }
}
