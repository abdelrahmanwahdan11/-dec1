import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_settings.dart';

class ThemeController extends ChangeNotifier {
  static const _themeKey = 'theme_mode';
  static const _primaryKey = 'primary_color_hex';
  final UserSettings initialSettings;
  ThemeData? _cachedLight;
  ThemeData? _cachedDark;
  AppThemeMode _mode;
  Color _primary;

  ThemeController(this.initialSettings)
      : _mode = initialSettings.themeMode,
        _primary = Color(int.parse(initialSettings.primaryColorHex.replaceFirst('#', '0xff')));

  ThemeMode get themeMode {
    switch (_mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
      default:
        return ThemeMode.system;
    }
  }

  Color get primaryColor => _primary;
  AppThemeMode get appThemeMode => _mode;

  Future<void> toggleMode(AppThemeMode mode) async {
    _mode = mode;
    _cachedLight = null;
    _cachedDark = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
    notifyListeners();
  }

  Future<void> updatePrimary(Color color) async {
    _primary = color;
    _cachedLight = null;
    _cachedDark = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_primaryKey, '#${color.value.toRadixString(16)}');
    notifyListeners();
  }

  ThemeData lightTheme(TextTheme textTheme) {
    _cachedLight ??= _buildTheme(Brightness.light, textTheme);
    return _cachedLight!;
  }

  ThemeData darkTheme(TextTheme textTheme) {
    _cachedDark ??= _buildTheme(Brightness.dark, textTheme);
    return _cachedDark!;
  }

  ThemeData _buildTheme(Brightness brightness, TextTheme baseText) {
    final isDark = brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF101214) : const Color(0xFFF4F6F7);
    final cardColor = isDark ? const Color(0xFF1B1E21) : Colors.white;
    return ThemeData(
      brightness: brightness,
      useMaterial3: false,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primary,
        brightness: brightness,
        background: background,
        surface: cardColor,
      ),
      cardColor: cardColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _primary.withOpacity(0.12),
        selectedColor: _primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black87),
      ),
      textTheme: baseText,
      appBarTheme: AppBarTheme(
        elevation: isDark ? 0 : 2,
        backgroundColor: background,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primary,
      ),
    );
  }
}
