# Complete Notification System Implementation Guide

> Status note (March 23, 2026): This guide includes historical implementation details. For currently verified behavior and gaps, see `PROJECT_STATUS.md`.

## 📋 Overview

This guide covers the complete implementation of a production-ready notification system for the Quran App, including:

- ✅ Local notifications with `flutter_local_notifications`
- ✅ Push notifications with Firebase Cloud Messaging (FCM)
- ✅ Boot persistence with WorkManager
- ✅ Background message handling
- ✅ Notification routing and navigation
- ✅ Comprehensive testing UI

---

## 🎯 Features Implemented

### Local Notifications
- Scheduled daily alarms for:
  - Morning Adhkar (default: 7:00 AM)
  - Evening Adhkar (default: 5:30 PM)
  - Surah Al-Mulk (default: 9:00 PM)
  - Surah Al-Baqarah (default: 8:30 PM)
- Exact timing with timezone support
- Works in foreground, background, and terminated states
- Doze mode support (Android)

### Push Notifications (FCM)
- Foreground message handling
- Background message handling
- Terminated state handling
- Token management and refresh
- Topic subscriptions
- Custom notification payloads

### Reliability Features
- Boot persistence (alarms reschedule after device restart)
- App update handling
- Fallback mechanisms
- Duplicate prevention
- Permission management

### Navigation
- Notification tap handling
- Route to specific screens based on notification type
- Deep link support

---

## 🔧 Setup Instructions

### Prerequisites

1. **Firebase Project**: You need a Firebase project
2. **Android**: Minimum API level 21 (Android 5.0)
3. **iOS**: Minimum iOS version 12.0

---

### Step 1: Firebase Project Setup

#### 1.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select existing project
3. Follow the setup wizard
4. Enable Cloud Messaging:
   - Go to Project Settings → Cloud Messaging
   - Enable Firebase Cloud Messaging API

#### 1.2 Add Android App to Firebase

1. In Firebase Console, click "Add app" → Android
2. Enter package name: `com.example.quran_app`
3. Download `google-services.json`
4. Place file at: `android/app/google-services.json`

**Important**: The file MUST be named exactly `google-services.json`

#### 1.3 Add iOS App to Firebase

1. In Firebase Console, click "Add app" → iOS
2. Enter bundle ID (check in Xcode → Runner → Signing & Capabilities)
3. Download `GoogleService-Info.plist`
4. Place file at: `ios/Runner/GoogleService-Info.plist`

---

### Step 2: Android Configuration

#### 2.1 Build Configuration

Files already configured:
- ✅ `android/build.gradle.kts` - Added Google Services classpath
- ✅ `android/app/build.gradle.kts` - Added Google Services plugin
- ✅ `pubspec.yaml` - Added dependencies

#### 2.2 Permissions (Already Added)

The following permissions are declared in `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Notification permissions for Android 13+ -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<!-- Alarm permissions for exact scheduling -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />

<!-- Boot permission to reschedule alarms -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

<!-- Background processing -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

#### 2.3 Boot Receiver

File created: `android/app/src/main/kotlin/com/example/quran_app/BootReceiver.kt`

This receiver handles:
- Device boot completion
- Quick boot (some devices)
- App updates

---

### Step 3: iOS Configuration

#### 3.1 Info.plist Updates

Already added to `ios/Runner/Info.plist`:

```xml
<!-- Background Modes for Firebase Messaging -->
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>

<!-- Firebase Configuration -->
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

#### 3.2 Podfile Configuration

Run these commands:

```bash
cd ios
pod install
```

---

### Step 4: Run Flutter Dependencies

```bash
flutter pub get
```

---

## 📱 Usage Guide

### For Users

#### Setting Up Alarms

1. Open the app
2. Go to Settings or Alarm section
3. Enable/disable specific alarms
4. Set custom times for each alarm
5. Alarms will trigger daily at the specified time

#### Notification Types

When you receive a notification:

- **Morning Adhkar** → Opens Duas screen with morning adhkar
- **Evening Adhkar** → Opens Duas screen with evening adhkar
- **Surah Al-Mulk** → Opens Quran to Surah 67
- **Surah Al-Baqarah** → Opens Quran to Surah 2
- **General** → Opens home screen

---

### For Developers

#### Sending Push Notifications

##### Via Firebase Console

1. Go to Firebase Console → Cloud Messaging
2. Click "New notification"
3. Enter title and body
4. Target:
   - Send to all users, OR
   - Send to topic (e.g., `all_users`, `daily_reminders`)
5. Add custom data payload:
   ```json
   {
     "type": "morning_adhkar",
     "additional_data": "value"
   }
   ```
6. Click "Send"

##### Via API

```http
POST https://fcm.googleapis.com/fcm/send
Authorization: key=YOUR_SERVER_KEY
Content-Type: application/json

{
  "to": "DEVICE_FCM_TOKEN",
  "notification": {
    "title": "Test Notification",
    "body": "This is a test"
  },
  "data": {
    "type": "general"
  }
}
```

**Get Server Key:**
- Firebase Console → Project Settings → Cloud Messaging
- Copy "Server key"

---

#### Accessing Notification Services

```dart
import 'package:quran_app/core/services/notification_service.dart';
import 'package:quran_app/core/services/firebase_messaging_service.dart';
import 'package:quran_app/core/providers/notification_provider.dart';

// Show immediate notification
await NotificationService().showNotification(
  id: 1,
  title: 'Title',
  body: 'Body',
  payload: 'type',
);

// Schedule daily notification
await NotificationService().scheduleDailyNotification(
  id: 2,
  title: 'Daily Reminder',
  body: 'This appears daily',
  hour: 9,
  minute: 0,
);

// Get FCM token
final token = await FirebaseMessagingService().getToken();

// Subscribe to topic
await FirebaseMessagingService().subscribeToTopic('all_users');

// Cancel notification
await NotificationService().cancelNotification(1);

// Cancel all
await NotificationService().cancelAllNotifications();
```

---

#### Using Notification Provider

```dart
// In your widget
final notificationProvider = context.read<NotificationProvider>();

// Initialize
await notificationProvider.initialize();

// Request permissions
await notificationProvider.requestPermissions();

// Get pending notifications
final pending = await notificationProvider.getPendingNotifications();

// Refresh FCM token
await notificationProvider.refreshFCMToken();

// Listen to changes
notificationProvider.addListener(() {
  print('Permission status: ${notificationProvider.permissionStatus}');
  print('FCM Token: ${notificationProvider.fcmToken}');
});
```

---

## 🧪 Testing Guide

### Manual Test Scenarios

#### Test 1: Immediate Notification
```dart
await NotificationService().testNotification(
  id: 9999,
  title: 'Test',
  body: 'Immediate notification',
);
```

Expected: Notification appears immediately

#### Test 2: Scheduled Notification
Schedule for 1-2 minutes in the future and wait.

Expected: Notification appears at scheduled time

#### Test 3: Daily Repeating
Set alarm time and wait for next occurrence.

Expected: Notification appears daily at set time

#### Test 4: FCM Push (Foreground)
Send push notification while app is open.

Expected: 
- Notification appears
- Console shows: "Foreground message received"

#### Test 5: FCM Push (Background)
Send push notification, then minimize app.

Expected:
- Notification appears in status bar
- Tap opens app

#### Test 6: FCM Push (Terminated)
Force close app, then send push notification.

Expected:
- Notification appears in status bar
- Tap launches app

#### Test 7: Notification Tap Navigation
Tap different notification types.

Expected:
- Navigates to correct screen
- Payload data passed correctly

#### Test 8: Boot Persistence (Real Device Only)
1. Schedule alarms
2. Restart device
3. Open app

Expected: Alarms still scheduled

#### Test 9: Permission Request
Call `requestPermissions()` on fresh install.

Expected:
- Android 13+: Shows permission dialog
- iOS: Shows permission dialog

#### Test 10: No Duplicates
Schedule same notification multiple times.

Expected: Only one instance scheduled

---

### Debug Commands

#### Check Pending Notifications
```dart
final pending = await NotificationService().getPendingNotifications();
print('Pending: ${pending.length}');
```

#### Check Permission Status
```dart
final settings = await FirebaseMessaging.instance.getNotificationSettings();
print('Authorization: ${settings.authorizationStatus}');
```

#### Check FCM Token
```dart
final token = await FirebaseMessaging.instance.getToken();
print('FCM Token: $token');
```

#### ADB Commands (Android)

Check permissions:
```bash
adb shell dumpsys package com.example.quran_app | grep -A 5 "permission"
```

Force stop and clear data:
```bash
adb shell am force-stop com.example.quran_app
adb shell pm clear com.example.quran_app
```

Test boot broadcast:
```bash
adb shell am broadcast -a android.intent.action.BOOT_COMPLETED
```

---

## 🐛 Troubleshooting

### Issue 1: Notifications Not Appearing

**Symptoms:**
- No notifications show up
- Scheduling returns success

**Solutions:**

1. **Check Permissions** (Android 13+)
   ```dart
   final settings = await FirebaseMessagingService().getNotificationSettings();
   print(settings.authorizationStatus); // Should be 'authorized'
   ```

2. **Check Notification Channel**
   - Go to Settings → Apps → Quran App → Notifications
   - Ensure channels are enabled

3. **Grant Permission Manually** (Android)
   ```bash
   adb shell pm grant com.example.quran_app android.permission.POST_NOTIFICATIONS
   ```

4. **Check Doze Mode**
   ```bash
   adb shell dumpsys deviceidle
   ```
   If in Doze, notifications may be delayed

---

### Issue 2: FCM Token Not Generating

**Symptoms:**
- `getToken()` returns null
- No token in logs

**Solutions:**

1. **Verify google-services.json**
   - File exists at `android/app/google-services.json`
   - Package name matches
   - File is properly formatted

2. **Check Firebase Configuration**
   - Cloud Messaging API is enabled
   - SHA-1 certificate fingerprint added (for release builds)

3. **Restart App**
   - Force stop and reopen

4. **Check Internet Connection**
   - FCM requires network connectivity

---

### Issue 3: Boot Persistence Not Working

**Symptoms:**
- Alarms lost after device restart

**Solutions:**

1. **Verify BootReceiver Registration**
   - Check `AndroidManifest.xml` has receiver declaration
   - Intent filter includes `BOOT_COMPLETED`

2. **Check WorkManager Initialization**
   - Look for logs: "WorkManager initialized successfully"
   - Verify periodic task registered

3. **Test on Real Device**
   - Emulators don't always simulate boot correctly

---

### Issue 4: Wrong Notification Time

**Symptoms:**
- Notification triggers at wrong hour
- Timezone issues

**Solutions:**

1. **Timezone Data Initialization**
   ```dart
   tz.initializeTimeZones(); // Already called in initialize()
   ```

2. **Use Absolute Time Scheduling**
   - Already implemented using `dateAndTime` matching

3. **Check Device Timezone**
   - Ensure device timezone is set correctly

---

### Issue 5: Duplicate Notifications

**Symptoms:**
- Same notification appears multiple times

**Solutions:**

1. **Cancel Before Reschedule**
   ```dart
   await cancelNotification(id);
   await scheduleDailyNotification(...);
   ```

2. **Use Unique IDs**
   - Each notification type has unique ID
   - Don't reuse IDs

---

## 📊 API Reference

### NotificationService

```dart
// Initialize service
await NotificationService().initialize();

// Show immediate notification
Future<void> showNotification({
  required int id,
  required String title,
  required String body,
  String? payload,
});

// Schedule daily notification
Future<void> scheduleDailyNotification({
  required int id,
  required String title,
  required String body,
  required int hour,
  required int minute,
  String? payload,
});

// Cancel specific notification
Future<void> cancelNotification(int id);

// Cancel all notifications
Future<void> cancelAllNotifications();

// Get pending notifications
Future<List<PendingNotificationRequest>> getPendingNotifications();

// Test notification
Future<void> testNotification({
  required int id,
  required String title,
  required String body,
});

// Update all alarms
Future<void> updateAllAlarms({
  required bool isMorningEnabled,
  required bool isEveningEnabled,
  required bool isMulkEnabled,
  required bool isBaqarahEnabled,
});
```

---

### FirebaseMessagingService

```dart
// Initialize service
await FirebaseMessagingService().initialize();

// Get FCM token
Future<String?> getToken();

// Refresh token
Future<void> refreshToken();

// Subscribe to topic
Future<void> subscribeToTopic(String topic);

// Unsubscribe from topic
Future<void> unsubscribeFromTopic(String topic);

// Get notification settings
Future<NotificationSettings> getNotificationSettings();

// Delete token (logout)
Future<void> deleteToken();

// Set notification tap callback
FirebaseMessagingService().onNotificationTap = (type, data) {
  // Handle tap
};
```

---

### WorkManagerService

```dart
// Initialize service
await WorkManagerService().initialize();

// Register periodic reschedule task
Future<void> registerRescheduleTask();

// Cancel reschedule task
Future<void> cancelRescheduleTask();

// Cancel all tasks
Future<void> cancelAllTasks();
```

---

### NotificationProvider

```dart
// Initialize
await NotificationProvider(prefs: prefs).initialize();

// Request permissions
Future<void> requestPermissions();

// Get FCM token
String? get fcmToken;

// Get permission status
String? get permissionStatus;

// Get pending notifications
List<Map<String, dynamic>> get pendingNotifications;

// Get debug logs
List<String> get debugLogs;

// Schedule test notification
Future<void> scheduleTestNotification({...});

// Cancel notification
Future<void> cancelNotification(int id);

// Refresh FCM token
Future<void> refreshFCMToken();

// Reschedule all alarms
Future<void> rescheduleAllAlarms();
```

---

## 🎨 Architecture

### File Structure

```
lib/
├── core/
│   ├── services/
│   │   ├── notification_service.dart      # Local notifications
│   │   ├── firebase_messaging_service.dart # FCM
│   │   └── workmanager_service.dart        # Background tasks
│   ├── providers/
│   │   └── notification_provider.dart      # State management
│   └── navigation/
│       └── notification_router.dart        # Tap handling
└── main.dart                               # App entry point

android/
├── app/
│   ├── src/main/
│   │   ├── AndroidManifest.xml             # Permissions
│   │   └── kotlin/.../BootReceiver.kt      # Boot handler
│   ├── build.gradle.kts                    # App build config
│   └── google-services.json                # Firebase config
└── build.gradle.kts                        # Project build config

ios/
└── Runner/
    ├── Info.plist                          # iOS configuration
    └── GoogleService-Info.plist            # Firebase config
```

---

## 🔒 Best Practices

### Performance

1. **Initialize Once**
   - Services are singletons
   - Call `initialize()` only once at app start

2. **Avoid Duplicate Scheduling**
   - Cancel before rescheduling
   - Check if already scheduled

3. **Use WorkManager Sparingly**
   - Don't schedule too many periodic tasks
   - Use minimum frequency needed

### Battery Optimization

1. **Exact Alarms**
   - Use `exactAllowWhileIdle` for precision
   - But respect user's battery preferences

2. **Background Processing**
   - Keep background handlers minimal
   - Return quickly

3. **Network Usage**
   - FCM is push-based (efficient)
   - Avoid polling

### User Experience

1. **Permission Timing**
   - Request permissions when user expects it
   - Explain why you need permission

2. **Notification Frequency**
   - Don't spam users
   - Allow easy opt-out

3. **Clear Purpose**
   - Each notification should have value
   - Use meaningful titles and bodies

---

## 📝 Maintenance

### Regular Checks

1. **Monitor FCM Delivery**
   - Use Firebase Analytics
   - Track open rates

2. **Update Dependencies**
   ```bash
   flutter pub upgrade
   ```

3. **Test on New OS Versions**
   - Android beta releases
   - iOS beta releases

### Logs to Monitor

```
✅ Notification Service initialized
✅ Firebase Messaging Service initialized
✅ WorkManager initialized
📅 Scheduled notification
🔔 Notification tapped
🔄 FCM Token refreshed
```

---

## 🆘 Support Resources

### Documentation Links

- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [Firebase Messaging](https://firebase.google.com/docs/cloud-messaging)
- [WorkManager](https://pub.dev/packages/workmanager)
- [Timezone Package](https://pub.dev/packages/timezone)

### Common Error Messages

| Error | Solution |
|-------|----------|
| "Missing google-services.json" | Add file to android/app/ |
| "Permission denied" | Request runtime permission |
| "Channel not found" | Create notification channel first |
| "Token not generated" | Check Firebase config |

---

## ✅ Testing Checklist

Before deploying to production:

- [ ] All 4 alarms can be scheduled
- [ ] Alarms trigger at exact time
- [ ] FCM push works in foreground
- [ ] FCM push works in background
- [ ] FCM push works from terminated
- [ ] Notification taps navigate correctly
- [ ] Permissions requested properly
- [ ] Boot persistence works (real device)
- [ ] No duplicate notifications
- [ ] Works in Doze mode
- [ ] iOS notifications work
- [ ] Android notifications work

---

## 🎉 Success Indicators

Your notification system is working correctly when:

1. ✅ Console shows initialization success messages
2. ✅ Test notifications appear immediately
3. ✅ Scheduled notifications trigger on time
4. ✅ Push notifications received in all states
5. ✅ Tapping notifications navigates correctly
6. ✅ Alarms persist after reboot
7. ✅ No crashes or errors in logs

---

**Last Updated:** March 23, 2026  
**Version:** 1.0.0
