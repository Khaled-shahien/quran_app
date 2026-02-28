import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quran_app/features/duas/data/models/azkar_model.dart';

abstract class DuasRepository {
  Future<List<AzkarCategoryModel>> getAllDuas();
}

class DuasRepositoryImpl implements DuasRepository {
  @override
  Future<List<AzkarCategoryModel>> getAllDuas() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/quran_duas.json',
      );
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => AzkarCategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load duas data: $e');
    }
  }
}
