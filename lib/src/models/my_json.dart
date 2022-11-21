import 'package:networking/src/models/my_data.dart';

class MyJson {
  /// Variables

  Map<String, dynamic>? _jsonData;

  /// Constructor

  MyJson({
    Map<String, dynamic>? jsonData,
  }) {
    _jsonData = jsonData;
  }

  /// Get Data by given [key]
  /// @return: [ANData]

  MyData get(String key) {
    return MyData(data: _jsonData?[key]);
  }
}
