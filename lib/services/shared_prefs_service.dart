import 'package:shared_preferences/shared_preferences.dart';

// This service handles storing and retrieving simple local data using SharedPreferences
class SharedPrefsService {
  /// Saves the name of the last school the user donated to
  Future<void> saveLastDonatedSchool(String schoolName) async {
    final prefs = await SharedPreferences.getInstance(); // Access local storage
    await prefs.setString('last_donated_school', schoolName); // Save the school name under a key
  }

  /// Retrieves the name of the last donated school (if it exists)
  Future<String?> getLastDonatedSchool() async {
    final prefs = await SharedPreferences.getInstance(); // Access local storage
    return prefs.getString('last_donated_school'); // Return the stored value, or null if not set
  }
}
