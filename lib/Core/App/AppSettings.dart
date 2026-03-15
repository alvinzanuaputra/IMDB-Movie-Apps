import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const _langKey = 'isEnglish';

  static final ValueNotifier<bool> isEnglish = ValueNotifier<bool>(false);

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final english = prefs.getBool(_langKey) ?? false;
    isEnglish.value = english;
  }

  static Future<void> setLanguage(bool english) async {
    isEnglish.value = english;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_langKey, english);
  }
}
