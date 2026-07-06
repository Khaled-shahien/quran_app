import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quran_app/core/app/app_root.dart';
import 'package:quran_app/core/initialization/app_initializer.dart';

void main() async {
  // Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables before service initialization.
  await dotenv.load(fileName: '.env');

  // Orchestrate all initialization (Firebase, DI, background services)
  await AppInitializer.initialize();

  // Run the app
  runApp(const AppRoot());
}
