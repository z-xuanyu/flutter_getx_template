import 'package:get/get.dart';

class AboutState {
  // title
  final _title = "你好，阿宇".obs;
  set title(value) => _title.value = value;
  get title => _title.value;
}
