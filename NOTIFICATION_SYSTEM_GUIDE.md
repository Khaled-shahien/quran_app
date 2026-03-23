# Notification & Alarm System Documentation

## Overview
This document explains the notification and alarm system implemented in the Quran App. The system provides daily reminders for:
- Morning Adhkar (أذكار الصباح)
- Evening Adhkar (أذكار المساء)
- Surah Al-Mulk (سورة الملك)
- Surah Al-Baqarah (سورة البقرة)

## Features

### 1. **Daily Scheduled Notifications**
All alarms are scheduled to repeat daily at their specified times.

### 2. **Customizable Times**
Users can customize the time for each alarm through an intuitive time picker dialog.

### 3. **Persistent Storage**
Alarm settings and times are saved locally using SharedPreferences.

### 4. **Automatic Rescheduling**
When an alarm is toggled on/off or its time is changed, the system automatically reschedules notifications.

### 5. **Platform Support**
- **Android**: Full support with exact alarm scheduling
- **iOS**: Full support with local notifications

## Architecture

### Core Components

#### 1. `NotificationService` (`lib/core/services/notification_service.dart`)
The main service handling all notification-related operations:
- Initialize notification system
- Schedule daily notifications
- Cancel notifications
- Manage alarm times

**Key Methods:**
```dart
// Initialize the service
await NotificationService().initialize();

// Schedule a morning adhkar alarm
await NotificationService().scheduleMorningAdhkarAlarm(hour: 7, minute: 0);

// Cancel a specific alarm
await NotificationService().cancelMorningAdhkarAlarm();

// Update all alarms based on settings
await NotificationService().updateAllAlarms(
  isMorningEnabled: true,
  isEveningEnabled: false,
  isMulkEnabled: true,
  isBaqarahEnabled: true,
);
```

#### 2. `SettingsProvider` (`lib/core/providers/settings_provider.dart`)
Manages alarm settings and integrates with NotificationService:
- Toggle alarms on/off
- Set custom alarm times
- Get saved alarm times

**Usage:**
```dart
// Toggle morning alarm
settingsProvider.toggleMorningAlarm(true);

// Set custom time
await settingsProvider.setAlarmTime(
  type: 'morning',
  hour: 6,
  minute: 30,
);

// Get saved time
final time = await settingsProvider.getAlarmTime('morning');
print(time['hour']); // 6
print(time['minute']); // 30
```

#### 3. `AlarmTimePickerDialog` (`lib/features/onboarding/presentation/widgets/alarms/alarm_time_picker_dialog.dart`)
A customizable time picker dialog for setting alarm times.

#### 4. `AlarmMenuItem` (`lib/features/onboarding/presentation/widgets/alarms/alarm_menu_item.dart`)
A reusable widget for displaying alarm items with time settings in the UI.

## Default Alarm Times

| Alarm | Default Time | Arabic Name |
|-------|-------------|-------------|
| Morning Adhkar | 7:00 AM | أذكار الصباح |
| Evening Adhkar | 5:30 PM | أذكار المساء |
| Surah Al-Mulk | 9:00 PM | سورة الملك |
| Surah Al-Baqarah | 8:30 PM | سورة البقرة |

## Notification Messages

Each notification displays a meaningful Islamic message:

### Morning Adhkar
```
⏰ تذكير أذكار الصباح
حان وقت أذكار الصباح. اللهم ما أصبح بك من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك، فلك الحمد ولك الشكر
```

### Evening Adhkar
```
⏰ تذكير أذكار المساء
حان وقت أذكار المساء. أمسينا وأمسى الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له
```

### Surah Al-Mulk
```
⏰ تذكير سورة الملك
حان وقت قراءة سورة الملك. قال صلى الله عليه وسلم: "إن سورة من القرآن ثلاثون آية شفعت لرجل حتى غفر له: تبارك الذي بيده الملك"
```

### Surah Al-Baqarah
```
⏰ تذكير سورة البقرة
حان وقت قراءة سورة البقرة. قال صلى الله عليه وسلم: "اقرأوا سورة البقرة، فإن أخذها بركة وتركها حسرة ولا تستطيعها البطلة"
```

## Permissions Required

### Android
The following permissions are declared in `AndroidManifest.xml`:
```xml
<!-- Notification permission for Android 13+ -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<!-- Exact alarm scheduling -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />

<!-- Boot completion to reschedule alarms -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

<!-- Vibration for notifications -->
<uses-permission android:name="android.permission.VIBRATE" />
```

### iOS
iOS permissions are handled automatically by the flutter_local_notifications plugin:
- Alert permissions
- Badge permissions
- Sound permissions

## How to Use

### For Users

1. **Access Alarm Settings**
   - Open the app
   - Go to "المزيد" (More) menu
   - Scroll to "منبهات الأذكار" (Adhkar Alarms) or "منبهات السنن" (Sunnah Alarms)

2. **Enable/Disable Alarms**
   - Tap the switch next to any alarm to enable/disable it

3. **Set Custom Time**
   - Tap on any alarm item
   - Use the time picker to select your preferred time
   - Tap "حفظ" (Save) to confirm

4. **Notifications Will**
   - Appear at the scheduled time every day
   - Include Islamic reminders and duas
   - Continue working even when the app is closed

### For Developers

#### Adding a New Alarm Type

1. **Add to NotificationService:**
```dart
static const int _newAlarmNotificationId = 1005;
static const String _newAlarmHourKey = 'new_alarm_hour';
static const String _newAlarmMinuteKey = 'new_alarm_minute';

Future<void> scheduleNewAlarm({int? hour, int? minute}) async {
  final prefs = await SharedPreferences.getInstance();
  final h = hour ?? prefs.getInt(_newAlarmHourKey) ?? defaultHour;
  final m = minute ?? prefs.getInt(_newAlarmMinuteKey) ?? defaultMinute;

  await scheduleDailyNotification(
    id: _newAlarmNotificationId,
    title: 'New Alarm Title',
    body: 'Notification message',
    hour: h,
    minute: m,
    payload: 'new_alarm',
  );
}

Future<void> cancelNewAlarm() async {
  await cancelNotification(_newAlarmNotificationId);
}
```

2. **Add to SettingsProvider:**
```dart
static const String _newAlarmKey = 'new_alarm_enabled';
bool _isNewAlarmEnabled = false;

bool get isNewAlarmEnabled => _isNewAlarmEnabled;

void _loadSettings() {
  // ... existing code
  _isNewAlarmEnabled = prefs.getBool(_newAlarmKey) ?? false;
}

Future<void> toggleNewAlarm(bool value) async {
  _isNewAlarmEnabled = value;
  await prefs.setBool(_newAlarmKey, value);
  await _updateAllAlarms();
  notifyListeners();
}
```

3. **Update updateAllAlarms method:**
```dart
Future<void> updateAllAlarms({...}) async {
  await cancelAllNotifications();
  
  if (isMorningEnabled) await scheduleMorningAdhkarAlarm();
  if (isEveningEnabled) await scheduleEveningAdhkarAlarm();
  if (isMulkEnabled) await scheduleMulkAlarm();
  if (isBaqarahEnabled) await scheduleBaqarahAlarm();
  if (isNewEnabled) await scheduleNewAlarm(); // Add new alarm
}
```

4. **Add UI in home_screen.dart:**
```dart
AlarmMenuItem(
  title: 'اسم المنبه الجديد',
  subtitle: 'وصف المنبه',
  icon: Icons.notifications_active,
  alarmType: 'new',
  isEnabled: settingsProvider.isNewAlarmEnabled,
  onChanged: (val) => settingsProvider.toggleNewAlarm(val),
),
```

## Testing

### Manual Testing

1. **Test Alarm Toggling:**
   - Enable/disable each alarm
   - Verify settings are saved after app restart

2. **Test Time Selection:**
   - Open time picker for each alarm
   - Select different times
   - Verify times are saved correctly

3. **Test Notifications:**
   - Set an alarm for 1-2 minutes in the future
   - Wait for notification to appear
   - Verify notification content and timing

### Important Notes

- **Android 13+**: Users must grant notification permission manually
- **Exact Scheduling**: Uses `AndroidScheduleMode.exactAllowWhileIdle` for precise timing
- **Doze Mode**: Notifications will work even in Doze mode
- **Boot Persistence**: Alarms are NOT automatically rescheduled after device reboot (requires additional WorkManager implementation)

## Troubleshooting

### Notifications Not Appearing

1. **Check Permissions:**
   - Android 13+: Ensure notification permission is granted
   - Check app notification settings in system settings

2. **Check Alarm Settings:**
   - Verify the alarm is enabled
   - Verify the time is set correctly
   - Check if the scheduled time has passed

3. **Check Notification Channels:**
   - Go to Android notification settings
   - Ensure "Quran App Alarms" channel is enabled
   - Check notification importance level

### Time Zone Issues

The system uses the `timezone` package to handle local time zones correctly. If notifications appear at wrong times:

1. Verify device time zone is set correctly
2. Restart the app to reinitialize timezone data
3. Reschedule all alarms

## Dependencies

The notification system uses the following packages:

```yaml
dependencies:
  flutter_local_notifications: ^18.0.1  # Local notifications
  timezone: ^0.9.4                       # Time zone support
  shared_preferences: ^2.2.2            # Local storage
```

## Future Enhancements

Potential improvements for the notification system:

1. **Prayer Time Notifications**: Add notifications for each prayer time
2. **Custom Dhikr Reminders**: Allow users to create custom dhikr notifications
3. **Friday Reminders**: Special notifications for Jumu'ah prayers
4. **Ramadan Mode**: Enhanced notifications during Ramadan
5. **Notification Sounds**: Custom Islamic notification sounds
6. **Snooze Functionality**: Option to snooze reminders
7. **Statistics**: Track how often users respond to notifications

## Support

For issues or questions about the notification system, please refer to:
- Flutter Local Notifications documentation: https://pub.dev/packages/flutter_local_notifications
- Timezone package documentation: https://pub.dev/packages/timezone
