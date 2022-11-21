import 'package:networking/src/models/my_json.dart';

class MyData {
  /// Variables

  dynamic _data;

  /// Constructor

  MyData({
    dynamic data,
  }) {
    _data = data;
  }

  /// Get String Value
  /// @return: [String]

  String stringValue() {
    if (_data is String) {
      return _data;
    }

    return "";
  }

  /// Get Optional String Value
  /// @return: [String?]

  String? optStringValue() {
    if (_data != null) {
      return stringValue();
    }
    return null;
  }

  /// Get Int Value
  /// @return: [int]

  int intValue() {
    if (_data is int) {
      return _data;
    }

    return int.tryParse(_data.toString()) ?? 0;
  }

  /// Get Optional Int Value
  /// @return [int?]

  int? optIntValue() {
    if (_data != null) {
      return intValue();
    }
    return null;
  }

  /// Get bool Value
  /// @return: [bool]

  bool boolValue() {
    if (_data is bool) return _data;
    if (stringValue().toLowerCase() == "true") return true;
    if (intValue() == 1) return true;
    if (doubleValue() == 1.0) return true;

    return false;
  }

  /// Get Optional bool Value
  /// @return: [bool?]

  bool? optBoolValue() {
    if (_data != null) {
      return boolValue();
    }
    return null;
  }

  /// Get double Value
  /// @return: [double]

  double doubleValue() {
    if (_data is double) {
      return _data;
    }

    return double.tryParse(_data.toString()) ?? 0.0;
  }

  /// Get Optional double Value
  /// @return: [double?]

  double? optDoubleValue() {
    if (_data != null) {
      return doubleValue();
    }
    return null;
  }

  /// Get Json Value
  /// @return: [ANJson]

  MyJson jsonValue() {
    if (_data is Map<String, dynamic>) {
      return MyJson(jsonData: _data);
    }

    return MyJson();
  }

  /// Get List of Data Value
  /// @return: [List<MyData>]

  List<MyData> listDataValue() {
    if (_data is List<dynamic>) {
      List<dynamic> list = _data;
      return list.map((e) => MyData(data: e)).toList();
    }

    return <MyData>[];
  }
}
