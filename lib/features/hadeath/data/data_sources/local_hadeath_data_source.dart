import 'package:flutter/services.dart';
import '../models/hadeath_model.dart';

class LocalHadeathDataSource {
  final String _assetPath = 'assets/hadeath/ahadeth.txt';

  /// Loads the ahadeth text file from assets, parses it, and returns a list of models
  Future<List<HadeathModel>> loadAhadeth() async {
    try {
      // Load the file content
      String fileContent = await rootBundle.loadString(_assetPath);

      // The text file separates each Hadeath with '#'
      List<String> rawAhadethList = fileContent.split('#');

      List<HadeathModel> ahadethList = [];

      for (String rawHadeath in rawAhadethList) {
        if (rawHadeath.trim().isNotEmpty) {
          // Parse each raw string into a HadeathModel
          ahadethList.add(HadeathModel.fromString(rawHadeath));
        }
      }

      return ahadethList;
    } catch (e) {
      throw Exception('Failed to load ahadeth data: $e');
    }
  }
}
