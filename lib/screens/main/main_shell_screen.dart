import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../home/home_tab.dart';
import '../catalog/catalog_tab.dart';
import '../cart/cart_tab.dart';
import '../profile/profile_tab.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  final pageController = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tabs = [
      (IconlyBold.home, t.t('home'), const HomeTab()),
      (IconlyBold.category, t.t('catalog'), const CatalogTab()),
      (IconlyBold.buy, t.t('cart'), const CartTab()),
      (IconlyBold.profile, t.t('profile'), const ProfileTab()),
    ];
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (value) => setState(() => index = value),
        children: tabs.map((t) => t.$3).toList(),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          onTap: (i) {
            setState(() => index = i);
            pageController.animateToPage(i,
                duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
          items: tabs
              .map((e) => BottomNavigationBarItem(icon: Icon(e.$1), label: e.$2))
              .toList(),
        ),
      ),
    );
  }
}
