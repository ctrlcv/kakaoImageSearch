import 'package:get/get.dart';
import 'package:threedotthree/repository/setting_repository.dart';

class SettingController extends GetxController {
  bool _isGridMode = false;

  bool get isGridMode => _isGridMode;

  @override
  void onInit() async {
    _isGridMode = await SettingRepository().getGridMode();
    // debugPrint("SettingController _isGridMode $_isGridMode");

    super.onInit();
  }

  void setGridMode(bool mode) {
    _isGridMode = mode;
    SettingRepository().saveGridMode(mode);
    // debugPrint("setGridMode() mode: $mode");
    update();
  }
}
