import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider extends ChangeNotifier {
  final SharedPreferences prefs;

  static const String _surahNumberKey = 'bookmark_surah_number';
  static const String _surahNameKey = 'bookmark_surah_name';
  static const String _pageIndexKey = 'bookmark_page_index';

  int? _surahNumber;
  String? _surahName;
  int? _pageIndex;

  BookmarkProvider({required this.prefs}) {
    _loadBookmark();
  }

  int? get surahNumber => _surahNumber;
  String? get surahName => _surahName;
  int? get pageIndex => _pageIndex;

  bool get hasBookmark => _surahNumber != null && _pageIndex != null;

  void _loadBookmark() {
    _surahNumber = prefs.getInt(_surahNumberKey);
    _surahName = prefs.getString(_surahNameKey);
    _pageIndex = prefs.getInt(_pageIndexKey);
    notifyListeners();
  }

  Future<void> saveBookmark({
    required int surahNumber,
    required String surahName,
    required int pageIndex,
  }) async {
    _surahNumber = surahNumber;
    _surahName = surahName;
    _pageIndex = pageIndex;

    await prefs.setInt(_surahNumberKey, surahNumber);
    await prefs.setString(_surahNameKey, surahName);
    await prefs.setInt(_pageIndexKey, pageIndex);

    notifyListeners();
  }

  Future<void> clearBookmark() async {
    _surahNumber = null;
    _surahName = null;
    _pageIndex = null;

    await prefs.remove(_surahNumberKey);
    await prefs.remove(_surahNameKey);
    await prefs.remove(_pageIndexKey);

    notifyListeners();
  }
}
