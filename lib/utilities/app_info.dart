import 'package:package_info_plus/package_info_plus.dart';
import 'package:vibration/vibration.dart';

class AppInfo {
  static late final PackageInfo _packageInfo;

  static String get packageName => _packageInfo.packageName;

  static String get versionName => _packageInfo.version;

  static bool _isVibrationEnabled = false;
  static bool _hasAmplitudeControl = false;

  static bool get isVibrationEnabled => _isVibrationEnabled;

  static bool get hasAmplitudeControl => _hasAmplitudeControl;

  static bool _init = false;

  static Future init() async {
    if (_init) return;
    _packageInfo = await PackageInfo.fromPlatform();
    _isVibrationEnabled = await Vibration.hasVibrator() ?? false;
    _hasAmplitudeControl = await Vibration.hasAmplitudeControl() ?? false;
    _init = true;
    // return _packageInfo;
  }
}