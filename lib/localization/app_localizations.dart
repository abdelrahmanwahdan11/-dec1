import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'app_name': 'Plants Fresher',
      'skip': 'Skip',
      'next': 'Next',
      'get_started': 'Get Started',
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot password?',
      'guest': 'Continue as Guest',
      'home': 'Home',
      'catalog': 'Catalog',
      'cart': 'Cart',
      'profile': 'Profile',
      'search': 'Search plants, tags...',
      'add_to_cart': 'Add to cart',
      'add_to_compare': 'Add to compare',
      'ai_info': 'AI Info',
      'compare': 'Compare',
      'empty_compare': 'No plants to compare yet',
      'clear_all': 'Clear all',
      'subtotal': 'Subtotal',
      'delivery_fee': 'Delivery fee',
      'total': 'Total',
      'pay': 'Pay',
      'theme': 'Theme',
      'language': 'Language',
      'dark_mode': 'Dark mode',
      'primary_color': 'Primary color',
      'logout': 'Logout',
      'welcome': 'Welcome',
      'hi_guest': 'Hi plant lover',
      'checkout': 'Checkout',
      'success_title': 'Congratulations!',
      'success_subtitle': 'Your order is successfully placed',
      'back_home': 'Back to Home',
      'view_orders': 'View Orders',
      'promo_code': 'Promo code',
      'apply': 'Apply',
      'saved_cards': 'Saved cards',
      'add_card': 'Add new card',
      'stores': 'Stores',
    },
    'ar': {
      'app_name': 'بلانتس فريشر',
      'skip': 'تخطي',
      'next': 'التالي',
      'get_started': 'ابدأ الآن',
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'forgot_password': 'هل نسيت كلمة المرور؟',
      'guest': 'الدخول كضيف',
      'home': 'الرئيسية',
      'catalog': 'الكتالوج',
      'cart': 'السلة',
      'profile': 'الملف الشخصي',
      'search': 'ابحث عن النباتات أو العلامات...',
      'add_to_cart': 'أضف للسلة',
      'add_to_compare': 'أضف للمقارنة',
      'ai_info': 'معلومات بالذكاء الاصطناعي',
      'compare': 'مقارنة',
      'empty_compare': 'لا توجد نباتات للمقارنة بعد',
      'clear_all': 'مسح الكل',
      'subtotal': 'المجموع الفرعي',
      'delivery_fee': 'رسوم التوصيل',
      'total': 'الإجمالي',
      'pay': 'ادفع',
      'theme': 'المظهر',
      'language': 'اللغة',
      'dark_mode': 'الوضع الليلي',
      'primary_color': 'اللون الأساسي',
      'logout': 'تسجيل الخروج',
      'welcome': 'أهلاً بك',
      'hi_guest': 'مرحباً محب النباتات',
      'checkout': 'إتمام الشراء',
      'success_title': 'تهانينا!',
      'success_subtitle': 'تم تنفيذ طلبك بنجاح',
      'back_home': 'العودة للرئيسية',
      'view_orders': 'عرض الطلبات',
      'promo_code': 'رمز الخصم',
      'apply': 'تطبيق',
      'saved_cards': 'البطاقات المحفوظة',
      'add_card': 'أضف بطاقة جديدة',
      'stores': 'الفروع',
    },
  };

  String t(String key) => _localizedValues[locale.languageCode]?[key] ?? key;

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
