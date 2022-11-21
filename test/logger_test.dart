import 'package:flutter_test/flutter_test.dart';
import 'package:networking/src/logger/logger.dart';
import 'package:networking/src/logger/logger_model.dart';
import 'package:networking/src/logger/logger_result_type.dart';

void main() {
  test("Test Only Add Request without any response", () {
    Logger.shared.addRequest(
      url: "https://url.com",
      method: "GET",
      request: LoggerModel(time: DateTime.now()),
    );

    expect(Logger.shared.logs(), []);
  });

  test("Test Given Request and Response", () {
    String url = "https://url.com";
    String method = "GET";
    DateTime time = DateTime.now();
    String identifier = "requestIdentifier";

    num responseCode = 200;
    DateTime responseTime = DateTime.now().add(const Duration(minutes: 2));
    LoggerModel response = LoggerModel(time: responseTime);

    Logger.shared.addRequest(
      identifier: identifier,
      url: url,
      method: method,
      request: LoggerModel(time: time),
    );

    Logger.shared.addResponse(
      identifier: identifier,
      code: responseCode,
      response: response,
    );

    expect(Logger.shared.logs().length, 1);
    expect(Logger.shared.logs().first.code, responseCode);
    expect(Logger.shared.logs().first.method, method);
    expect(Logger.shared.logs().first.url, url);
    expect(Logger.shared.logs().first.request.time.day, time.day);
    expect(Logger.shared.logs().first.response?.time.day, responseTime.day);
    expect(Logger.shared.logs().first.result, LoggerResultType.success);
  });

  test("Test Given Request and Error", () {
    String url = "https://url.com";
    String method = "GET";
    DateTime time = DateTime.now();
    String identifier = "requestIdentifier";

    num responseCode = 200;
    DateTime responseTime = DateTime.now().add(const Duration(minutes: 2));
    LoggerModel error = LoggerModel(time: responseTime);

    Logger.shared.addRequest(
      identifier: identifier,
      url: url,
      method: method,
      request: LoggerModel(time: time),
    );

    Logger.shared.addError(
      identifier: identifier,
      code: responseCode,
      error: error,
    );

    expect(Logger.shared.logs().length, 2);
    expect(Logger.shared.logs().first.code, responseCode);
    expect(Logger.shared.logs().first.method, method);
    expect(Logger.shared.logs().first.url, url);
    expect(Logger.shared.logs().first.request.time.day, time.day);
    expect(Logger.shared.logs().first.response?.time.day, responseTime.day);
    expect(Logger.shared.logs().first.result, LoggerResultType.success);
  });

  test("Test Stream", () {
    String url = "https://url.com";
    String method = "GET";
    DateTime time = DateTime.now();
    String identifier = "requestIdentifier";

    num responseCode = 200;
    DateTime responseTime = DateTime.now().add(const Duration(minutes: 2));
    LoggerModel error = LoggerModel(time: responseTime);

    Logger.shared.logStream().listen((event) {
      expect(event.length, 3);
      expect(event.first.code, responseCode);
      expect(event.first.method, method);
      expect(event.first.url, url);
      expect(event.first.request.time.day, time.day);
      expect(event.first.response?.time.day, responseTime.day);
      expect(event.first.result, LoggerResultType.success);
    });

    Logger.shared.addRequest(
      identifier: identifier,
      url: url,
      method: method,
      request: LoggerModel(time: time),
    );

    Logger.shared.addError(
      identifier: identifier,
      code: responseCode,
      error: error,
    );
  });
}
