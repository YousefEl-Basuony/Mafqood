import '../models/app_notification.dart';
import '../models/app_user.dart';
import '../models/chat_message.dart';
import '../models/match_result.dart';
import '../models/report_item.dart';

/// Realistic bilingual mock data for instant testing without Firebase setup.
class MockDataProvider {
  const MockDataProvider._();

  static final DateTime _now = DateTime.now();

  static final List<AppUser> demoUsers = [
    AppUser(
      uid: 'user_yousef',
      name: 'يوسف محمد البسيوني',
      email: 'yousef@mafqood.app',
      phone: '01012345678',
      role: 'admin',
      createdAt: _now.subtract(const Duration(days: 30)),
    ),
    AppUser(
      uid: 'user_abdelrahman',
      name: 'عبدالرحمن محمد',
      email: 'abdelrahman@mafqood.app',
      phone: '01123456789',
      role: 'user',
      createdAt: _now.subtract(const Duration(days: 20)),
    ),
    AppUser(
      uid: 'user_mahmoud',
      name: 'محمود أبو النادي',
      email: 'mahmoud@mafqood.app',
      phone: '01234567890',
      role: 'user',
      createdAt: _now.subtract(const Duration(days: 15)),
    ),
  ];

  static final List<ReportItem> initialReports = [
    ReportItem(
      id: 'rep_1',
      userId: 'user_abdelrahman',
      userName: 'عبدالرحمن محمد',
      type: ReportType.lost,
      category: ItemCategory.wallet,
      title: 'محفظة جلد بني فيها بطاقة شخصية',
      description:
          'ضاعت مني محفظة جلد لونها بني غامق فيها البطاقة وكارنيه الجامعة عند محطة مترو الدقي.',
      color: 'بني',
      location: 'محطة مترو الدقي - الجيزة',
      date: _now.subtract(const Duration(hours: 5)),
      imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600',
      status: ReportStatus.matched,
      isApproved: true,
      createdAt: _now.subtract(const Duration(hours: 5)),
    ),
    ReportItem(
      id: 'rep_2',
      userId: 'user_mahmoud',
      userName: 'محمود أبو النادي',
      type: ReportType.found,
      category: ItemCategory.wallet,
      title: 'لقيت محفظة جلد بني عند مترو الدقي',
      description:
          'تم العثور على محفظة جلد بني وبداخلها أوراق شخصية قرب بوابة الخروج في مترو الدقي.',
      color: 'بني',
      location: 'محطة مترو الدقي - الجيزة',
      date: _now.subtract(const Duration(hours: 3)),
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
      status: ReportStatus.matched,
      isApproved: true,
      createdAt: _now.subtract(const Duration(hours: 3)),
    ),
    ReportItem(
      id: 'rep_3',
      userId: 'user_yousef',
      userName: 'يوسف محمد البسيوني',
      type: ReportType.lost,
      category: ItemCategory.phone,
      title: 'موبايل iPhone 14 أزرق بجراب شفاف',
      description:
          'فقدت موبايل iPhone 14 لون أزرق سماوي بجراب شفاف في سيتي ستارز الدور الثالث.',
      color: 'أزرق',
      location: 'سيتي ستارز - مدينة نصر',
      date: _now.subtract(const Duration(days: 1)),
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600',
      status: ReportStatus.searching,
      isApproved: true,
      createdAt: _now.subtract(const Duration(days: 1)),
    ),
    ReportItem(
      id: 'rep_4',
      userId: 'user_mahmoud',
      userName: 'محمود أبو النادي',
      type: ReportType.found,
      category: ItemCategory.keys,
      title: 'ميدالية مفاتيح سيارة هيونداي + مفتاح شقة',
      description:
          'لقيت ميدالية مفاتيح فيها ريموت عربية هيونداي ومفتاحين فضي في موقف التجمع الخامس.',
      color: 'أسود وفضي',
      location: 'التجمع الخامس - القاهرة الجديدة',
      date: _now.subtract(const Duration(days: 1, hours: 4)),
      imageUrl: 'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=600',
      status: ReportStatus.searching,
      isApproved: true,
      createdAt: _now.subtract(const Duration(days: 1, hours: 4)),
    ),
    ReportItem(
      id: 'rep_5',
      userId: 'user_abdelrahman',
      userName: 'عبدالرحمن محمد',
      type: ReportType.lost,
      category: ItemCategory.bag,
      title: 'شنطة ظهر سوداء فيها لابتوب وكراسة',
      description:
          'شنطة ظهر ماركة Dell لونها أسود ضاعت في أتوبيس نقل عام خط رمسيس - المعادي.',
      color: 'أسود',
      location: 'ميدان رمسيس - القاهرة',
      date: _now.subtract(const Duration(days: 2)),
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
      status: ReportStatus.found,
      isApproved: true,
      createdAt: _now.subtract(const Duration(days: 2)),
    ),
    ReportItem(
      id: 'rep_6',
      userId: 'user_abdelrahman',
      userName: 'عبدالرحمن محمد',
      type: ReportType.found,
      category: ItemCategory.cards,
      title: 'فيزا بنك مصر باسم أحمد كريم',
      description:
          'لقيت بطاقة بنك مصر أمام ماكينة ATM في شارع جامعة الدول العربية.',
      color: 'عنابي',
      location: 'المهندسين - الجيزة',
      date: _now.subtract(const Duration(hours: 2)),
      status: ReportStatus.pendingApproval,
      isApproved: false,
      createdAt: _now.subtract(const Duration(hours: 2)),
    ),
  ];

  static final List<MatchResult> initialMatches = [
    MatchResult(
      id: 'match_1',
      lostReportId: 'rep_1',
      foundReportId: 'rep_2',
      lostItemTitle: 'محفظة جلد بني فيها بطاقة شخصية',
      foundItemTitle: 'لقيت محفظة جلد بني عند مترو الدقي',
      lostUserId: 'user_abdelrahman',
      foundUserId: 'user_mahmoud',
      matchPercentage: 92,
      status: MatchStatus.pending,
      matchedAttributes: const ['الفئة: محفظة', 'اللون: بني', 'الموقع: مترو الدقي'],
      createdAt: _now.subtract(const Duration(hours: 2)),
    ),
  ];

  static final List<ChatMessage> initialMessages = [
    ChatMessage(
      id: 'msg_1',
      chatId: 'rep_1_rep_2',
      senderId: 'user_mahmoud',
      senderName: 'محمود أبو النادي',
      text: 'أهلاً يا عبدالرحمن، لقيت المحفظة عند بوابة مترو الدقي.',
      timestamp: _now.subtract(const Duration(minutes: 42)),
      isRead: true,
    ),
    ChatMessage(
      id: 'msg_2',
      chatId: 'rep_1_rep_2',
      senderId: 'user_abdelrahman',
      senderName: 'عبدالرحمن محمد',
      text: 'تسلم جداً! ممكن نتقابل عند كشك الأمن في المحطة النهاردة؟',
      timestamp: _now.subtract(const Duration(minutes: 35)),
      isRead: true,
    ),
    ChatMessage(
      id: 'msg_3',
      chatId: 'rep_1_rep_2',
      senderId: 'user_mahmoud',
      senderName: 'محمود أبو النادي',
      text: 'أكيد، هكون موجود الساعة 6 مساءً إن شاء الله.',
      timestamp: _now.subtract(const Duration(minutes: 15)),
      isRead: false,
    ),
  ];

  static final List<AppNotification> initialNotifications = [
    AppNotification(
      id: 'notif_1',
      userId: 'user_abdelrahman',
      title: 'تطابق ذكي بنسبة 92%!',
      titleEn: '92% Smart Match Found!',
      body: 'لقينا بلاغ معثور عليه يطابق محفظتك الجلد البني في مترو الدقي.',
      bodyEn: 'A found report matches your brown leather wallet at Dokki Metro.',
      type: NotificationType.match,
      relatedId: 'match_1',
      isRead: false,
      createdAt: _now.subtract(const Duration(hours: 2)),
    ),
    AppNotification(
      id: 'notif_2',
      userId: 'user_abdelrahman',
      title: 'رسالة جديدة من محمود أبو النادي',
      titleEn: 'New message from Mahmoud Abo El-Nady',
      body: 'أكيد، هكون موجود الساعة 6 مساءً إن شاء الله.',
      bodyEn: 'Sure, I will be there at 6 PM.',
      type: NotificationType.message,
      relatedId: 'rep_1_rep_2',
      isRead: false,
      createdAt: _now.subtract(const Duration(minutes: 15)),
    ),
    AppNotification(
      id: 'notif_3',
      userId: 'user_yousef',
      title: 'تمت الموافقة على بلاغك',
      titleEn: 'Your report was approved',
      body: 'بلاغ موبايل iPhone 14 أصبح ظاهراً الآن لجميع المستخدمين.',
      bodyEn: 'Your iPhone 14 report is now visible to all users.',
      type: NotificationType.reportApproved,
      relatedId: 'rep_3',
      isRead: true,
      createdAt: _now.subtract(const Duration(days: 1)),
    ),
  ];
}
