import 'dart:io';

import 'package:dio_http/dio_http.dart';
import 'package:networking/src/core/network_interceptor.dart';
import 'package:networking/src/core/network_setting.dart';
import 'package:networking/src/exception/general_error_exception.dart';
import 'package:networking/src/exception/no_network_exception.dart';
import 'package:networking/src/exception/unstable_network_exception.dart';
import 'package:networking/src/logger/logger.dart';
import 'package:networking/src/logger/logger_model.dart';
import 'package:networking/src/models/my_response.dart';

const String kRequestId = "requestId";

class Networking {
  final Dio _dio = Dio();
  late NetworkSetting _networkSetting;
  late NetworkInterceptor? _networkInterceptor;

  /// Base Constructor
  ///
  /// @param:
  /// - [networkSetting] : [AgriakuNetworkSetting] (Optional) when leave empty
  /// will use default [AgriakuNetworkSetting] setting
  /// - [networkInterceptor] [AgriakuNetworkInterceptor] (Optional)
  ///
  /// @return: void

  Networking({
    NetworkSetting? networkSetting,
    NetworkInterceptor? networkInterceptor,
  }) {
    _networkSetting = networkSetting ?? NetworkSetting.shared;
    _networkInterceptor = networkInterceptor;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: _onErrorHandler,
        onRequest: _onRequestHandler,
        onResponse: _onSuccessHandler,
      ),
    );
  }

  /// Http GET method
  ///
  /// @param:
  /// - [url] : [String] (Required)
  /// - [params] : [Map<String, dynamic>] (Optional)
  /// - [headers] : [Map<String, dynamic>] (Optional)
  /// - [receiveTimeout] : [int?]
  ///
  /// @return: [ANResponse]

  Future<MyResponse> get({
    required String url,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    int? receiveTimeout,
  }) async {
    try {
      Response response = await _dio.get(
        _networkSetting.getUrl(url),
        queryParameters: params,
        options: Options(
          extra: {kRequestId: _getRequestIdentifier(url)},
          headers: _networkSetting.getHeader(headers ?? {}),
          receiveTimeout: receiveTimeout,
        ),
      );

      return Future.value(MyResponse(response: response));
    } on DioError catch (e) {
      return _handleDioError(e);
    } catch (error) {
      return Future.error(error);
    }
  }

  /// Http POST method
  ///
  /// @param:
  /// - [url] : [String] (Required)
  /// - [params] : [Map<String, dynamic>] (Optional)
  /// - [headers] : [Map<String, dynamic>] (Optional)
  /// - [receiveTimeout] : [int?]
  ///
  /// @return: [ANResponse]

  // Future<MyResponse> post({
  //   required String url,
  //   Map<String, dynamic>? params,
  //   Map<String, String>? headers,
  //   int? receiveTimeout,
  // }) async {
  //   try {
  //     MyResponse response = await _dio.post(
  //       _networkSetting.getUrl(url),
  //       data: params,
  //       options: Options(
  //         extra: {kRequestId: _getRequestIdentifier(url)},
  //         headers: _networkSetting.getHeader(headers ?? {}),
  //         receiveTimeout: receiveTimeout,
  //       ),
  //     );
  //
  //     return Future.value(MyResponse(response: response));
  //   } on DioError catch (e) {
  //     return _handleDioError(e);
  //   } catch (error) {
  //     return Future.error(error);
  //   }
  // }

  /// Http PATCH method
  ///
  /// @param:
  /// - [url] : [String] (Required)
  /// - [params] : [Map<String, dynamic>] (Optional)
  /// - [headers] : [Map<String, dynamic>] (Optional)
  /// - [receiveTimeout] : [int?]
  ///
  /// @return: [ANResponse]

  // Future<MyResponse> patch({
  //   required String url,
  //   Map<String, dynamic>? params,
  //   Map<String, String>? headers,
  //   int? receiveTimeout,
  // }) async {
  //   try {
  //     MyResponse response = await _dio.patch(
  //       _networkSetting.getUrl(url),
  //       data: params,
  //       options: Options(
  //         extra: {kRequestId: _getRequestIdentifier(url)},
  //         headers: _networkSetting.getHeader(headers ?? {}),
  //         receiveTimeout: receiveTimeout,
  //       ),
  //     );
  //
  //     return Future.value(MyResponse(response: response));
  //   } on DioError catch (e) {
  //     return _handleDioError(e);
  //   } catch (error) {
  //     return Future.error(error);
  //   }
  // }

  /// Http Put Method
  ///
  /// @param:
  /// - [url] : [String] (Required)
  /// - [params] : [Map<String, dynamic>] (Optional)
  /// - [headers] : [Map<String, dynamic] (Optional)
  /// - [receiveTimeout] : [int?]
  ///
  /// @return: Future<[MyResponse]>

  // Future<MyResponse> put({
  //   required String url,
  //   Map<String, dynamic>? params,
  //   Map<String, String>? headers,
  //   int? receiveTimeout,
  // }) async {
  //   try {
  //     MyResponse response = await _dio.put(
  //       _networkSetting.getUrl(url),
  //       data: params,
  //       options: Options(
  //         extra: {kRequestId: _getRequestIdentifier(url)},
  //         headers: _networkSetting.getHeader(headers ?? {}),
  //         receiveTimeout: receiveTimeout,
  //       ),
  //     );
  //
  //     return Future.value(MyResponse(response: response));
  //   } on DioError catch (e) {
  //     return _handleDioError(e);
  //   } catch (error) {
  //     return Future.error(error);
  //   }
  // }

  /// Http DELETE Method
  ///
  /// @param:
  /// - [url] : [String] (Required)
  /// - [headers] : [Map<String, String>] (Optional)
  /// - [receiveTimeout] : [int?]
  ///
  /// @return: Future<[MyResponse]>

  // Future<MyResponse> delete({
  //   required String url,
  //   Map<String, String>? headers,
  //   int? receiveTimeout,
  // }) async {
  //   try {
  //     MyResponse response = await _dio.delete(
  //       _networkSetting.getUrl(url),
  //       options: Options(
  //         extra: {kRequestId: _getRequestIdentifier(url)},
  //         headers: _networkSetting.getHeader(headers ?? {}),
  //         receiveTimeout: receiveTimeout,
  //       ),
  //     );
  //
  //     return Future.value(MyResponse(response: response));
  //   } on DioError catch (e) {
  //     return _handleDioError(e);
  //   } catch (error) {
  //     return Future.error(error);
  //   }
  // }

  /// Upload Single File
  ///
  /// @param:
  /// - [url] : [String]
  /// - [key] : [String]
  /// - [file] : [File]
  /// - [headers] : [Map<String, String>?]
  /// - [params] : [Map<String, dynamic>?]
  /// - [uploadTimeout] : [int?]
  /// - [receiveTimeout] : [int?]
  ///
  /// @return: Future<[MyResponse]>

  // Future<MyResponse> upload({
  //   required String url,
  //   required String key,
  //   required File file,
  //   Map<String, String>? headers,
  //   Map<String, dynamic>? params,
  //   int? uploadTimeout,
  //   int? receiveTimeout,
  // }) async {
  //   try {
  //     Map<String, dynamic> _params = params ?? {};
  //     _params[key] = await MultipartFile.fromFile(file.path);
  //     FormData formData = FormData.fromMap(_params);
  //     MyResponse response = await _dio.post(
  //       _networkSetting.getUrl(url),
  //       data: formData,
  //       options: Options(
  //         extra: {kRequestId: _getRequestIdentifier(url)},
  //         headers: _networkSetting.getHeader(headers ?? {}),
  //         receiveTimeout: receiveTimeout,
  //       ),
  //     );
  //
  //     return Future.value(MyResponse(response: response));
  //   } on DioError catch (e) {
  //     return _handleDioError(e);
  //   } catch (error) {
  //     return Future.error(error);
  //   }
  // }

  /// Upload Multiple File
  ///
  /// @param:
  /// - [url] : [String]
  /// - [key] : [String]
  /// - [files] : [List<File>]
  /// - [headers] : [Map<String, String>?]
  /// - [params] : [Map<String, dynamic>?]
  /// - [uploadTimeout] : [int?]
  /// - [receiveTimeout] : [int?]
  ///
  /// @return: Future<[MyResponse]>

  // Future<MyResponse> uploadMultiple({
  //   required String url,
  //   required String key,
  //   required List<File> files,
  //   Map<String, String>? headers,
  //   Map<String, dynamic>? params,
  //   int? uploadTimeout,
  //   int? receiveTimeout,
  // }) async {
  //   try {
  //     Map<String, dynamic> _params = params ?? {};
  //
  //     _params[key] = files.map((file) async {
  //       return await MultipartFile.fromFile(file.path);
  //     });
  //
  //     FormData formData = FormData.fromMap(_params);
  //     MyResponse response = await _dio.post(
  //       _networkSetting.getUrl(url),
  //       data: formData,
  //       options: Options(
  //         extra: {kRequestId: _getRequestIdentifier(url)},
  //         headers: _networkSetting.getHeader(headers ?? {}),
  //         receiveTimeout: receiveTimeout,
  //       ),
  //     );
  //
  //     return Future.value(response);
  //   } on DioError catch (e) {
  //     return _handleDioError(e);
  //   } catch (error) {
  //     return Future.error(error);
  //   }
  // }

  /// Error Handler
  ///
  /// @param:
  /// - [error] : [DioError]
  ///
  /// @return: Future<[MyResponse]>

  Future<MyResponse> _handleDioError(DioError error) {
    Response? response = error.response;

    if (error.type == DioErrorType.response && response != null) {
      return Future.value(MyResponse(response: response));
    } else if ([
      DioErrorType.connectTimeout,
      DioErrorType.sendTimeout,
      DioErrorType.receiveTimeout
    ].contains(error.type)) {
      return Future.error(UnstableNetworkException(error.message));
    } else if (error.type == DioErrorType.other &&
        error.error is SocketException) {
      return Future.error(NoNetworkException(error.message));
    }

    return Future.error(GeneralErrorException(error.message));
  }

  /// OnErrorHandler
  ///
  /// @param:
  /// - [error] : [DioError]
  /// - [handler] : [ErrorInterceptorHandler]
  ///
  /// @return: void

  dynamic _onErrorHandler(
    DioError error,
    ErrorInterceptorHandler handler,
  ) {
    Logger.shared.addError(
      identifier: error.requestOptions.extra[kRequestId],
      code: error.response?.statusCode ?? -1,
      error: LoggerModel(
        time: DateTime.now(),
        header: error.response?.headers.map ?? {},
        data: error.response?.data ?? error.error,
      ),
    );

    if (_networkInterceptor?.onError != null) {
      return _networkInterceptor?.onError!(error, handler);
    }

    return handler.next(error);
  }

  /// OnRequestHandler
  ///
  /// @param:
  /// - [options] : [RequestOptions]
  /// - [handler] : [RequestInterceptorHandler]
  ///
  /// @return: void

  dynamic _onRequestHandler(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    Logger.shared.addRequest(
      method: options.method,
      identifier: options.extra[kRequestId],
      url: options.uri.toString(),
      request: LoggerModel(
        time: DateTime.now(),
        header: options.headers,
        data: options.data,
      ),
    );

    if (_networkInterceptor?.onRequest != null) {
      return _networkInterceptor?.onRequest!(options, handler);
    }

    return handler.next(options);
  }

  /// OnSuccessHandler
  ///
  /// @param:
  /// - [response] : [MyResponse]
  /// - [handler] : [ResponseInterceptorHandler]
  ///
  /// @return: void

  dynamic _onSuccessHandler(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    Logger.shared.addResponse(
      identifier: response.requestOptions.extra[kRequestId],
      code: response.statusCode ?? -1,
      response: LoggerModel(
        time: DateTime.now(),
        header: response.headers.map,
        data: response.data,
      ),
    );

    if (_networkInterceptor?.onSuccess != null) {
      return _networkInterceptor?.onSuccess!(response, handler);
    }

    return handler.next(response);
  }

  /// Creating Request Identifier for Network Monitoring.
  /// Network Monitoring requires some kind of Request Identifier
  /// to matching every response/error with its request.
  ///
  /// @param:
  /// - [url] : [String] (Required)
  ///
  /// @return: [String]

  String _getRequestIdentifier(String url) {
    DateTime now = DateTime.now();
    return "${_networkSetting.getUrl(url)}|${now.year}-${now.month}-${now.day}|${now.hour}:${now.minute}:${now.second}:${now.millisecond}:${now.microsecond}";
  }
}
