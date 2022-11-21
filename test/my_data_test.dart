import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:networking/networking.dart';

void main() {
  test("Test Valid String", () {
    MyData data = MyData(data: "Foo");

    expect(data.stringValue(), "Foo");
    expect(data.intValue(), 0);
    expect(data.doubleValue(), 0.0);
    expect(data.boolValue(), false);
    expect(data.listDataValue(), []);
  });

  test("Test Null Value", () {
    MyData data = MyData(data: null);

    expect(data.stringValue(), "");
    expect(data.intValue(), 0);
    expect(data.doubleValue(), 0.0);
    expect(data.boolValue(), false);
    expect(data.listDataValue(), []);
  });

  test("Test Valid Int", () {
    int value = Random().nextInt(100);
    MyData data = MyData(data: value);

    expect(data.stringValue(), "");
    expect(data.intValue(), value);
    expect(data.doubleValue(), value);
    expect(data.boolValue(), false);
    expect(data.listDataValue(), []);
  });

  test("Test Valid Double", () {
    double value = Random().nextDouble();
    MyData data = MyData(data: value);

    expect(data.stringValue(), "");
    expect(data.intValue(), 0);
    expect(data.doubleValue(), value);
    expect(data.boolValue(), false);
    expect(data.listDataValue(), []);
  });

  test("Test Valid Bool", () {
    bool value = Random().nextBool();
    MyData data = MyData(data: value);

    expect(data.stringValue(), "");
    expect(data.intValue(), 0);
    expect(data.doubleValue(), 0.0);
    expect(data.boolValue(), value);
    expect(data.listDataValue(), []);
  });

  test("Test Valid Data List", () {
    MyData data = MyData(data: ["bar"]);

    expect(data.stringValue(), "");
    expect(data.intValue(), 0);
    expect(data.doubleValue(), 0.0);
    expect(data.boolValue(), false);
    expect(data.listDataValue().first.stringValue(), "bar");
  });

  test("Test Optional Value", () {
    MyData data = MyData(data: null);

    expect(data.optStringValue(), isNull);
    expect(data.optIntValue(), isNull);
    expect(data.optDoubleValue(), isNull);
    expect(data.optBoolValue(), isNull);
    expect(data.listDataValue(), isEmpty);
  });
}
