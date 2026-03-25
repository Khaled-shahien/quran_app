import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ValueNotifier<List<Map<String, String>>> {
  final SharedPreferences prefs;
  static const String _favoritesKey = 'favorite_verses';

  FavoritesProvider({required this.prefs}) : super(<Map<String, String>>[]) {
    _loadFavorites();
  }

  List<Map<String, String>> get favoriteVerses => value;

  void _loadFavorites() {
    final String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      final List<dynamic> decodedList = json.decode(favoritesJson);
      value = decodedList
          .map((item) => Map<String, String>.from(item))
          .toList();
    }
  }

  Future<void> _saveFavorites() async {
    final String encodedList = json.encode(value);
    await prefs.setString(_favoritesKey, encodedList);
  }

  bool isFavorite(Map<String, String> verse) {
    return value.any((v) => v['arabic'] == verse['arabic']);
  }

  Future<void> toggleFavorite(Map<String, String> verse) async {
    final List<Map<String, String>> updatedFavorites =
        List<Map<String, String>>.from(value);
    if (isFavorite(verse)) {
      updatedFavorites.removeWhere((v) => v['arabic'] == verse['arabic']);
    } else {
      updatedFavorites.add(verse);
    }
    value = updatedFavorites;
    await _saveFavorites();
  }

  Future<void> removeFavorite(Map<String, String> verse) async {
    final List<Map<String, String>> updatedFavorites =
        List<Map<String, String>>.from(value)
          ..removeWhere((v) => v['arabic'] == verse['arabic']);
    value = updatedFavorites;
    await _saveFavorites();
  }
}
