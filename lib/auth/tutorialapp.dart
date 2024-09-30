import 'package:shared_preferences/shared_preferences.dart';

class SaveTutorial {
  Future<SharedPreferences> data = SharedPreferences.getInstance();

  void saveTutorialStatus() async {
    final value = await data;

    value.setBool("MapScreen", false);
  }

  Future<bool> getSaveTutorialStatus() async {
    final value = await data;

    if (value.containsKey("MapScreen")) {
      bool? getData = value.getBool("MapScreen");
      return getData!;
    } else {
      return true;
    }
  }

  Future<void> clearTutorialStatus() async {
    final value = await data;
    value.setBool("MapScreen", true); // Resetting the tutorial status to false
  }
}
