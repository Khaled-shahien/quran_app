import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/azkar_model.dart';

abstract class AzkarRepository {
  Future<List<AzkarCategoryModel>> getAllAzkar();
}

class AzkarRepositoryImpl implements AzkarRepository {
  @override
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
