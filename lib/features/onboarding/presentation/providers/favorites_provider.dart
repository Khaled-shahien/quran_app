import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  static const String _favoritesKey = 'favorite_verses';

  List<Map<String, String>> _favoriteVerses = [];

  FavoritesProvider({required this.prefs}) {
    _loadFavorites();
  }

  List<Map<String, String>> get favoriteVerses => _favoriteVerses;

  void _loadFavorites() {
    final String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      final List<dynamic> decodedList = json.decode(favoritesJson);
      _favoriteVerses = decodedList
          .map((item) => Map<String, String>.from(item))
          .toList();
    }
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final String encodedList = json.encode(_favoriteVerses);
    await prefs.setString(_favoritesKey, encodedList);
  }

  bool isFavorite(Map<String, String> verse) {
    return _favoriteVerses.any((v) => v['arabic'] == verse['arabic']);
  }

  Future<void> toggleFavorite(Map<String, String> verse) async {
    if (isFavorite(verse)) {
      _favoriteVerses.removeWhere((v) => v['arabic'] == verse['arabic']);
    } else {
      _favoriteVerses.add(verse);
    }
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> removeFavorite(Map<String, String> verse) async {
    _favoriteVerses.removeWhere((v) => v['arabic'] == verse['arabic']);
    await _saveFavorites();
    notifyListeners();
  }
}
