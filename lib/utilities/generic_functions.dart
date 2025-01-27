import 'dart:io';
import 'dart:math' as math;

import 'package:cinema_scope/pages/search_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vibration/vibration.dart';

import '../constants.dart';
import '../widgets/boolean_dialog.dart';
import 'app_info.dart';

mixin GenericFunctions {
  logIfDebug(Object? object) {
    if (kDebugMode) {
      debugPrint('$runtimeType\t$object');
      // dev.log('$object', name: '$runtimeType '
      //   '${getFormattedNow(seconds: true)}'/*, error: '$object'*/);
    }
  }

  /// This method simply finds out the current focus, checks if it has the
  /// primary focus or not:
  /// If no => take the focus away (hide keyboard)
  /// If yes => do nothing because if we call unfocus() when the node has
  /// primary focus, an exception is thrown.
  /// See https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
  void hideKeyboardG(BuildContext context) {
    FocusScopeNode currentNode = FocusScope.of(context);
    if (!currentNode.hasPrimaryFocus) currentNode.unfocus();
  }

  void vibrateG() {
    if (AppInfo.isVibrationEnabled) {
      Vibration.vibrate(duration: Constants.vibrateDuration);
    }
  }

  Future<void> initShare(
    String title,
    String message,
    String subject,
  ) async {
    Share.share(message, subject: subject);
  }

  openUrlString(
    String urlString, {
    String errMsg = 'Link error!',
    LaunchMode launchMode = LaunchMode.externalApplication,
  }) async =>
      launchUrlString(urlString, mode: launchMode).then((value) {
        if (!value) {
          serveFreshToast(errMsg);
        }
      });

  initRateApp(String appId) {
    logIfDebug('rateApp:$appId');
    if (Platform.isAndroid || Platform.isIOS) {
      Uri url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );

      openUrl(url).catchError((err) {
        logIfDebug('Error: $err');
        url = Uri.parse(
          Platform.isAndroid
              ? "https://play.google.com/store/apps/details?id=$appId"
              : "https://apps.apple.com/app/id$appId",
        );
        return openUrl(url);
      });
    }
  }

  showSnackBar(BuildContext context, String text,
      {String? actionLabel, Function()? onPressed}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        action: actionLabel != null && onPressed != null
            ? SnackBarAction(label: actionLabel, onPressed: onPressed)
            : null,
      ),
    );
  }

  initSendEmail(String address,
      {String? subject, String? body, String? errMsg}) {
    String addressUri = Uri.encodeComponent(address);
    String subjectUri = subject != null ? Uri.encodeComponent(subject) : '';
    String bodyUri = body != null ? Uri.encodeComponent(body) : '';
    Uri mail =
        Uri.parse("mailto:$addressUri?subject=$subjectUri&body=$bodyUri");
    logIfDebug('Uri:$mail');
    openUrl(mail).catchError((err) {
      logIfDebug('Error:$err');
      if (errMsg != null) serveFreshToast(errMsg);
    });
  }

  Future<bool> openUrl(Uri url) async => launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

  serveFreshToast(String msg,
      {ToastGravity gravity = ToastGravity.BOTTOM}) async {
    await Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepOrange.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Color getColorFromHexCode(String hexCode) =>
      Color(int.parse(hexCode.replaceFirst('#', '0xFF')));

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.r.toInt(), g = color.g.toInt(), b = color.b.toInt();

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  Future<bool?> showBooleanDialog(
    BuildContext context,
    String title,
    String message, {
    bool dismissable = false,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
    IconData? icon,
  }) {
    return showDialog<bool>(
      barrierDismissible: dismissable,
      context: context,
      builder: (context) => BooleanDialog(
        message,
        title: title,
        positiveButtonTitle: positiveButtonTitle,
        negativeButtonTitle: negativeButtonTitle,
        icon: icon,
      ),
    );
  }

  Future<bool?> showInfoDialog(BuildContext context, String message,
      {String? title, bool dismissable = false, IconData? icon}) {
    return showDialog<bool>(
      barrierDismissible: dismissable,
      context: context,
      builder: (context) => InfoDialog(message, title: title, icon: icon),
    );
  }

  Future<B?> showBottomDialog<B>(
      BuildContext context, List<BottomDialogOption> options,
      {String? title}) {
    const BorderRadius borderRadius = BorderRadius.vertical(
      top: Radius.circular(24.0),
    );
    return showModalBottomSheet<B>(
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: _getOptionViews(title, options, borderRadius),
        );
      },
    );
  }

  List<Widget> _getOptionViews(String? title, List<BottomDialogOption> options,
      BorderRadius borderRadius) {
    List<Widget> views = <Widget>[];
    if (title != null) {
      views.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: baseFontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    for (int x = 0; x < options.length; x++) {
      var option = options[x];
      BorderRadius? bRadius = (x == 0 && title == null) ? borderRadius : null;
      double topPadding = (x == 0 && title == null) ? 8.0 : 0.0;
      views.add(_getOptionView(option, bRadius, topPadding));
    }

    return views;
  }

  Widget _getOptionView(BottomDialogOption option, BorderRadius? borderRadius,
      double topPadding) {
    return InkWell(
      borderRadius: borderRadius,
      onTap: option.onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.0, topPadding, 8.0, 0.0),
        child: ListTile(
          leading: option.icon == null
              ? null
              : Icon(
                  option.icon,
                ),
          title: Text(
            option.title,
            style: TextStyle(
              fontFamily: baseFontFamily,
            ),
          ),
        ),
      ),
    );
  }

  openSearchPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchPage()),
    );
  }

  bool get isDebug => kDebugMode;

  String get baseIconPath => 'assets/images/playstore.png';

  String get baseFontFamily => 'Open Sans';

  FontWeight get weightMedium => FontWeight.w500;

  FontWeight get weightSemiBold => FontWeight.w600;

  FontWeight get weightBold => FontWeight.w700;

  double get titleSize => 20.0;

  double get subtitleSize => 16.0;

  Color? get titleColor => Colors.blueGrey[700];

  TextStyle get appbarTitleStyle => TextStyle(
        color: titleColor,
        // fontSize: titleSize,
        // fontFamily: baseFontFamily,
        // fontWeight: weightBold,
      );

  Widget getAppbarSubtitle(String subtitle) => Text(
        subtitle,
        style: appbarSubtitleStyle,
      );

  TextStyle get appbarSubtitleStyle => TextStyle(
        color: titleColor,
        // fontSize: subtitleSize,
        // fontFamily: baseFontFamily,
        // fontWeight: weightSemiBold,
      );

  int currentTimeMillis() => DateTime.now().millisecondsSinceEpoch;

  @Deprecated('Only placed here for help')
  String getFormattedDateOld(int millis, {bool seconds = false}) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch(millis));
  }

  String getFormattedDate(DateTime dateTime) =>
      DateFormat('yyyy-MM-dd').format(dateTime);

  String getFormattedNow() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  String getFormattedFutureDate(int days) =>
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: days)));

  String getFormattedPastDate(int days) => DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(Duration(days: days)));

  String getReadableDate(String? formattedDate) {
    return formattedDate == null || formattedDate.isEmpty
        ? ''
        : DateFormat('dd-MM-yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(formattedDate));
  }

  double roundDouble(double value, int places) {
    double mod = math.pow(10.0, places) as double;
    return ((value * mod).round().toDouble() / mod);
  }

  // Generic method for all needs
  String applyCommaAndRound(
      double value, int places, bool applyComma, bool trailingZeroes) {
    String formatter = applyComma ? '#,##0' : '##0';
    String trail = trailingZeroes ? '0' : '#';

    if (places < 0) {
      places = 0;
    } else if (places > 0) {
      if (places > 3) places = 3;
      formatter = '$formatter.';
      for (int i = 0; i < places; i++) {
        formatter = '$formatter$trail';
      }
    }

    return NumberFormat(formatter, 'en_US').format(value);
  }

  String runtimeToString(int minutes) {
    var dur = Duration(minutes: minutes);
    int hours = dur.inHours;
    int min = minutes - hours * 60;
    String separator = hours > 0 && min > 0 ? ' ' : '';
    return '${hours == 0 ? '' : '${hours}h'}$separator${min == 0 ? '' : '${min}m'}';
  }

  String durationToMinSec(Duration dur) {
    var splits = dur.toString().split(':');
    String minutes = splits[1].padLeft(2, '0');
    String seconds = splits[2].split('.')[0].padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // No zero values or trailing decimal zeroes
  String applyCommaAndRoundNoZeroes(double value, int places, bool applyComma,
      {String? replacement}) {
    var result = applyCommaAndRound(value, places, applyComma, false);
    return result == '0' ? replacement ?? '-' : result;
  }

  void enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }
}

extension StringCasingExtension on String {
  String toProperCase() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toProperCase())
      .join(' ');
}

extension Contextual on BuildContext {
  unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
    }
  }
}

extension NullStringExtension on String? {
  bool get isNotNullNorEmpty => (this ?? '').isNotEmpty;

  bool get isNullOrEmpty => (this ?? '').isEmpty;

  bool get isNotNullButEmpty => this != null && this!.isEmpty;
}

extension NullBoolExtension on bool? {
  /// It is basically used to check if a nullable bool is true or not, in a null
  /// safe way.
  /// It applies on a nullable bool and returns a non-null bool
  bool get isNotNullAndTrue => this ?? false;
}

extension IterableExt on Iterable? {
  bool get isNotNullNorEmpty => (this ?? []).isNotEmpty;

  bool get isNullOrEmpty => (this ?? []).isEmpty;

  bool get isNotNullButEmpty => this != null && this!.isEmpty;
}

extension IntIterableExt on Iterable<int> {
  /// returns the max int from a list of integers
  int get max => reduce(math.max);

  /// returns the min int from a list of integers
  int get min => reduce(math.min);
}

extension ColorExt on Color {
  /// Darken a color by [percent] amount (100 = black)
  Color darken2([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(
        a.toInt(), (r * f).round(), (g * f).round(), (b * f).round());
  }

  /// Lighten a color by [percent] amount (100 = white)
  Color lighten2([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        a.toInt(),
        r.toInt() + ((255 - r) * p).round(),
        g.toInt() + ((255 - g.toInt()) * p).round(),
        b.toInt() + ((255 - b.toInt()) * p).round());
  }
}

extension FontWeightExt on FontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
}
