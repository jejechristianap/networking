import 'package:dio_http/dio_http.dart';

class NetworkInterceptor {
  Function(RequestOptions, RequestInterceptorHandler)? onRequest;
  Function(DioError, ErrorInterceptorHandler)? onError;
  Function(Response, ResponseInterceptorHandler)? onSuccess;

  NetworkInterceptor({
    this.onRequest,
    this.onError,
    this.onSuccess,
  });
}
