import 'package:shared_preferences/shared_preferences.dart';

class CachedApiService {
  const CachedApiService(this._prefs);

  final SharedPreferences _prefs;

  static const Duration defaultCacheDuration = Duration(hours: 6);

  Future<String?> getCached(
    String key, {
    Duration duration = defaultCacheDuration,
  }) async {
    final timestamp = _prefs.getInt(_timestampKey(key));
    if (timestamp == null) return null;

    final cachedAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (DateTime.now().difference(cachedAt) > duration) {
      await _prefs.remove(key);
      await _prefs.remove(_timestampKey(key));
      return null;
    }

    return _prefs.getString(key);
  }

  Future<void> cache(String key, String data) async {
    await _prefs.setString(key, data);
    await _prefs.setInt(
      _timestampKey(key),
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  String _timestampKey(String key) => '${key}_timestamp';
}
