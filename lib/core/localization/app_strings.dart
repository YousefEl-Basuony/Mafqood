import '../models/report_item.dart';

/// Bilingual (Egyptian Arabic / English) UI string helper for Mafqood.
class AppStrings {
  const AppStrings._();

  static String tr(bool isArabic, String ar, String en) => isArabic ? ar : en;

  static String categoryLabel(ItemCategory category, bool isArabic) {
    switch (category) {
      case ItemCategory.wallet:
        return isArabic ? 'محفظة' : 'Wallet';
      case ItemCategory.phone:
        return isArabic ? 'موبايل' : 'Phone';
      case ItemCategory.keys:
        return isArabic ? 'مفاتيح' : 'Keys';
      case ItemCategory.bag:
        return isArabic ? 'شنطة' : 'Bag';
      case ItemCategory.cards:
        return isArabic ? 'بطاقات' : 'Cards';
      case ItemCategory.other:
        return isArabic ? 'أخرى' : 'Other';
    }
  }

  static String reportTypeLabel(ReportType type, bool isArabic) {
    switch (type) {
      case ReportType.lost:
        return isArabic ? 'مفقود' : 'Lost';
      case ReportType.found:
        return isArabic ? 'معثور عليه' : 'Found';
    }
  }

  static String statusLabel(ReportStatus status, bool isArabic) {
    switch (status) {
      case ReportStatus.searching:
        return isArabic ? 'قيد البحث' : 'Searching';
      case ReportStatus.matched:
        return isArabic ? 'تم التطابق' : 'Matched';
      case ReportStatus.found:
        return isArabic ? 'تم العثور' : 'Resolved';
      case ReportStatus.pendingApproval:
        return isArabic ? 'قيد المراجعة' : 'Pending Review';
      case ReportStatus.rejected:
        return isArabic ? 'مرفوض' : 'Rejected';
    }
  }
}
