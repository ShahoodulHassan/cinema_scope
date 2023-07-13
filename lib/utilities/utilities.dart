

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


}