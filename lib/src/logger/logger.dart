import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:networking/src/logger/log_model.dart';
import 'package:networking/src/logger/logger_model.dart';
import 'package:networking/src/logger/logger_result_type.dart';
import 'package:pretty_json/pretty_json.dart';

class Logger {
  static Logger shared = Logger();
  final List<LogModel> _logs = <LogModel>[];
  final Map<String, LogModel> _logMap = <String, LogModel>{};

  final StreamController<List<LogModel>> _streamController =
      StreamController<List<LogModel>>.broadcast();

  /// Getter

  Stream<List<LogModel>> logStream() => _streamController.stream;
  List<LogModel> logs() => _logs;

  /// Add Request
  ///
  /// [identifier] : [String]
  /// [url] : [String]
  /// [method] : [String]
  /// [request] : [ANLoggerModel]

  void addRequest({
    String? identifier,
    required String url,
    required String method,
    required LoggerModel request,
  }) {
    if (identifier == null || !kDebugMode) return;

    debugPrint("-- ⬆️ Sending $method Request to $url");
    debugPrint(
      "-- Request Header ${prettyJson(request.header, indent: 4)}",
    );
    debugPrint(
      "-- Request Param ${prettyJson(request.getObject(), indent: 4)}",
    );

    _logMap[identifier] = LogModel(method: method, url: url, request: request);
  }

  /// Adding Response For Success Response
  ///
  /// @param:
  /// [identifier] : [String]
  /// [code] : [num]
  /// [response] : [ANLoggerModel]

  void addResponse({
    String? identifier,
    required num code,
    required LoggerModel response,
  }) {
    if (identifier == null || !kDebugMode) return;
    if (_logMap[identifier] != null) {
      LogModel? data = _logMap[identifier];

      debugPrint(
        "-- ✅ Success Receiving ${data?.method} Response From ${data?.url ?? "Unknown"}",
      );
      debugPrint("-- Status Code $code");
      debugPrint(
        "-- Response Header ${prettyJson(response.header, indent: 4)}",
      );
      debugPrint(
        "-- Response ${prettyJson(response.getObject(), indent: 4)}",
      );

      data?.setResponse(
        response: response,
        code: code,
        resultType: LoggerResultType.success,
      );

      _addLog(data);
    }
  }

  /// Add Error Response
  ///
  /// @param:
  /// [identifier] : [String]
  /// [code] : [num]
  /// [error] : [ANLoggerModel]

  addError({
    String? identifier,
    required num code,
    required LoggerModel error,
  }) {
    if (identifier == null || !kDebugMode) return;
    if (_logMap[identifier] != null) {
      LogModel? data = _logMap[identifier];

      debugPrint(
        "-- ❌ Error Receiving ${data?.method} Response From ${data?.url ?? "Unknown"}",
      );
      debugPrint("-- Status Code $code");
      debugPrint("-- Response Header ${prettyJson(error.header, indent: 4)}");
      debugPrint("-- Response ${prettyJson(error.getObject(), indent: 4)}");

      data?.setResponse(
        response: error,
        code: code,
        resultType: LoggerResultType.error,
      );

      _addLog(data);
    }
  }

  /// Clear Logs
  void clear() {
    _logs.clear();
    _streamController.sink.add(_logs);
  }

  /// Private Add Log
  /// Append given [log] to local [_logs]
  ///
  /// @param:
  /// [log] : [ANLogModel]

  void _addLog(LogModel? log) {
    if (log != null) {
      _logs.add(log);
      _streamController.sink.add(_logs);
    }
  }
}
