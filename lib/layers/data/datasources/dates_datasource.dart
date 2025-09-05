import 'package:quantday/core/constants/shared_preferences_consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatesDataSource {
  Future<bool> updateLastLoadedDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
      SharedPreferencesConstants.lastLoadedDate,
      date,
    );
  }

  Future<String?> getLastLoadedDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferencesConstants.lastLoadedDate);
  }
}
