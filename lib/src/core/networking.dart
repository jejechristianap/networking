import 'dart:io';

import 'package:dio/dio.dart';
import 'package:networking/networking.dart';
import 'package:networking/src/logger/logger.dart';
import 'package:networking/src/logger/logger_model.dart';
import 'package:flutter/foundation.dart';

const String kRequestId = "requestId";

class Networking {
  final Dio _dio = Dio();
  late NetworkSetting _networkSetting;
  late NetworkInterceptor? _networkInterceptor;
  CancelToken cancelToken = CancelToken();

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
      setCancelToken();

      Response response = await _dio.get(
        _networkSetting.getUrl(url),
        queryParameters: params,
        options: Options(
          extra: {kRequestId: _getRequestIdentifier(url)},
          headers: _networkSetting.getHeader(headers ?? {}),
          receiveTimeout: _getReceiveTimeout(receiveTimeout),
        ),
        cancelToken: cancelToken,
      );

      return Future.value(MyResponse(response: response));
    } on DioException catch (e) {
      return _handleError(e);
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

  Future<MyResponse> post({
    required String url,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    int? receiveTimeout,
    bool useStreamResponse = false,
  }) async {
    try {
      setCancelToken();

      ResponseType? responseType;
      if (useStreamResponse) {
        responseType = ResponseType.stream;
      }

      Response response = await _dio.post(
        _networkSetting.getUrl(url),
        data: params,
        options: Options(
          extra: {kRequestId: _getRequestIdentifier(url)},
          headers: _networkSetting.getHeader(headers ?? {}),
          receiveTimeout: _getReceiveTimeout(receiveTimeout),
          responseType: responseType,
        ),
        cancelToken: cancelToken,
      );

      return Future.value(MyResponse(response: response));
    } on DioException catch (e) {
      return _handleError(e);
    } catch (error) {
      return Future.error(error);
    }
  }

  /// Http PATCH method
  ///
  /// @param:
  /// - [url] : [String] (Required)
  /// - [params] : [Map<String, dynamic>] (Optional)
  /// - [headers] : [Map<String, dynamic>] (Optional)
  /// - [receiveTimeout] : [int?]
  ///
  /// @return: [ANResponse]

  Future<MyResponse> patch({
    required String url,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    int? receiveTimeout,
  }) async {
    try {
      setCancelToken();
      Response response = await _dio.patch(
        _networkSetting.getUrl(url),
        data: params,
        options: Options(
          extra: {kRequestId: _getRequestIdentifier(url)},
          headers: _networkSetting.getHeader(headers ?? {}),
          receiveTimeout: _getReceiveTimeout(receiveTimeout),
        ),
        cancelToken: cancelToken,
      );

      return Future.value(MyResponse(response: response));
    } on DioException catch (e) {
      return _handleError(e);
    } catch (error) {
      return Future.error(error);
    }
  }

  /// Http Put Method
  ///
  /// @param:
  /// - [url] : [String] (Required)
  /// - [params] : [Map<String, dynamic>] (Optional)
  /// - [headers] : [Map<String, dynamic] (Optional)
  /// - [receiveTimeout] : [int?]
  ///
  /// @return: Future<[MyResponse]>

  Future<MyResponse> put({
    required String url,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    int? receiveTimeout,
  }) async {
    try {
      setCancelToken();
      Response response = await _dio.put(
        _networkSetting.getUrl(url),
        data: params,
        options: Options(
          extra: {kRequestId: _getRequestIdentifier(url)},
          headers: _networkSetting.getHeader(headers ?? {}),
          receiveTimeout: _getReceiveTimeout(receiveTimeout),
        ),
        cancelToken: cancelToken,
      );

      return Future.value(MyResponse(response: response));
    } on DioException catch (e) {
      return _handleError(e);
    } catch (error) {
      return Future.error(error);
    }
  }

  /// Http DELETE Method
  ///
  /// @param:
  /// - [url] : [String] (Required)
  /// - [headers] : [Map<String, String>] (Optional)
  /// - [receiveTimeout] : [int?]
  ///
  /// @return: Future<[MyResponse]>

  Future<MyResponse> delete({
    required String url,
    Map<String, String>? headers,
    int? receiveTimeout,
  }) async {
    try {
      setCancelToken();
      Response response = await _dio.delete(
        _networkSetting.getUrl(url),
        options: Options(
          extra: {kRequestId: _getRequestIdentifier(url)},
          headers: _networkSetting.getHeader(headers ?? {}),
          receiveTimeout: _getReceiveTimeout(receiveTimeout),
        ),
        cancelToken: cancelToken,
      );

      return Future.value(MyResponse(response: response));
    } on DioException catch (e) {
      return _handleError(e);
    } catch (error) {
      return Future.error(error);
    }
  }

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

  Future<MyResponse> upload({
    required String url,
    required String key,
    required File file,
    Map<String, String>? headers,
    Map<String, dynamic>? params,
    int? uploadTimeout,
    int? receiveTimeout,
  }) async {
    try {
      setCancelToken();
      Map<String, dynamic> _params = params ?? {};
      _params[key] = await MultipartFile.fromFile(file.path);
      FormData formData = FormData.fromMap(_params);
      Response response = await _dio.post(
        _networkSetting.getUrl(url),
        data: formData,
        options: Options(
          extra: {kRequestId: _getRequestIdentifier(url)},
          headers: _networkSetting.getHeader(headers ?? {}),
          receiveTimeout: _getReceiveTimeout(receiveTimeout),
        ),
        cancelToken: cancelToken,
      );

      return Future.value(MyResponse(response: response));
    } on DioException catch (e) {
      return _handleError(e);
    } catch (error) {
      return Future.error(error);
    }
  }

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

  Future<MyResponse> uploadMultiple({
    required String url,
    required String key,
    required List<File> files,
    Map<String, String>? headers,
    Map<String, dynamic>? params,
    int? uploadTimeout,
    int? receiveTimeout,
  }) async {
    try {
      setCancelToken();
      Map<String, dynamic> _params = params ?? {};

      _params[key] = files.map((file) async {
        return await MultipartFile.fromFile(file.path);
      });

      FormData formData = FormData.fromMap(_params);
      Response response = await _dio.post(
        _networkSetting.getUrl(url),
        data: formData,
        options: Options(
          extra: {kRequestId: _getRequestIdentifier(url)},
          headers: _networkSetting.getHeader(headers ?? {}),
          receiveTimeout: _getReceiveTimeout(receiveTimeout),
        ),
        cancelToken: cancelToken,
      );

      return Future.value(MyResponse(response: response));
    } on DioException catch (e) {
      return _handleError(e);
    } catch (error) {
      return Future.error(error);
    }
  }

  /// Error Handler
  ///
  /// @param:
  /// - [error] : [DioException]
  ///
  /// @return: Future<[MyResponse]>

  Future<MyResponse> _handleError(DioException error) {
    Response? response = error.response;

    if (error.type == DioExceptionType.badResponse && response != null) {
      return Future.value(MyResponse(response: response));
    } else if ([
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout
    ].contains(error.type)) {
      return Future.error(UnstableNetworkException(error.message ?? ''));
    } else if (error.type == DioExceptionType.unknown &&
        error.error is SocketException) {
      return Future.error(NoNetworkException(error.message ?? ''));
    } else if (error.type == DioExceptionType.receiveTimeout) {
      cancelToken.cancel();
    }

    return Future.error(GeneralErrorException(error.message ?? ''));
  }

  /// OnErrorHandler
  ///
  /// @param:
  /// - [error] : [DioException]
  /// - [handler] : [ErrorInterceptorHandler]
  ///
  /// @return: void

  dynamic _onErrorHandler(
    DioException error,
    ErrorInterceptorHandler handler,
  ) {
    if (_networkSetting.isLoggerEnabled || kDebugMode) {
      Logger.shared.addError(
        identifier: error.requestOptions.extra[kRequestId],
        code: error.response?.statusCode ?? -1,
        error: LoggerModel(
          time: DateTime.now(),
          header: error.response?.headers.map ?? {},
          data: error.response?.data ?? error.error,
        ),
      );
    }

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
    if (_networkSetting.isLoggerEnabled || kDebugMode) {
      Logger.shared.addResponse(
        identifier: response.requestOptions.extra[kRequestId],
        code: response.statusCode ?? -1,
        response: LoggerModel(
          time: DateTime.now(),
          header: response.headers.map,
          data: response.data,
        ),
      );
    }

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

  Duration? _getReceiveTimeout(int? timeout) {
    return timeout == null ? null : Duration(milliseconds: timeout);
  }

  void setCancelToken() {
    if (cancelToken.isCancelled) {
      cancelToken = CancelToken();
    }
  }
}
