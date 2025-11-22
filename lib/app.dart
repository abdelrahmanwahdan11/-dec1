import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/compare_controller.dart';
import 'controllers/locale_controller.dart';
import 'controllers/onboarding_controller.dart';
import 'controllers/plant_catalog_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/care_controller.dart';
import 'controllers/notifications_controller.dart';
import 'controllers/guides_controller.dart';
import 'controllers/rewards_controller.dart';
import 'controllers/address_controller.dart';
import 'controllers/recent_controller.dart';
import 'controllers/promo_controller.dart';
import 'controllers/referral_controller.dart';
import 'controllers/diagnostics_controller.dart';
import 'controllers/gift_controller.dart';
import 'localization/app_localizations.dart';
import 'models/user_settings.dart';
import 'data/mock_orders.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main/main_shell_screen.dart';
import 'screens/plant/plant_details_screen.dart';
import 'screens/compare/compare_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/success/success_screen.dart';
import 'screens/stores/stores_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/about/about_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/care/care_schedule_screen.dart';
import 'screens/care/care_calendar_screen.dart';
import 'screens/notifications/notification_center_screen.dart';
import 'screens/guides/guides_screen.dart';
import 'screens/rewards/rewards_screen.dart';
import 'screens/orders/tracking_screen.dart';
import 'screens/support/support_screen.dart';
import 'screens/profile/address_book_screen.dart';
import 'screens/profile/recently_viewed_screen.dart';
import 'screens/bundles/bundles_screen.dart';
import 'screens/inspiration/inspiration_screen.dart';
import 'screens/coupons/coupons_screen.dart';
import 'screens/referrals/referrals_screen.dart';
import 'screens/diagnostics/diagnostics_screen.dart';
import 'screens/gifting/gifting_screen.dart';

class PlantsFresherApp extends StatefulWidget {
  const PlantsFresherApp({super.key});

  @override
  State<PlantsFresherApp> createState() => _PlantsFresherAppState();
}

class _PlantsFresherAppState extends State<PlantsFresherApp> {
  late final AuthController authController;
  late final ThemeController themeController;
  late final LocaleController localeController;
  late final CartController cartController;
  late final CompareController compareController;
  late final PlantCatalogController catalogController;
  late final FavoritesController favoritesController;
  late final CareController careController;
  late final NotificationsController notificationsController;
  late final GuidesController guidesController;
  late final RewardsController rewardsController;
  late final AddressController addressController;
  late final RecentController recentController;
  late final PromoController promoController;
  late final ReferralController referralController;
  late final DiagnosticsController diagnosticsController;
  late final GiftController giftController;

  Future<UserSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seen_onboarding') ?? false;
    final theme = prefs.getString('theme_mode');
    final primary = prefs.getString('primary_color_hex') ?? '#23A25D';
    final locale = prefs.getString('locale_code') ?? 'en';
    final isGuest = prefs.getBool('is_guest') ?? false;
    return UserSettings(
      themeMode: AppThemeMode.values.firstWhere(
        (e) => e.name == theme,
        orElse: () => AppThemeMode.system,
      ),
      primaryColorHex: primary,
      localeCode: locale,
      seenOnboarding: seen,
      isGuest: isGuest,
    );
  }

  @override
  void initState() {
    super.initState();
    authController = AuthController();
    cartController = CartController();
    compareController = CompareController();
    catalogController = PlantCatalogController();
    favoritesController = FavoritesController();
    careController = CareController();
    notificationsController = NotificationsController();
    guidesController = GuidesController();
    rewardsController = RewardsController();
    addressController = AddressController();
    recentController = RecentController();
    promoController = PromoController();
    referralController = ReferralController();
    diagnosticsController = DiagnosticsController();
    giftController = GiftController();
  }

  @override
  void dispose() {
    catalogController.dispose();
    favoritesController.dispose();
    careController.dispose();
    notificationsController.dispose();
    guidesController.dispose();
    rewardsController.dispose();
    addressController.dispose();
    recentController.dispose();
    promoController.dispose();
    referralController.dispose();
    diagnosticsController.dispose();
    giftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserSettings>(
      future: loadSettings(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(home: SizedBox());
        }
        final settings = snapshot.data!;
        themeController = ThemeController(settings);
        localeController = LocaleController(settings.localeCode);
        if (settings.isGuest) {
          authController.continueAsGuest();
        }

        return AnimatedBuilder(
          animation: Listenable.merge([themeController, localeController]),
          builder: (context, _) {
            final locale = localeController.locale;
            final textTheme = AppThemeBuilder.textTheme(locale);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: locale,
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              theme: AppThemeBuilder.light(locale, themeController),
              darkTheme: AppThemeBuilder.dark(locale, themeController),
              themeMode: themeController.themeMode,
              builder: (context, child) {
                final direction = locale.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr;
                return Directionality(textDirection: direction, child: child!);
              },
              initialRoute: _initialRoute(settings),
              onGenerateRoute: (settingsRoute) {
                final name = settingsRoute.name;
                switch (name) {
                  case '/onboarding':
                    return MaterialPageRoute(
                      builder: (_) => OnboardingScreen(
                        onboardingController: OnboardingController(),
                        onFinish: () {
                          Navigator.of(context).pushReplacementNamed('/auth/login');
                        },
                      ),
                    );
                  case '/auth/login':
                    return MaterialPageRoute(
                        builder: (_) => LoginScreen(authController: authController));
                  case '/auth/register':
                    return MaterialPageRoute(builder: (_) => RegisterScreen(authController: authController));
                  case '/auth/forgot':
                    return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
                  case '/main':
                    return MaterialPageRoute(
                      builder: (_) => AppScope(
                        authController: authController,
                        themeController: themeController,
                        localeController: localeController,
                        cartController: cartController,
                        compareController: compareController,
                        favoritesController: favoritesController,
                        careController: careController,
                        notificationsController: notificationsController,
                        guidesController: guidesController,
                        rewardsController: rewardsController,
                        addressController: addressController,
                        recentController: recentController,
                        catalogController: catalogController,
                        promoController: promoController,
                        referralController: referralController,
                        diagnosticsController: diagnosticsController,
                        giftController: giftController,
                        child: const MainShellScreen(),
                      ),
                    );
                  case '/compare':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const CompareScreen(),
                            ));
                  case '/checkout':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const CheckoutScreen(),
                            ));
                  case '/success':
                    return MaterialPageRoute(builder: (_) => const SuccessScreen());
                  case '/stores':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const StoresScreen(),
                            ));
                  case '/orders':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const OrdersScreen(),
                            ));
                  case '/tracking':
                    final orderId = settingsRoute.arguments as String?;
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: TrackingScreen(orderId: orderId ?? mockOrders.first.id),
                            ));
                  case '/about':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const AboutScreen(),
                            ));
                  case '/support':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const SupportScreen(),
                            ));
                  case '/favorites':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const FavoritesScreen(),
                            ));
                  case '/care':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const CareScheduleScreen(),
                            ));
                  case '/care/calendar':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const CareCalendarScreen(),
                            ));
                  case '/notifications':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const NotificationCenterScreen(),
                            ));
                  case '/guides':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const GuidesScreen(),
                            ));
                  case '/rewards':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const RewardsScreen(),
                            ));
                  case '/bundles':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              child: const BundlesScreen(),
                            ));
                  case '/inspiration':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              child: const InspirationScreen(),
                            ));
                  case '/addresses':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const AddressBookScreen(),
                            ));
                  case '/recent':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const RecentlyViewedScreen(),
                            ));
                  case '/coupons':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const CouponsScreen(),
                            ));
                  case '/referrals':
                    return MaterialPageRoute(
                        builder: (_) => AppScope(
                              authController: authController,
                              themeController: themeController,
                              localeController: localeController,
                              cartController: cartController,
                              compareController: compareController,
                              favoritesController: favoritesController,
                              careController: careController,
                              notificationsController: notificationsController,
                              guidesController: guidesController,
                              rewardsController: rewardsController,
                              addressController: addressController,
                              recentController: recentController,
                              catalogController: catalogController,
                              promoController: promoController,
                              referralController: referralController,
                              diagnosticsController: diagnosticsController,
                              giftController: giftController,
                              child: const ReferralsScreen(),
                            ));
                case '/diagnostics':
                  return MaterialPageRoute(
                      builder: (_) => AppScope(
                            authController: authController,
                            themeController: themeController,
                            localeController: localeController,
                            cartController: cartController,
                            compareController: compareController,
                            favoritesController: favoritesController,
                            careController: careController,
                            notificationsController: notificationsController,
                            guidesController: guidesController,
                            rewardsController: rewardsController,
                            addressController: addressController,
                            recentController: recentController,
                            catalogController: catalogController,
                            promoController: promoController,
                            referralController: referralController,
                            diagnosticsController: diagnosticsController,
                            giftController: giftController,
                            child: const DiagnosticsScreen(),
                          ));
                case '/gifting':
                  return MaterialPageRoute(
                      builder: (_) => AppScope(
                            authController: authController,
                            themeController: themeController,
                            localeController: localeController,
                            cartController: cartController,
                            compareController: compareController,
                            favoritesController: favoritesController,
                            careController: careController,
                            notificationsController: notificationsController,
                            guidesController: guidesController,
                            rewardsController: rewardsController,
                            addressController: addressController,
                            recentController: recentController,
                            catalogController: catalogController,
                            promoController: promoController,
                            referralController: referralController,
                            diagnosticsController: diagnosticsController,
                            giftController: giftController,
                            child: const GiftingScreen(),
                          ));
                  default:
                    if (name != null && name.startsWith('/plant/')) {
                      final id = name.split('/').last;
                      return MaterialPageRoute(
                        builder: (_) => AppScope(
                          authController: authController,
                          themeController: themeController,
                          localeController: localeController,
                          cartController: cartController,
                          compareController: compareController,
                          favoritesController: favoritesController,
                          careController: careController,
                          notificationsController: notificationsController,
                          guidesController: guidesController,
                          rewardsController: rewardsController,
                          addressController: addressController,
                          recentController: recentController,
                          catalogController: catalogController,
                          promoController: promoController,
                          referralController: referralController,
                          diagnosticsController: diagnosticsController,
                          giftController: giftController,
                          child: PlantDetailsScreen(plantId: id),
                        ),
                      );
                    }
                    return null;
                }
              },
            );
          },
        );
      },
    );
  }

  String _initialRoute(UserSettings settings) {
    if (!settings.seenOnboarding) return '/onboarding';
    if (!authController.isAuthenticated && !settings.isGuest) return '/auth/login';
    return '/main';
  }
}

class AppScope extends InheritedWidget {
  final AuthController authController;
  final ThemeController themeController;
  final LocaleController localeController;
  final CartController cartController;
  final CompareController compareController;
  final FavoritesController favoritesController;
  final CareController careController;
  final NotificationsController notificationsController;
  final GuidesController guidesController;
  final RewardsController rewardsController;
  final AddressController addressController;
  final RecentController recentController;
  final PlantCatalogController catalogController;
  final PromoController promoController;
  final ReferralController referralController;
  final DiagnosticsController diagnosticsController;
  final GiftController giftController;

  const AppScope({
    super.key,
    required this.authController,
    required this.themeController,
    required this.localeController,
    required this.cartController,
    required this.compareController,
    required this.favoritesController,
    required this.careController,
    required this.notificationsController,
    required this.guidesController,
    required this.rewardsController,
    required this.addressController,
    required this.recentController,
    required this.catalogController,
    required this.promoController,
    required this.referralController,
    required this.diagnosticsController,
    required this.giftController,
    required Widget child,
  }) : super(child: child);

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope missing');
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant AppScope oldWidget) => false;
}
