# Notification Testing Guide

## Quick Test Steps

### Test 1: Morning Adhkar Alarm (Fast Test)

1. **Open the app** on your emulator/device
2. **Go to "المزيد" (More) menu**
3. **Scroll to "منبهات الأذكار" section**
4. **Enable "منبه أذكار الصباح"** (Morning Adhkar)
5. **Wait for notification** at 7:00 AM (or set custom time)

### Test 2: Custom Time Test (RECOMMENDED - Fastest)

To test immediately without waiting:

#### Option A: Using Developer Options (Android Emulator)
1. Open emulator
2. Go to emulator Settings → System → Date & time
3. **Change time to 6:59 AM**
4. Enable Morning Adhkar alarm
5. **Wait 1 minute** until it becomes 7:00 AM
6. **Notification should appear!**

#### Option B: Manual Time Change
1. Pull down notification shade on emulator
2. Look for notification with:
   - Title: "⏰ تذكير أذكار الصباح"
   - Body: "حان وقت أذكار الصباح. اللهم ما أصبح بك من نعمة..."

---

## Detailed Testing Checklist

### ✅ **Test 1: Basic Notification Permission**

**Steps:**
1. Launch app: `flutter run`
2. Check if notification permission is requested (Android 13+)
3. Grant permission if asked

**Expected Result:**
- Permission dialog appears
- App continues to work normally

---

### ✅ **Test 2: Toggle Alarms**

**Steps:**
1. Open More menu
2. Enable "منبه أذكار الصباح"
3. Close and reopen More menu
4. Check if switch remains ON

**Expected Result:**
- Switch stays ON after reopening
- Setting is saved in SharedPreferences

---

### ✅ **Test 3: Multiple Alarms**

**Steps:**
1. Enable ALL 4 alarms:
   - ☀️ Morning Adhkar (7:00 AM)
   - 🌙 Evening Adhkar (5:30 PM)
   - 📖 Surah Al-Mulk (9:00 PM)
   - 📿 Surah Al-Baqarah (8:30 PM)
2. Close app completely
3. Reopen app
4. Check if all alarms are still enabled

**Expected Result:**
- All 4 alarms remain enabled
- No errors in console

---

### ✅ **Test 4: Notification Timing (Using Emulator Time)**

**Prerequisites:**
- Android Emulator running
- App installed and running

**Steps:**
1. **Check current emulator time** (pull down notification shade)
2. **Calculate next alarm time**:
   - If current time is before 7:00 AM → Test Morning Adhkar
   - If current time is before 5:30 PM → Test Evening Adhkar
   - etc.

3. **Enable the corresponding alarm** in More menu
4. **Change emulator time** to 1 minute before alarm time
5. **Wait 1 minute**
6. **Watch for notification**

**Example:**
```
Current emulator time: 6:58 AM
→ Enable "Morning Adhkar" alarm
→ Change emulator time to: 6:59 AM
→ Wait until: 7:00 AM
→ Notification appears! ✓
```

**Expected Result:**
- Notification appears at exact time
- Title: "⏰ تذكير أذكار الصباح" (or respective title)
- Body contains Islamic message
- Sound plays (if not on silent)

---

### ✅ **Test 5: Notification Content Verification**

When notification appears, verify:

**For Morning Adhkar:**
- ✅ Title: "⏰ تذكير أذكار الصباح"
- ✅ Body: "حان وقت أذكار الصباح. اللهم ما أصبح بك من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك، فلك الحمد ولك الشكر"

**For Evening Adhkar:**
- ✅ Title: "⏰ تذكير أذكار المساء"
- ✅ Body: "حان وقت أذكار المساء. أمسينا وأمسى الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له"

**For Surah Al-Mulk:**
- ✅ Title: "⏰ تذكير سورة الملك"
- ✅ Body: Contains hadith about Surah Al-Mulk

**For Surah Al-Baqarah:**
- ✅ Title: "⏰ تذكير سورة البقرة"
- ✅ Body: Contains hadith about Surah Al-Baqarah

---

### ✅ **Test 6: Alarm Persistence After Restart**

**Steps:**
1. Enable all 4 alarms
2. **Close app completely** (swipe away from recent apps)
3. **Reopen app**
4. Go to More menu
5. Check if alarms are still enabled

**Expected Result:**
- All alarms remain enabled
- No need to re-enable

---

### ✅ **Test 7: Disable Alarm**

**Steps:**
1. Enable an alarm (e.g., Morning Adhkar)
2. **Disable it** by toggling switch OFF
3. Change emulator time to alarm time
4. Wait

**Expected Result:**
- ❌ NO notification appears
- Alarm was successfully cancelled

---

### ✅ **Test 8: Background Notification**

**Steps:**
1. Enable Morning Adhkar alarm
2. **Press Home button** (don't close app, just minimize)
3. Change emulator time to 7:00 AM
4. Wait

**Expected Result:**
- ✅ Notification appears even when app is in background
- Notification shows in status bar

---

### ✅ **Test 9: Lock Screen Notification**

**Steps:**
1. Enable an alarm
2. **Lock the emulator screen** (press power button)
3. Wait for alarm time
4. **Wake up screen**

**Expected Result:**
- ✅ Notification visible on lock screen
- Can tap to dismiss

---

## 🔧 **Debugging Tips**

### If Notifications Don't Appear:

#### Check 1: Console Logs
Run app in debug mode and look for:
```
flutter: Notification Service initialized successfully
flutter: Scheduled daily notification 1001 at 07:00
flutter: Updated all alarms...
```

#### Check 2: Android Permissions
```bash
# In terminal, check if permissions are granted
adb shell dumpsys package com.example.quran_app | grep -A 20 "granted=true"
```

Look for:
- `android.permission.POST_NOTIFICATIONS`
- `android.permission.SCHEDULE_EXACT_ALARM`

#### Check 3: Notification Channel
1. Open emulator Settings → Apps → Quran App → Notifications
2. Check if channels exist:
   - "Quran App Notifications"
   - "Quran App Alarms"
3. Ensure both are **enabled**

#### Check 4: Force Notification Permission (Android 13+)
```bash
adb shell pm grant com.example.quran_app android.permission.POST_NOTIFICATIONS
```

---

## 🎯 **Quick Automated Test Script**

Create a test file to verify notification scheduling:

```dart
// test/notification_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Notification service initializes correctly', () async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    
    final service = NotificationService();
    await service.initialize();
    
    expect(service, isNotNull);
  });

  test('Alarm times are saved correctly', () async {
    SharedPreferences.setMockInitialValues({});
    final service = NotificationService();
    
    await service.saveAlarmTime(
      type: 'morning',
      hour: 7,
      minute: 30,
    );
    
    final time = await service.getAlarmTime('morning');
    expect(time['hour'], equals(7));
    expect(time['minute'], equals(30));
  });
}
```

Run with:
```bash
flutter test test/notification_test.dart
```

---

## 📱 **Emulator Time Change Instructions**

### For Android Studio Emulator:

**Method 1: ADB Command (Easiest)**
```bash
# Set time to 7:00 AM
adb shell date mmddHHMMyyyy

# Example: Set to Dec 21, 07:00 AM, 2024
adb shell date 122107002024
```

**Method 2: UI Method**
1. Open emulator Settings
2. Go to System → Date & time
3. Turn OFF "Use network-provided time"
4. Tap "Time" and set manually

**Method 3: Extended Controls**
1. Click **⋮** (three dots) in emulator toolbar
2. Go to **Location** tab
3. Some emulators allow time change here

---

## ✅ **Success Criteria**

Your notification system is working correctly if:

1. ✅ App launches without errors
2. ✅ Notification permission granted (Android 13+)
3. ✅ Alarms can be enabled/disabled
4. ✅ Settings persist after app restart
5. ✅ Notifications appear at scheduled times
6. ✅ Notifications show correct Arabic text
7. ✅ Notifications work in background
8. ✅ Notifications appear on lock screen
9. ✅ Disabling alarms prevents notifications
10. ✅ Multiple alarms can be active simultaneously

---

## 🐛 **Common Issues & Solutions**

### Issue 1: "No notification appears"
**Solution:** 
- Check Android version (13+ needs manual permission)
- Grant permission: Settings → Apps → Quran App → Permissions → Notifications
- Or use ADB: `adb shell pm grant com.example.quran_app android.permission.POST_NOTIFICATIONS`

### Issue 2: "Notification appears but wrong time"
**Solution:**
- Verify emulator timezone is set correctly
- Re-schedule alarms after timezone change
- Check if using 24-hour vs 12-hour format correctly

### Issue 3: "App crashes on launch"
**Solution:**
- Check build.gradle.kts has desugaring enabled
- Verify all dependencies in pubspec.yaml
- Run `flutter clean && flutter pub get`

### Issue 4: "Notifications don't save"
**Solution:**
- Check SharedPreferences initialization in main.dart
- Verify SettingsProvider is properly injected
- Look for async/await issues in toggle methods

---

## 📊 **Test Results Template**

Use this template to track your tests:

```
Date: [Today's Date]
Device: [Emulator/Physical Device]
Android Version: [XX]

Test Results:
✓ Test 1: Basic Permission - PASS/FAIL
✓ Test 2: Toggle Alarms - PASS/FAIL
✓ Test 3: Multiple Alarms - PASS/FAIL
✓ Test 4: Notification Timing - PASS/FAIL
✓ Test 5: Content Verification - PASS/FAIL
✓ Test 6: Persistence - PASS/FAIL
✓ Test 7: Disable Alarm - PASS/FAIL
✓ Test 8: Background - PASS/FAIL
✓ Test 9: Lock Screen - PASS/FAIL

Notes:
[Any observations or issues found]
```

---

## 🎉 **Final Verification**

After all tests pass:

1. **Take screenshots** of notifications
2. **Record console logs** showing successful scheduling
3. **Verify Arabic text** displays correctly
4. **Test on physical device** (not just emulator)
5. **Test both light and dark mode**

Congratulations! Your notification system is fully functional! 🎊
