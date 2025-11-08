import 'package:get/get.dart';

class ApplicationState {
  // title
  final _title = "".obs;
  set title(value) => _title.value = value;
  get title => _title.value;

  // 当前tabs index
  final _tabIndex = 0.obs;
  set tabIndex(value) => _tabIndex.value = value;
  get tabIndex => _tabIndex.value;
}
