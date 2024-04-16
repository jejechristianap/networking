import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:networking/src/models/my_json.dart';
import 'package:networking/src/models/my_model.dart';

class MyResponse {
  final Response response;

  MyResponse({
    required this.response,
  });

  factory MyResponse.fromResponse(Response response) {
    return MyResponse(
      response: response,
    );
  }

  @nonVirtual
  T getData<T extends MyModel>(
    T Function(MyJson json) fromJson,
  ) {
    return fromJson(MyJson(jsonData: getJsonData()));
  }

  @nonVirtual
  List<T> getList<T extends MyModel>(
    T Function(MyJson json) fromJson,
  ) {
    List<MyJson> jsonList = getJsonList();
    return jsonList.map((e) => fromJson(e)).toList();
  }

  @nonVirtual
  Map<String, dynamic> getJsonData() {
    try {
      if (response.data is String) {
        return jsonDecode(response.data) as Map<String, dynamic>;
      } else if (response.data is Map) {
        return response.data;
      }

      return <String, dynamic>{};
    } catch (error) {
      debugPrint(error.toString());
      return <String, dynamic>{};
    }
  }

  @nonVirtual
  List<MyJson> getJsonList() {
    try {
      return (response.data as List<dynamic>)
          .map((e) => MyJson(jsonData: e))
          .toList();
    } catch (error) {
      debugPrint(error.toString());
      return <MyJson>[];
    }
  }

  @nonVirtual
  num getStatusCode() {
    return response.statusCode ?? -1;
  }
}
