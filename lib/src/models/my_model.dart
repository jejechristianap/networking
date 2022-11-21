import 'package:networking/src/models/my_json.dart';

abstract class MyModel {
  late MyJson json;

  MyModel.fromJson(this.json) {
    parse();
  }

  parse();
}
