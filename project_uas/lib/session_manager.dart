import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';

class SessionManager {
  static const String keyUsername = 'username';
  static const String keyEmail = 'email';
  static const String keyLoggedIn = 'logged_in';
  static const String keyJoinDate = 'joinDate';
  static const String keyCourses = 'courses';
  static const String keyReviews = 'reviews';
  static const String keyRating = 'rating';

  static Future<void> saveUser(String username, String email, {String? joinDate, int courses = 0, int reviews = 0, double rating = 0.0}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUsername, username);
    await prefs.setString(keyEmail, email);
    await prefs.setString(keyJoinDate, joinDate ?? _getCurrentDate());
    await prefs.setInt(keyCourses, courses);
    await prefs.setInt(keyReviews, reviews);
    await prefs.setDouble(keyRating, rating);
    await prefs.setBool(keyLoggedIn, true);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(keyUsername);
    if (username == null) return null;
    
    return User(
      username: username,
      password: '',
      email: prefs.getString(keyEmail) ?? '',
      joinDate: prefs.getString(keyJoinDate) ?? '',
      courses: prefs.getInt(keyCourses) ?? 0,
      reviews: prefs.getInt(keyReviews) ?? 0,
      rating: prefs.getDouble(keyRating) ?? 0.0,
    );
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUsername);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyLoggedIn) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static String _getCurrentDate() {
    final now = DateTime.now();
    final months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
                    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return '${months[now.month - 1]} ${now.year}';
  }
}