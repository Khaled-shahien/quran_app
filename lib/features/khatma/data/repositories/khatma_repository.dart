import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/khatma_model.dart';

class KhatmaRepository {
  static const String _activeKhatmaKey = 'active_khatma_plan';
  final SharedPreferences prefs;

  KhatmaRepository({required this.prefs});

  Future<void> saveKhatma(KhatmaModel khatma) async {
    final String jsonData = jsonEncode(khatma.toJson());
    await prefs.setString(_activeKhatmaKey, jsonData);
  }

  KhatmaModel? getActiveKhatma() {
    final String? jsonData = prefs.getString(_activeKhatmaKey);
    if (jsonData != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(jsonData);
        return KhatmaModel.fromJson(decoded);
      } catch (e, stackTrace) {
        developer.log(
          'Failed to parse stored khatma plan',
          name: 'quran_app.khatma',
          level: 1000,
          error: e,
          stackTrace: stackTrace,
        );
        return null;
      }
    }
    return null;
  }

  Future<void> deleteActiveKhatma() async {
    await prefs.remove(_activeKhatmaKey);
  }
}
