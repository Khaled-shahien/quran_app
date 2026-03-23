# تغيير وقت المنبهات - Alarm Time Customization

## ✅ الميزات الجديدة / New Features

### **إمكانية تغيير وقت كل منبه**
الآن يمكنك تغيير وقت أي منبه إلى الوقت الذي تريده بسهولة!

**Now you can change any alarm time to your preferred time easily!**

---

## 📱 كيفية الاستخدام / How to Use

### **1. افتح قائمة "المزيد" / Open More Menu**
- اضغط على أيقونة القائمة ☰
- Tap the menu icon (☰)

### **2. ابحث عن قسم المنبهات / Find Alarm Section**
ستجد قسمين:
You'll find two sections:

**أ) منبهات الأذكار / Adhkar Alarms:**
- ☀️ منبه أذكار الصباح (Morning Adhkar)
- 🌙 منبه أذكار المساء (Evening Adhkar)

**ب) منبهات السنن / Sunnah Alarms:**
- 📖 منبه سورة الملك (Surah Al-Mulk)
- 📿 منبه سورة البقرة (Surah Al-Baqarah)

### **3. غيّر الوقت / Change Time**

لكل منبه، ستجد:
For each alarm, you'll see:

```
[أيقونة] [اسم المنبه]     [الوقت الحالي] [🕐] [مفتاح التشغيل]
 [Icon]  [Alarm Name]    [Current Time] [🕐]   [Switch]
```

**الخطوات / Steps:**
1. **اضغط على أيقونة الساعة** 🕐 بجانب المنبه
   **Tap the clock icon** 🕐 next to the alarm

2. **ستظهر نافذة اختيار الوقت**
   **A time picker dialog will appear**

3. **اختر الوقت الجديد** باستخدام عجلات التمرير
   **Select new time** using scroll wheels

4. **اضغط OK للتأكيد**
   **Tap OK to confirm**

5. **سيتم حفظ الوقت فوراً** وسترى رسالة تأكيد
   **Time saves immediately** and you'll see confirmation message

---

## ⏰ الأوقات الافتراضية / Default Times

| المنبه / Alarm | الوقت الافتراضي / Default Time |
|----------------|--------------------------------|
| ☀️ أذكار الصباح / Morning Adhkar | 7:00 ص / AM |
| 🌙 أذكار المساء / Evening Adhkar | 5:30 م / PM |
| 📖 سورة الملك / Surah Al-Mulk | 9:00 م / PM |
| 📿 سورة البقرة / Surah Al-Baqarah | 8:30 م / PM |

---

## 💡 نصائح سريعة / Quick Tips

### **مثال عمالي / Practical Example:**

**لتغيير منبه الفجر من 7:00 إلى 6:30 صباحاً:**
**To change Fajr alarm from 7:00 to 6:30 AM:**

1. افتح قائمة "المزيد" / Open More menu
2. ابحث عن "منبه أذكار الصباح" / Find "Morning Adhkar"
3. اضغط 🕐 / Tap 🕐
4. اختر 06:30 / Select 06:30
5. اضغط OK / Tap OK
6. ✅ جاهز! / Done!

**الرسالة التي ستظهرها:**
**Message you'll see:**
```
"تم تغيير وقت منبه أذكار الصباح إلى 06:30 ص"
"Morning Adhkar time changed to 06:30 AM"
```

---

## 🎨 التصميم / UI Design

### **عناصر التحكم / Control Elements:**

كل منبه يحتوي على:
Each alarm contains:

1. **أيقونة المنبه** - توضح نوع المنبه
   **Alarm Icon** - Shows alarm type

2. **الاسم** - اسم المنبه بالعربية
   **Name** - Alarm name in Arabic

3. **الوقت الحالي** - يعرض الوقت المضبوط حالياً
   **Current Time** - Shows currently set time

4. **زر الساعة** 🕐 - لفتح منتقي الوقت
   **Clock Button** 🕐 - Opens time picker

5. **مفتاح التشغيل/الإيقاف** - لتفعيل أو تعطيل المنبه
   **On/Off Switch** - Enable/disable alarm

---

## 🔧 كيف يعمل / How It Works

### **عند تغيير الوقت:**
**When you change time:**

1. يفتح منتقي الوقت (Time Picker Dialog)
2. تختار الوقت الجديد
3. يُحفظ الوقت في SharedPreferences
4. يُعاد جدولة المنبه بالوقت الجديد
5. تظهر رسالة تأكيد

**Technical Flow:**
1. Time picker opens
2. User selects new time
3. Time saved to SharedPreferences
4. Alarm rescheduled with new time
5. Confirmation snackbar shows

---

## ✨ المزايا / Features

### **1. حفظ تلقائي / Auto-Save**
- الأوقات تُحفظ فوراً بدون زر "حفظ"
- Times save instantly without "Save" button

### **2. تحديث فوري / Real-time Update**
- الوقت المعروض يتحديث فوراً بعد التغيير
- Displayed time updates immediately

### **3. تنسيق 12 ساعة / 12-Hour Format**
- العرض بصيغة: 07:00 ص / 05:30 م
- Display format: 07:00 AM / 05:30 PM

### **4. رسائل عربية / Arabic Messages**
- جميع رسائل التأكيد بالعربية
- All confirmation messages in Arabic

### **5. يعمل مع السمة الداكنة / Dark Mode Support**
- التصميم يعمل بشكل جميل مع Light & Dark themes
- Design works beautifully with both themes

---

## 🧪 اختبار سريع / Quick Test

### **جرّب الآن / Try Now:**

1. **شغّل التطبيق** / **Run the app**
   ```bash
   flutter run
   ```

2. **افتح "المزيد"** / **Open More menu**

3. **اضغط 🕐 على أي منبه** / **Tap 🕐 on any alarm**

4. **غيّر الوقت** / **Change the time**

5. **شاهد الرسالة!** / **See the message!**

---

## 📊 مقارنة قبل/بعد / Before/After Comparison

### **قبل / Before:**
- ❌ وقت ثابت فقط (Static time only)
- ❌ لا يمكن تغييره (Cannot be changed)
- ❌ مجرد عرض للوقت (Just time display)

### **بعد / After:**
- ✅ وقت قابل للتغيير (Customizable time)
- ✅ سهولة التعديل (Easy to modify)
- ✅ زر مخصص للوقت (Dedicated time button)
- ✅ حفظ تلقائي (Auto-save)
- ✅ رسائل تأكيد (Confirmation messages)

---

## 🎯 ملخص سريع / Quick Summary

**بالعربي:**
الآن يمكنك تغيير وقت أي منبه بسهولة! فقط اضغط على أيقونة الساعة 🕐، اختر الوقت الجديد، وسيتم حفظه فوراً. كل المنبهات تدعم التغيير: أذكار الصباح، أذكار المساء، سورة الملك، وسورة البقرة.

**In English:**
You can now change any alarm time easily! Just tap the clock icon 🕐, select new time, and it saves automatically. All alarms support customization: Morning Adhkar, Evening Adhkar, Surah Al-Mulk, and Surah Al-Baqarah.

---

## 📸 شرح مصور / Visual Guide

### **تخطيط الشاشة / Screen Layout:**

```
┌─────────────────────────────────────┐
│  منبهات الأذكار                     │
│  Adhkar Alarms                      │
├─────────────────────────────────────┤
│ ☀️  منبه أذكار الصباح    07:00 ص 🕐 [ON] │
│     Morning Adhkar                  │
├─────────────────────────────────────┤
│ 🌙  منبه أذكار المساء    05:30 م 🕐 [OFF]│
│     Evening Adhkar                  │
└─────────────────────────────────────┘
```

**عند الضغط على 🕐:**
**When tapping 🕐:**

```
┌─────────────────────┐
│  منبه أذكار الصباح  │
│  Morning Adhkar     │
├─────────────────────┤
│      hour   minute  │
│        ↑      ↑     │
│       06     30     │
│        ↓      ↓     │
├─────────────────────┤
│   [Cancel]  [OK]    │
└─────────────────────┘
```

---

**تم التطوير بنجاح! ✅**
**Successfully Implemented! 🎉**
