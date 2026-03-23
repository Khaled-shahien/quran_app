# اختبار الإشعارات السريع - Quick Notification Test

## 🚀 خطوات الاختبار

### **1️⃣ شغّل التطبيق مع debug**

```bash
flutter run
```

### **2️⃣ افتح الكونسول وراقب الرسائل**

### **3️⃣ غيّر وقت منبه**

مثال:
- الوقت الحالي: 10:00
- غيّر المنبه إلى: 10:05 (بعد 5 دقائق)

### **4️⃣ ابحث في الكونسول عن:**

```
✅ Setting morning alarm to 10:05
✅ Cancelled all notifications
✅ Saved alarm time to preferences
✅ Scheduling notification 1001 for 10:05 at 2024-12-21 10:05:00.000
✅ Current time: 2024-12-21 10:00:00.000
✅ Two minutes from now: 2024-12-21 10:02:00.000
✅ Will appear today: true
✅ Scheduled morning adhkar alarm
✅ Alarm time set completed
```

---

## 📊 ماذا تعني الرسائل؟

| الرسالة | المعنى |
|---------|--------|
| `Setting...` | بدأ تغيير الوقت ✅ |
| `Cancelled all notifications` | ألغى الإشعارات القديمة ✅ |
| `Saved alarm time` | حفظ الوقت الجديد ✅ |
| `Scheduling notification...` | يجهز الإشعار ✅ |
| `Will appear today: true` | **سيظهر اليوم!** ✅ |
| `Scheduled... alarm` | تم بنجاح ✅ |

---

## ⏰ متى سيظهر الإشعار؟

### **إذا رأيت:**
```
Will appear today: true
```
**→** انتظر حتى الوقت المضبوط، سيظهر الإشعار! ✅

### **إذا رأيت:**
```
Will appear today: false
```
**→** لن يظهر اليوم، سيظهر غداً في نفس الوقت ❌

---

## 🎯 مثال عملي

### **السيناريو:**
```
الوقت الآن: 10:00 صباحاً
غيّرت المنبه إلى: 10:05 صباحاً
```

### **في الكونسول:**
```dart
// ... رسائل الإعداد ...
Current time: 2024-12-21 10:00:00.000
Two minutes from now: 2024-12-21 10:02:00.000
Will appear today: true ✅  // ← هذه أهم رسالة!
// ... باقي الرسائل ...
```

### **النتيجة:**
- ✅ سيظهر الإشعار بعد 5 دقائق (في 10:05)

---

## ❗ إذا لم تظهر أي رسائل debug

**المشكلة:** الكود لا يعمل أساساً

**الحل:**
1. تأكد أن التطبيق يعمل
2. تأكد أنك في الـ More menu
3. تأكد أن الضغط على زر الساعة يفتح dialog

---

## 🔍 إذا كانت الرسائل تظهر لكن لا إشعار

### **تحقق من:**

#### **1. الصلاحيات:**
```bash
adb shell pm grant com.example.quran_app android.permission.POST_NOTIFICATIONS
```

#### **2. قنوات الإشعار:**
- Settings → Apps → Quran App → Notifications
- تأكد أن القنوات مفعلة

#### **3. الصوت:**
- تأكد أن الجهاز ليس صامت
- رفع volume

#### **4. اختبر إشعار عادي:**
```dart
// أضف هذا الزر مؤقتاً للتجربة
ElevatedButton(
  onPressed: () async {
    await NotificationService().showNotification(
      id: 9999,
      title: 'اختبار',
      body: 'إذا وصلك هذا فالنظام يعمل',
    );
  },
  child: Text('اختبر الإشعارات'),
)
```

---

## 📋 Checklist سريع

عند تغيير المنبه، تحقق من:

- [ ] ظهرت رسائل debug في الكونسول
- [ ] رسالة `Will appear today: true`
- [ ] الوقت المضبوط أبعد من دقيقتين
- [ ] الصلاحيات ممنوحة
- [ ] القنوات مفعلة
- [ ] الجهاز ليس صامت

---

## 💡 نصيحة ذهبية

**أهم رسالة في الكونسول:**
```
Will appear today: [true/false]
```

**إذا كانت `true`:**
- ✅ الكود يعمل بشكل صحيح
- انتظر حتى الوقت المضبوط

**إذا كانت `false`:**
- ❌ الوقت قريب جداً (أقل من دقيقتين)
- غيّر المنبه لوقت أبعد (3+ دقائق)

---

**جرّب الآن وراقب الكونسول!** 🎯
