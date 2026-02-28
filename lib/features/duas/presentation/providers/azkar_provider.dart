import 'package:flutter/foundation.dart';
import '../../data/models/azkar_model.dart';
import '../../data/repositories/azkar_repository.dart';

class AzkarProvider extends ChangeNotifier {
  final AzkarRepository _repository;

  List<AzkarCategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  AzkarProvider({required AzkarRepository repository})
    : _repository = repository;

  List<AzkarCategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAzkar() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _repository.getAllAzkar();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get a specific category by its name (exact match)
  AzkarCategoryModel? getCategoryByName(String name) {
    try {
      return _categories.firstWhere((cat) => cat.category == name);
    } catch (e) {
      return null;
    }
  }
}
