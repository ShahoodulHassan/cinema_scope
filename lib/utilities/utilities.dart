

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class AppInfo {
  static late final PackageInfo _packageInfo;

  static String get packageName => _packageInfo.packageName;
  static String get appName => _packageInfo.appName;
  static String get versionName => _packageInfo.version;

  static bool _isVibrationEnabled = false;
  static bool _hasAmplitudeControl = false;

  static bool get isVibrationEnabled => _isVibrationEnabled;

  static bool get hasAmplitudeControl => _hasAmplitudeControl;

  static bool _init = false;

  static Future init() async {
    if (_init) return;
    _packageInfo = await PackageInfo.fromPlatform();
    if (!kIsWeb) {
      _isVibrationEnabled = await Vibration.hasVibrator() ?? false;
      _hasAmplitudeControl = await Vibration.hasAmplitudeControl() ?? false;
    }
    _init = true;
    // return _packageInfo;
  }
}

class PrefUtil {
  static late final SharedPreferences _preferences;
  static bool _init = false;

  static Future init() async {
    if (_init) return;
    _preferences = await SharedPreferences.getInstance();
    _init = true;
    return _preferences; // No need to return though
  }

  static setValue(String key, Object value) {
    switch (value.runtimeType) {
      case String:
        _preferences.setString(key, value as String);
        break;
      case bool:
        _preferences.setBool(key, value as bool);
        break;
      case int:
        _preferences.setInt(key, value as int);
        break;
      default:
    }
  }

  static T getValue<T>(String key, T defaultValue) {
    switch (defaultValue.runtimeType) {
      case String:
        return (_preferences.getString(key) ?? defaultValue) as T;
      case bool:
        return (_preferences.getBool(key) ?? defaultValue) as T;
      case int:
        return (_preferences.getInt(key) ?? defaultValue) as T;
      default:
        return defaultValue;
    }
  }
}

mixin Utilities {

  int? getYearFromDate(String? date) =>
      date != null ? DateTime.tryParse(date)?.year : null;

  String getYearStringFromDate(String? date) =>
      '${getYearFromDate(date) ?? ''}';

  // ranges from 0.0 to 1.0
  Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  /// Darken a color by [percent] amount (100 = black)
// ........................................................
  Color darken2(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(
        c.alpha,
        (c.red * f).round(),
        (c.green  * f).round(),
        (c.blue * f).round()
    );
  }

  /// Lighten a color by [percent] amount (100 = white)
// ........................................................
  Color lighten2(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round()
    );
  }

}