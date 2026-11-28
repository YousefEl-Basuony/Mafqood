# لوحة العمل وتوزيع المهام — تطبيق مفقود (Mafqood)

## معلومات المشروع
- **اسم التطبيق:** مفقود (Mafqood)
- **Package / App ID:** `com.mafqoodteam.mafqood`
- **التقنية:** Flutter + Dart (Material 3) + Provider + Firebase (Auth & Firestore) + SharedPreferences

---

## توزيع الشاشات والمهام بين الفريق (3 أعضاء × 4 شاشات = 12 شاشة + شاشة إعدادات مشتركة)

### 1. يوسف محمد البسيوني (Yousef Mohamed El-Basuony) — Team Lead & Backend
- **الشاشات (`lib/screens/smart_yousef/`):**
  1. `smart_matches_screen.dart` — شاشة التطابقات الذكية ونسبة التطابق.
  2. `safe_chat_screen.dart` — المحادثة الآمنة في الوقت الفعلي.
  3. `admin_dashboard_screen.dart` — لوحة تحكم الإدارة والموافقة/الحذف.
  4. `notifications_screen.dart` — مركز الإشعارات المصنفة (اليوم / أمس).
- **مهام الـ Architecture والباك إند:**
  - تأسيس الـ Models (`lib/core/models/`) والـ Theme (`lib/core/theme/`).
  - إعداد الـ Navigation (`lib/navigation/app_router.dart`, `main_app_shell.dart`).
  - ربط `FirebaseAuth`, `Cloud Firestore` Real-time Streams، ومنطق المطابقة الذكية والإشعارات.

### 2. عبدالرحمن محمد (Abdelrahman Mohamed) — UI & Backend Co-developer
- **الشاشات (`lib/screens/reports_abdelrahman/`):**
  1. `home_feed_screen.dart` — الشاشة الرئيسية وتبويب المفقودات/المعثورات.
  2. `report_item_screen.dart` — نموذج الإبلاغ عن عنصر مفقود أو معثور عليه.
  3. `item_details_screen.dart` — تفاصيل العنصر وزر بدء الشات الآمن.
  4. `search_filter_screen.dart` — البحث الذكي والفلترة حسب الفئة.
- **مهام الباك إند المشتركة:**
  - المشاركة في `lib/data/repositories/mafqood_repository.dart` (CRUD البلاغات، الفلترة، وربط `FakeMafqoodRepository` و `FirebaseMafqoodRepository`).

### 3. محمود أبو النادي (Mahmoud Abo El-Nady) — Auth & Profile UI
- **الشاشات (`lib/screens/auth_mahmoud/`):**
  1. `splash_screen.dart` — شاشة البداية باللوجو والانتقال التلقائي.
  2. `login_screen.dart` — تسجيل الدخول بالإيميل و Google Sign-In.
  3. `register_screen.dart` — إنشاء حساب جديد.
  4. `my_profile_screen.dart` — الملف الشخصي وبلاغاتي النشطة وتسجيل الخروج.

### الشاشة المشتركة (`lib/screens/settings/`)
- `settings_screen.dart` — الإعدادات (الإشعارات، Dark/Light Mode، اللغة عربي/إنجليزي، التبديل السريع بين الحسابات المحفوظة، وقسم عن الفريق).

---

## قواعد Git Branches
- `main`: النسخة المستقرة الجاهزة للتسليم والعرض.
- `develop`: فرع التجميع والاختبار قبل الدمج في `main`.
- `feat/yousef-smart-backend`: تطوير شاشات `smart_yousef` والباك إند.
- `feat/abdelrahman-reports`: تطوير شاشات `reports_abdelrahman` و CRUD البلاغات.
- `feat/mahmoud-auth-profile`: تطوير شاشات `auth_mahmoud`.
- **قواعد العمل:** لا يتم الدمج في `main` مباشرة؛ كل عضو يرفع على فرعه ثم يفتح Pull Request إلى `develop` بعد تشغيل `flutter analyze` بنجاح.
