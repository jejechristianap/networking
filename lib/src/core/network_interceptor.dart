
import 'package:dio/dio.dart';

class NetworkInterceptor {
  Function(RequestOptions, RequestInterceptorHandler)? onRequest;
  Function(DioException, ErrorInterceptorHandler)? onError;
  Function(Response, ResponseInterceptorHandler)? onSuccess;

  NetworkInterceptor({
    this.onRequest,
    this.onError,
    this.onSuccess,
  });
}
