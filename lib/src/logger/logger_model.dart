import 'dart:convert';

class LoggerModel {
  DateTime time;
  Map<String, dynamic>? header;
  String? data;

  LoggerModel({
    required this.time,
    this.header,
    dynamic data,
  }) {
    if (data is Map<String, dynamic> || data is List<dynamic>) {
      this.data = jsonEncode(data);
    } else if (data is String) {
      this.data = data;
    }
  }

  dynamic getObject() {
    if (data == null) return {};
    try {
      return jsonDecode(data!);
    } catch (_) {
      return {};
    }
  }
}
