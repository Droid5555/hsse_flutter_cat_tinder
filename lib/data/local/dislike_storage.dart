import 'package:shared_preferences/shared_preferences.dart';

class DislikeCounterStorage {
  static const _key = 'dislike_count';

  Future<int> getDislikeCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  Future<void> incrementDislikeCount() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_key) ?? 0;
    await prefs.setInt(_key, current + 1);
  }

  Future<void> decrementDislikeCount() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_key) ?? 0;
    await prefs.setInt(_key, current > 0 ? current - 1 : 0);
  }

  Future<void> resetDislikeCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, 0);
  }
}
