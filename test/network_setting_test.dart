import 'package:flutter_test/flutter_test.dart';
import 'package:networking/src/core/network_setting.dart';

void main() {
  test("Test Set Base Url", () {
    String baseUrl = "https://foo.bar";
    NetworkSetting.shared.setBaseUrl(baseUrl);

    expect(NetworkSetting.shared.getUrl(""), baseUrl);
  });

  test("Test full url in param", () {
    String expectedUrl = "https://foo.bar/baz";
    NetworkSetting.shared.setBaseUrl("http://read.me");

    expect(NetworkSetting.shared.getUrl(expectedUrl), expectedUrl);
  });

  test("Test url has leading slash", () {
    String baseUrl = "https://foo.bar";
    String path = "baz";
    String expectedUrl = baseUrl + "/" + path;
    NetworkSetting.shared.setBaseUrl(baseUrl);

    expect(NetworkSetting.shared.getUrl("/baz"), expectedUrl);
  });

  test("Test base url has trailing slash", () {
    String baseUrl = "https://foo.bar/";
    String path = "baz";
    String expectedUrl = baseUrl + path;
    NetworkSetting.shared.setBaseUrl(baseUrl);

    expect(NetworkSetting.shared.getUrl(path), expectedUrl);
  });

  test("Test add Base Header", () {
    String key = "foo";
    String value = "bar";
    Map<String, String> expectedHeader = {key: value};
    NetworkSetting.shared.addDefaultHeader(key: key, value: value);

    expect(NetworkSetting.shared.getHeader({}), expectedHeader);
  });

  test("Test Mixin Header", () {
    Map<String, String> expectedHeader = {
      "foo": "bar",
      "baz": "Bang",
    };
    NetworkSetting.shared.addDefaultHeader(key: "foo", value: "bar");
    Map<String, String> resultHeader = NetworkSetting.shared.getHeader({
      "baz": "Bang",
    });

    expect(resultHeader, expectedHeader);
  });

  test("Test Override Header Value", () {
    String expectedFooValue = "Baz";
    NetworkSetting.shared.addDefaultHeader(key: "foo", value: "bar");
    Map<String, String> resultHeader = NetworkSetting.shared.getHeader({
      "foo": "Baz",
    });

    expect(resultHeader["foo"], expectedFooValue);
  });

  test("Clear Default Header", () {
    NetworkSetting.shared
        .addDefaultHeader(key: "foo", value: "bar")
        .clearDefaultHeader();

    expect(NetworkSetting.shared.getHeader({}), {});
  });

  test("Remove Default Header", () {
    NetworkSetting.shared
        .clearDefaultHeader()
        .addDefaultHeader(key: "foo", value: "bar")
        .removeDefaultHeader(key: "foo");

    expect(NetworkSetting.shared.getHeader({}), {});
  });
}
