# 🔍 Debug Guide - لماذا لم يظهر الإشعار؟

## ❌ المشكلة السابقة

**المشكلة:**
- تم استخدام `scheduleDelayedNotification` التي تضبط إشعار بعد **دقيقة واحدة فقط**
- لكن `scheduleDailyNotification` لديها **منطقة حماية لمدة دقيقتين**
- النتيجة: الإشعار يُؤجّل لليوم التالي! 😱

```dart
// الكود القديم - خاطئ ❌
await provider.scheduleDelayedNotification(
  id: 9999,
  title: 'اختبار',
  body: 'إشعار بعد دقيقة',
);
// الدقيقة = أقل من دقيقتين = لن يظهر اليوم!
```

---

## ✅ الحل الجديد

**تم إنشاء دالة جديدة خاصة للاختبار:**

```dart
// الدالة الجديدة - صحيحة ✅
Future<void> scheduleTestAlarmAfter5Minutes({
  required int id,
  required String title,
  required String body,
}) async {
  final now = DateTime.now();
  final scheduledTime = now.add(const Duration(minutes: 5));
  
  await _notificationService.scheduleDailyNotification(
    id: id,
    title: title,
    body: body,
    hour: scheduledTime.hour,
    minute: scheduledTime.minute,
  );
}
```

**لماذا هذا يعمل؟**
- 5 دقائق > 2 دقيقة (منطقة الحماية) ✅
- الإشعار سيظهر اليوم بالتأكيد ✅

---

## 🧪 كيفية التتبع (Debug)

### **1️⃣ شغّل التطبيق مع Debug**

```bash
flutter run
```

### **2️⃣ افتح Console وراقب الرسائل**

عند الضغط على زر الاختبار، يجب أن ترى:

```
🔔 TEST ALARM SCHEDULED FOR: 2026-03-23 14:35:00.000
⏰ Current time: 2026-03-23 14:30:00.000
⏱️ Will appear in: 5 minutes
```

### **3️⃣ ابحث في Console عن:**

```
Scheduling notification 9999 for 14:35 at 2026-03-23 14:35:00.000
Current time: 2026-03-23 14:30:00.000
Two minutes from now: 2026-03-23 14:32:00.000
Will appear today: true ✅
```

**إذا رأيت `Will appear today: true`** → الإشعار سيظهر! 🎉

---

## 🔍 التحقق من الإشعارات المجدولة

### **طريقة 1: عبر التطبيق**

اضغط على الزر الدائري 🐞 ثم:
1. شاهد رسالة التأكيد
2. اقرأ الوقت المضبوط
3. انتظر 5 دقائق

### **طريقة 2: عبر الكود**

في أي مكان، أضف هذا الكود:

```dart
final pending = await NotificationService().getPendingNotifications();
print('📋 عدد الإشعارات المجدولة: ${pending.length}');

for (var notification in pending) {
  print('ID: ${notification.id}');
  print('Title: ${notification.title}');
  print('Scheduled Date: ${notification.scheduledDate}');
  print('---');
}
```

### **طريقة 3: عبر NotificationProvider**

```dart
final provider = context.read<NotificationProvider>();
provider.debugLogs.forEach(print);
```

ستظهر لك جميع العمليات:
```
[14:30:00] Test alarm scheduled for 2026-03-23 14:35:00.000 (in 5 minutes)
[14:30:00] Notification services initialized
```

---

## ⏰ متى سيظهر الإشعار بالضبط؟

### **الحساب:**

```
الوقت الحالي: 14:30
+ 5 دقائق
= 14:35 ← وقت ظهور الإشعار
```

### **تحقق من Console:**

ابحث عن:
```
Will appear today: true
```

إذا كان **true** → سيظهر اليوم  
إذا كان **false** → سيظهر غداً (مشكلة!)

---

## 🐛 المشاكل الشائعة وحلولها

### **1. الإشعار لا يظهر أبداً**

**الأسباب المحتملة:**
- ❌ صلاحيات الإشعارات غير ممنوحة
- ❌ التطبيق مغلق تماماً (Force stopped)
- ❌ الجهاز في وضع "عدم الإزعاج"
- ❌ Canal الإشعارات غير مهيأ بشكل صحيح

**الحل:**

```dart
// تحقق من الصلاحيات
final provider = context.read<NotificationProvider>();
print('Permission: ${provider.permissionStatus}');
// يجب أن تكون: authorized أو granted
```

**على الجهاز:**
1. الإعدادات → التطبيقات → Quran App
2. الإشعارات → تأكد من تفعيلها
3. أعد تشغيل التطبيق

---

### **2. الإشعار يؤجل للغد**

**السبب:**
- الوقت المضبوط أقل من دقيقتين من الوقت الحالي

**الحل:**
استخدم دائماً **5 دقائق على الأقل**:

```dart
// صحيح ✅
final scheduledTime = now.add(const Duration(minutes: 5));

// خاطئ ❌
final scheduledTime = now.add(const Duration(minutes: 1));
```

---

### **3. رسالة خطأ في Console**

**أمثلة للأخطاء:**

```
❌ ERROR scheduling test alarm: PlatformException(...)
```

**الحل:**
1. تحقق من أن `NotificationService` مهيأ بشكل صحيح
2. تأكد من وجود `AndroidManifest.xml` الصحيح
3. تحقق من الصلاحيات في `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

---

## 📊 جدول التتبع

| الوقت | ماذا تفعل | ماذا تتوقع في Console |
|-------|-----------|----------------------|
| **14:30** | اضغط زر الاختبار | `TEST ALARM SCHEDULED FOR: 14:35` |
| **14:30** | تحقق من.pending | `Pending notifications: 1` |
| **14:30** | اقرأ logs | `Will appear today: true` |
| **14:35** | راقب الجهاز | 🔔 **إشعار يظهر!** |

---

## ✅ Checklist قبل الاختبار

- [ ] التطبيق يعمل مع `flutter run`
- [ ] Console مفتوح ويراقب الرسائل
- [ ] صلاحيات الإشعارات ممنوحة
- [ ] الجهاز ليس في وضع "عدم الإزعاج"
- [ ] ضغطت على زر الاختبار بنجاح
- [ ] ظهرت رسالة `✅ تم ضبط منبه اختبار`
- [ ] Console يظهر `Will appear today: true`
- [ ] الانتظار 5 دقائق

---

## 🎯 الاختبار الناجح

**بعد 5 دقائق، يجب أن ترى:**

```
📱 على الجهاز:
┌─────────────────────────────┐
│ ⏰ منبه اختبار              │
│ هذا إشعار اختبار - تم ضبطه │
│ بعد 5 دقائق                 │
└─────────────────────────────┘
```

**وفي Console:**
```
🔔 Foreground notification shown: 9999
```

---

## 🔄 إعادة الاختبار

إذا فشل الاختبار:

1. **ألغِ جميع الإشعارات:**
```dart
await NotificationProvider().cancelAllNotifications();
```

2. **أعد تشغيل التطبيق:**
```bash
flutter run
```

3. **حاول مرة أخرى**

---

## 📞 الحصول على المساعدة

إذا استمرت المشكلة:

1. **انسخ رسائل الخطأ من Console**
2. **تحقق من Logs:**
```dart
final provider = context.read<NotificationProvider>();
provider.debugLogs.forEach((log) => print('LOG: $log'));
```

3. **شارك المعلومات:**
- الوقت الحالي
- الوقت المضبوط
- رسائل Console
- نوع الجهاز/المحاكي

---

**آخر تحديث:** 23 مارس 2026  
**الحالة:** ✅ جاهز للاختبار مع Debug كامل
