import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_gift_options.dart';
import '../models/gift_option.dart';

class GiftController extends ChangeNotifier {
  GiftController() {
    _load();
  }

  final ValueNotifier<List<GiftOption>> options =
      ValueNotifier<List<GiftOption>>(mockGiftOptions);
  final ValueNotifier<String> selectedWrap = ValueNotifier<String>('#23A25D');
  final ValueNotifier<String> message = ValueNotifier<String>('');
  late SharedPreferences _prefs;
  bool _ready = false;

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    _ready = true;
    selectedWrap.value = _prefs.getString('gift_wrap') ?? '#23A25D';
    message.value = _prefs.getString('gift_message') ?? '';
    notifyListeners();
  }

  Future<void> chooseWrap(String hex) async {
    selectedWrap.value = hex;
    if (_ready) {
      await _prefs.setString('gift_wrap', hex);
    }
    notifyListeners();
  }

  Future<void> updateMessage(String value) async {
    message.value = value;
    if (_ready) {
      await _prefs.setString('gift_message', value);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    options.dispose();
    selectedWrap.dispose();
    message.dispose();
    super.dispose();
  }
}
