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
import 'controllers/journal_controller.dart';
import 'controllers/changelog_controller.dart';
import 'controllers/events_controller.dart';
import 'controllers/gallery_controller.dart';
import 'controllers/garden_controller.dart';
import 'controllers/challenges_controller.dart';
import 'controllers/quiz_controller.dart';
import 'controllers/membership_controller.dart';
import 'controllers/accessibility_controller.dart';
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
import 'screens/journal/journal_screen.dart';
import 'screens/updates/updates_screen.dart';
import 'screens/insights/insights_screen.dart';
import 'screens/events/events_screen.dart';
import 'screens/gallery/gallery_screen.dart';
import 'screens/garden/garden_screen.dart';
import 'screens/challenges/challenges_screen.dart';
import 'screens/quiz/quiz_screen.dart';
import 'screens/membership/membership_screen.dart';
import 'screens/accessibility/accessibility_screen.dart';
import 'screens/encyclopedia/encyclopedia_screen.dart';
import 'screens/tips/community_tips_screen.dart';
import 'screens/privacy/privacy_center_screen.dart';

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
  late final JournalController journalController;
  late final ChangelogController changelogController;
  late final EventsController eventsController;
  late final GalleryController galleryController;
  late final GardenController gardenController;
  late final ChallengesController challengesController;
  late final QuizController quizController;
  late final MembershipController membershipController;
  late final AccessibilityController accessibilityController;

  Future<UserSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seen_onboarding') ?? false;
    final theme = prefs.getString('theme_mode');
    final primary = prefs.getString('primary_color_hex') ?? '#23A25D';
    final locale = prefs.getString('locale_code') ?? 'en';
    final isGuest = prefs.getBool('is_guest') ?? false;
    final textScale = prefs.getDouble('text_scale') ?? 1.0;
    final reduceMotion = prefs.getBool('reduce_motion') ?? false;
    final highContrast = prefs.getBool('high_contrast') ?? false;
    final analytics = prefs.getBool('analytics_opt_in') ?? true;
    final personalization = prefs.getBool('personalization_opt_in') ?? true;
    final emailTips = prefs.getBool('email_tips_opt_in') ?? true;
    return UserSettings(
      themeMode: AppThemeMode.values.firstWhere(
        (e) => e.name == theme,
        orElse: () => AppThemeMode.system,
      ),
      primaryColorHex: primary,
      localeCode: locale,
      seenOnboarding: seen,
      isGuest: isGuest,
      textScale: textScale,
      reduceMotion: reduceMotion,
      highContrast: highContrast,
      allowAnalytics: analytics,
      allowPersonalization: personalization,
      allowEmailTips: emailTips,
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
    journalController = JournalController();
    changelogController = ChangelogController();
    eventsController = EventsController();
    galleryController = GalleryController();
    gardenController = GardenController();
    challengesController = ChallengesController();
    quizController = QuizController();
    membershipController = MembershipController();
    challengesController.load();
    quizController.load();
    membershipController.load();
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
    journalController.dispose();
    changelogController.dispose();
    eventsController.dispose();
    galleryController.dispose();
    gardenController.dispose();
    challengesController.dispose();
    quizController.dispose();
    membershipController.dispose();
    accessibilityController.dispose();
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
        accessibilityController = AccessibilityController.withPrivacy(
          textScale: settings.textScale,
          reduceMotion: settings.reduceMotion,
          highContrast: settings.highContrast,
          allowAnalytics: settings.allowAnalytics,
          allowPersonalization: settings.allowPersonalization,
          allowEmailTips: settings.allowEmailTips,
        );
        if (settings.isGuest) {
          authController.continueAsGuest();
        }

        return AnimatedBuilder(
          animation:
              Listenable.merge([themeController, localeController, accessibilityController]),
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
                final media = MediaQuery.of(context);
                final baseTheme = Theme.of(context);
                final reducedTheme = accessibilityController.reduceMotion
                    ? baseTheme.copyWith(
                        pageTransitionsTheme: const PageTransitionsTheme(
                          builders: {
                            TargetPlatform.android: NoTransitionsBuilder(),
                            TargetPlatform.iOS: NoTransitionsBuilder(),
                            TargetPlatform.linux: NoTransitionsBuilder(),
                            TargetPlatform.macOS: NoTransitionsBuilder(),
                            TargetPlatform.windows: NoTransitionsBuilder(),
                            TargetPlatform.fuchsia: NoTransitionsBuilder(),
                          },
                        ),
                      )
                    : baseTheme;
                return Directionality(
                  textDirection: direction,
                  child: MediaQuery(
                    data: media.copyWith(
                      textScaleFactor: accessibilityController.textScale,
                      boldText: accessibilityController.highContrast,
                    ),
                    child: Theme(data: reducedTheme, child: child!),
                  ),
                );
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
                        journalController: journalController,
                        changelogController: changelogController,
                        eventsController: eventsController,
                        galleryController: galleryController,
                        gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const FavoritesScreen(),
                            ));
                  case '/garden':
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const GardenScreen(),
                            ));
                  case '/quiz':
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const QuizScreen(),
                            ));
                  case '/challenges':
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const ChallengesScreen(),
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const GuidesScreen(),
                            ));
                  case '/tips':
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const CommunityTipsScreen(),
                            ));
                  case '/encyclopedia':
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const EncyclopediaScreen(),
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                            journalController: journalController,
                            changelogController: changelogController,
                            eventsController: eventsController,
                            galleryController: galleryController,
                            gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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
                            journalController: journalController,
                            changelogController: changelogController,
                            eventsController: eventsController,
                            galleryController: galleryController,
                            gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const GiftingScreen(),
                          ));
                case '/journal':
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
                            journalController: journalController,
                            changelogController: changelogController,
                            eventsController: eventsController,
                            galleryController: galleryController,
                            gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const JournalScreen(),
                          ));
                  case '/updates':
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const UpdatesScreen(),
                            ));
                  case '/insights':
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const InsightsScreen(),
                            ));
                  case '/events':
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const EventsScreen(),
                            ));
                  case '/gallery':
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const GalleryScreen(),
                            ));
                  case '/membership':
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const MembershipScreen(),
                            ));
                  case '/accessibility':
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const AccessibilityScreen(),
                            ));
                  case '/privacy':
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
                              journalController: journalController,
                              changelogController: changelogController,
                              eventsController: eventsController,
                              galleryController: galleryController,
                              gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
                              child: const PrivacyCenterScreen(),
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
                          journalController: journalController,
                          changelogController: changelogController,
                          eventsController: eventsController,
                          galleryController: galleryController,
                          gardenController: gardenController,
                              challengesController: challengesController,
                              quizController: quizController,
                              membershipController: membershipController,
                              accessibilityController: accessibilityController,
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

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
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
  final JournalController journalController;
  final ChangelogController changelogController;
  final EventsController eventsController;
  final GalleryController galleryController;
  final GardenController gardenController;
  final ChallengesController challengesController;
  final QuizController quizController;
  final MembershipController membershipController;
  final AccessibilityController accessibilityController;

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
    required this.journalController,
    required this.changelogController,
    required this.eventsController,
    required this.galleryController,
    required this.gardenController,
    required this.challengesController,
    required this.quizController,
    required this.membershipController,
    required this.accessibilityController,
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
