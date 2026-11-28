# مفقود | Mafqood 🔍

**منصة محلية ذكية للمفقودات والمعثورات (Smart Lost & Found Platform)**  
تربط بين الأشخاص الذين فقدوا ممتلكاتهم (محافظ، هواتف، مفاتيح، حقائب، بطاقات) والأشخاص الذين عثروا عليها، مع نظام مطابقة ذكي ومحادثة آمنة داخل التطبيق.

- **Package / App ID:** `com.mafqoodteam.mafqood`
- **Tech Stack:** Flutter + Dart (Material 3) • Provider • Firebase (Auth, Cloud Firestore, Google Sign-In) • SharedPreferences • Google Fonts (`Cairo`)

---

## ✨ المميزات الأساسية (Core Features)

- **الإبلاغ السريع (Lost & Found Reports):** تسجيل بلاغ مفقود أو معثور عليه بالنوع، الفئة، اللون، الوصف، المكان، التاريخ، والصورة.
- **البحث والفلترة الذكية (Search & Filter):** بحث فوري بالكلمات المفتاحية أو الموقع مع فلترة حسب الفئة (`محفظة`، `موبايل`، `مفاتيح`، `شنطة`، `بطاقات`، `أخرى`).
- **نظام المطابقة الذكي (Smart Matching):** مقارنة تلقائية بين بلاغات المفقودات والمعثورات وحساب نسبة التطابق (مثل `92% Match`) مع إرسال إشعار فوري للطرفين.
- **المحادثة الآمنة (Safe Chat):** تواصل فوري داخل التطبيق لتنسيق التسليم بدون كشف البيانات الشخصية أو أرقام الهواتف.
- **مركز الإشعارات (Real-time Notifications):** تنبيهات فورية عند وجود تطابق جديد، رسالة جديدة، أو اعتماد بلاغ.
- **لوحة تحكم الإدارة (Admin Dashboard):** إحصائيات سريعة للبلاغات النشطة والمكتملة والمعلقة مع أزرار الموافقة أو الحذف.
- **دعم كامل للغتين والثيمين:** واجهة عربية (RTL) وإنجليزية (LTR) بخط `Cairo`، مع **Dark Mode & Light Mode** بهوية كحلي غامق (`#0F172A` / `#1A2B4C`) وتركواز (`#14B8A6` / `#0D9488`) وحفظ الإعدادات محلياً.

---

## 🏗️ هيكل المشروع (Project Architecture)

```text
lib/
├── main.dart                         # نقطة البداية وربط Providers و MaterialApp
├── core/
│   ├── data/mock_data_provider.dart  # بيانات تجريبية واقعية للتشغيل الفوري
│   ├── localization/app_strings.dart # نصوص التطبيق ثنائية اللغة (AR / EN)
│   ├── models/                       # AppUser, ReportItem, MatchResult, ChatMessage, AppNotification
│   └── theme/                        # app_colors.dart & app_theme.dart (Light/Dark + Cairo)
├── data/
│   ├── local/                        # AppSettingsManager & SavedAccountManager (SharedPreferences)
│   └── repositories/                 # AuthRepository & MafqoodRepository (Fake + Firebase)
├── navigation/
│   ├── app_routes.dart               # أسماء المسارات (Named Routes)
│   ├── app_router.dart               # ربط جميع الشاشات
│   └── main_app_shell.dart           # شريط التنقل السفلي (4 تبويبات رئيسية)
├── ui/widgets/                       # AppScreenContainer, AppCard, ReportCard
└── screens/
    ├── auth_mahmoud/                 # شاشات محمود أبو النادي (4 شاشات)
    ├── reports_abdelrahman/          # شاشات عبدالرحمن محمد (4 شاشات)
    ├── smart_yousef/                 # شاشات يوسف محمد البسيوني (4 شاشات)
    └── settings/                     # شاشة الإعدادات المشتركة
```

---

## 👥 فريق العمل وتوزيع الشاشات (Team & Branches)

| العضو | الدور | البرانش | المجلد والشاشات |
| :--- | :--- | :--- | :--- |
| **يوسف محمد البسيوني**<br>(Yousef Mohamed El-Basuony) | Team Lead, Architecture & Smart Backend | `Joo` | `lib/screens/smart_yousef/`<br>• `smart_matches_screen.dart`<br>• `safe_chat_screen.dart`<br>• `admin_dashboard_screen.dart`<br>• `notifications_screen.dart` |
| **عبدالرحمن محمد**<br>(Abdelrahman Mohamed) | Reports & Search UI + Backend Co-developer | `Tana7` | `lib/screens/reports_abdelrahman/`<br>• `home_feed_screen.dart`<br>• `report_item_screen.dart`<br>• `item_details_screen.dart`<br>• `search_filter_screen.dart` |
| **محمود أبو النادي**<br>(Mahmoud Abo El-Nady) | Auth & Profile UI | `AboElnady` | `lib/screens/auth_mahmoud/`<br>• `splash_screen.dart`<br>• `login_screen.dart`<br>• `register_screen.dart`<br>• `my_profile_screen.dart` |

> **الشاشة المشتركة:** `lib/screens/settings/settings_screen.dart` (الإعدادات، الوضع الليلي، اللغة، التبديل السريع بين الحسابات المحفوظة، ومعلومات الفريق).

---

## 🚀 التشغيل السريع (Quick Start)

1. **تحميل الباكدجات:**
   ```bash
   flutter pub get
   ```
2. **فحص الكود:**
   ```bash
   flutter analyze
   ```
3. **تشغيل التطبيق:**
   ```bash
   flutter run
   ```
4. **بناء نسخة أندرويد Debug:**
   ```bash
   flutter build apk --debug
   ```

> **ملاحظة Firebase:** التطبيق يعمل مباشرة بـ `FakeAuthRepository` و `FakeMafqoodRepository` للاختبار الفوري دون الحاجة لإعداد Firebase مسبقاً. عند جاهزية مشروع Firebase وإضافة `google-services.json`، يمكن التبديل في `lib/main.dart` إلى `FirebaseAuthRepository` و `FirebaseMafqoodRepository`.

---

## 🔀 قواعد العمل على Git

1. كل عضو يعمل داخل **البرانش الخاص به** (`Joo` / `Tana7` / `AboElnady`) وفي **مجلد الشاشات الخاص به فقط** لتجنب الـ Merge Conflicts.
2. قبل الـ Merge إلى `main`، يتم التأكد من نجاح `flutter analyze` بدون أخطاء.
3. تفاصيل خطة العمل مقسمة في ملف [`AGILE_BOARD.md`](AGILE_BOARD.md).
