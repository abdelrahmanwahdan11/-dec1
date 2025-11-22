import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_settings.dart';

class AuthController extends ChangeNotifier {
  static const _guestKey = 'is_guest';
  bool _isAuthenticated = false;
  bool _isGuest = false;
  String? _email;

  bool get isAuthenticated => _isAuthenticated;
  bool get isGuest => _isGuest;
  String get displayName => _email ?? 'Guest';

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isGuest = prefs.getBool(_guestKey) ?? false;
  }

  bool validateEmail(String email) => email.contains('@');
  bool validatePassword(String password) => password.length >= 8;

  Future<bool> login(String email, String password) async {
    if (!validateEmail(email) || !validatePassword(password)) {
      return false;
    }
    _email = email;
    _isAuthenticated = true;
    _isGuest = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestKey, false);
    notifyListeners();
    return true;
  }

  Future<void> continueAsGuest() async {
    _isAuthenticated = true;
    _isGuest = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestKey, true);
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _email = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_guestKey);
    notifyListeners();
  }
}
