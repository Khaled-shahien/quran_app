import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/azkar_model.dart';

/// Contract for loading azkar categories from a data source.
abstract class AzkarRepository {
  /// Returns all azkar categories with their items.
  Future<List<AzkarCategoryModel>> getAllAzkar();
}

/// Asset-backed implementation for [AzkarRepository].
class AzkarRepositoryImpl implements AzkarRepository {
  @override
  /// Loads and parses `assets/prayers_data.json`.
  ///
  /// Throws an [Exception] when the asset cannot be read or parsed.
  Future<List<AzkarCategoryModel>> getAllAzkar() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/prayers_data.json',
      );
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => AzkarCategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load azkar data: $e');
    }
  }
}
