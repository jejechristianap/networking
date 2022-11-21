import 'package:dio_http/dio_http.dart';

class ApiService {
  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        validateStatus: (status) => true,
        followRedirects: false,
        baseUrl: 'https://api.opendota.com/api',
        receiveTimeout: 45000,
      ),
    );
  }

  Future<Response> get(
      {required String endPoint, Map<String, dynamic>? query}) async {
    try {
      final Response response = await dio.get(
        endPoint,
        queryParameters: query,
      );
      return response;
    } on DioError catch (err) {
      return Future.error(err);
    }
  }
}