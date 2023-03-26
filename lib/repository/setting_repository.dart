import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository {
  final String _gridModeKey = "gridMode";

  Future<bool> saveGridMode(bool gridMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_gridModeKey, gridMode);
  }

  Future<bool> getGridMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_gridModeKey) ?? false;
  }
}
