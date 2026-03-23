import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_app/core/providers/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('SettingsProvider persists morning alarm toggle', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final provider = SettingsProvider(prefs: prefs);

    await provider.toggleMorningAlarm(true);

    expect(provider.isMorningAlarmEnabled, isTrue);
    expect(prefs.getBool('morning_alarm_enabled'), isTrue);
  });
}
