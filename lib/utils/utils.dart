import 'dart:io';

class Utils {
  static bool isDesktop() {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  static List<String> hiveListToStringList(String hiveList) {
    if (hiveList.isEmpty) {
      return [];
    }
    return hiveList.split(',');
  }
}