import 'package:networking/src/logger/logger_model.dart';
import 'package:networking/src/logger/logger_result_type.dart';

class LogModel {
  String url;
  String method;
  LoggerModel request;
  LoggerModel? response;
  num? code;
  LoggerResultType result = LoggerResultType.initial;

  LogModel({
    required this.method,
    required this.url,
    required this.request,
  });

  /// Set Response
  ///
  /// @param:
  /// [response] : [ANLoggerModel]
  /// [code] : [num]
  /// [resultType] : [ANLoggerResultType]

  setResponse({
    required LoggerModel response,
    required num code,
    required LoggerResultType resultType,
  }) {
    this.response = response;
    this.code = code;
    result = resultType;
  }
}
