import 'package:flutter/foundation.dart';

class NetworkSetting {
  String? baseUrl;
  late Map<String, String> baseHeader;
  bool _isLoggerEnabled = false;
  bool get isLoggerEnabled => _isLoggerEnabled;

  static NetworkSetting shared = NetworkSetting(
    baseUrl: '',
    baseHeader: <String, String>{},
  );

  /// Constructor
  ///
  /// @param:
  /// [baseUrl] : [String] (Optional)
  /// [baseHeader] : [Map<String, String>] (Optional)

  NetworkSetting({
    String? baseUrl,
    baseHeader,
    bool isLoggerEnabled = kDebugMode,
  }) {
    this.baseUrl = baseUrl ?? NetworkSetting.shared.baseUrl;
    this.baseHeader = baseHeader ?? NetworkSetting.shared.baseHeader;
    _isLoggerEnabled = isLoggerEnabled;
  }

  /// Get Full Header
  /// This function basically merging the base Header with custom header
  /// given from the networking library
  ///
  /// @param:
  /// [header] : [Map<String, String>]
  ///
  /// @return: [Map<String, String>]
  Map<String, String> getHeader(Map<String, String> header) {
    Map<String, String>? finalHeader = baseHeader;
    for (var element in header.keys) {
      finalHeader[element] = header[element] ?? '';
    }
    return finalHeader;
  }

  /// This function basically generating full url.
  /// If networking library give only path in [url] then this function will
  /// only concat with baseUrl. If networking library give full url in [url]
  /// then this function will immediately return that [url].
  ///
  /// @param:
  /// - [url] : [String]
  ///
  /// @return: [String]

  String getUrl(String url) {
    Uri uri = Uri.parse(url);
    String baseUrl = this.baseUrl ?? '';

    if (uri.host.isNotEmpty && uri.hasScheme) {
      return url;
    }

    String sanitizedUrl = url.startsWith("/") ? url.replaceFirst("/", "") : url;
    return baseUrl + (sanitizedUrl.isNotEmpty ? "/$sanitizedUrl" : "");
  }

  /// Chaining Methods

  /// Set Base Url
  /// Setter for private [_baseUrl] variable
  ///
  /// @param:
  /// - [url] : [String]
  ///
  /// @return: [AgriakuNetworkSetting]

  NetworkSetting setBaseUrl(String url) {
    baseUrl = url.endsWith("/") ? url.substring(0, url.length - 1) : url;
    return this;
  }

  /// Add Default Header
  /// Setter for private [_baseHeader] variable
  /// Basically this function only set the value for given key into the [_baseHeader]
  /// variable.
  ///
  /// @param:
  /// - [key] : [String]
  /// - [value] : [String]
  ///
  /// @return: [AgriakuNetworkSetting]

  NetworkSetting addDefaultHeader({
    required String key,
    required String value,
  }) {
    baseHeader[key] = value;
    return this;
  }

  /// Remove Default Header
  /// Removing the key and value for given [key]
  ///
  /// @param:
  /// - [key] : [String]
  ///
  /// @return: [AgriakuNetworkSetting]

  NetworkSetting removeDefaultHeader({required String key}) {
    baseHeader.remove(key);
    return this;
  }

  /// Clear Default Header
  /// Cleaning up all the default header keys and values
  ///
  /// @return: [NetworkSetting]

  NetworkSetting clearDefaultHeader() {
    baseHeader.removeWhere((key, value) => true);
    return this;
  }

  /// Set Enable Logger
  /// print log in system console and and monitoring screen

  NetworkSetting setEnableLogger(bool isEnabled) {
    _isLoggerEnabled = isEnabled;
    return this;
  }
}
