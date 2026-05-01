import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {

  static const String _vowelsProgressKey = "vowels_progress";
  static const String _oppositesProgressKey = "opposites_progress";
  // ===============================
// 👶 STUDENT INFO
// ===============================
static const String _studentNameKey = "student_name";
static const String _studentGradeKey = "student_grade";
static const String _isProfileCreatedKey = "is_profile_created";
static const String _studentGenderKey = "student_gender";
 


  /// 🔹 SAVE progress (0.0 → 1.0)
  static Future<void> setProgress(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  /// 🔹 LOAD progress
  static Future<double> getProgress(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 0.0;
  }

  /// 🔹 Keys (centralized)
  static String vowels() => _vowelsProgressKey;
  static String opposites() => _oppositesProgressKey;

  // Save name
static Future<void> setStudentName(String name) async {
   final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_studentNameKey, name);
}

// Get name
static Future<String?> getStudentName() async {
   final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_studentNameKey);
}

// Save grade
static Future<void> setStudentGrade(String grade) async {
   final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_studentGradeKey, grade);
}

// Get grade
static Future<String?> getStudentGrade() async {
   final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_studentGradeKey);
}

// Profile created flag
static Future<void> setProfileCreated(bool value) async {
   final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_isProfileCreatedKey, value);
}

static Future<bool> isProfileCreated() async {
   final prefs = await SharedPreferences.getInstance();
   return prefs.getBool(_isProfileCreatedKey) ?? false;
}


static Future<void> setStudentGender(String selectedGender) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_studentGenderKey, selectedGender);
}

static Future<String> getStudentGender() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_studentGenderKey) ?? "boy";
}

static const String _userRoleKey = "user_role";

static Future<void> setUserRole(String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userRoleKey, role);
}

static Future<String?> getUserRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userRoleKey);
}


}
