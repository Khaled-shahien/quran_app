import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_all_surahs_usecase.dart';
import '../../domain/entities/surah_entity.dart';

/// Quran Provider
///
/// State management for Quran screen using ChangeNotifier pattern
class QuranProvider with ChangeNotifier {
  final GetAllSurahsUsecase _getAllSurahsUsecase;

  List<SurahEntity> _surahs = [];
  bool _isLoading = false;
  String? _error;

  QuranProvider({required GetAllSurahsUsecase getAllSurahsUsecase})
    : _getAllSurahsUsecase = getAllSurahsUsecase;

  List<SurahEntity> get surahs => _surahs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all Surahs from the repository
  Future<void> loadSurahs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _surahs = await _getAllSurahsUsecase();
      _isLoading = false;
      _error = null;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
    }

    notifyListeners();
  }
}
