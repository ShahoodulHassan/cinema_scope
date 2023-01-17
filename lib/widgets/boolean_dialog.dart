import 'package:flutter/material.dart';

import '../constants.dart';
import '../utilities/generic_functions.dart';

class InfoDialog extends StatelessWidget with GenericFunctions {
  final String? title;
  final String message;

  final bool isNegativeButtonRequired;
  final String positiveButtonTitle;
  final String negativeButtonTitle;

  final IconData? icon;

  /// See how we are receiving a nullable value in the constructor and passing
  /// it to the null safe member variables such that if the received value is
  /// null, a default value is given
  InfoDialog(
    this.message, {
    this.title,
    Key? key,
    this.isNegativeButtonRequired = false,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
    this.icon,
  })  : positiveButtonTitle = positiveButtonTitle ?? 'OK',
        negativeButtonTitle = negativeButtonTitle ?? 'CANCEL',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // AlertDialog's child has been wrapped in a SizedBox with finite
    // width in order to avoid this error caused when we try to set the
    // width of dropdown items https://stackoverflow.com/a/60896702/7983864
    return buildAlertDialog(context);
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: title == null
          ? null
          : Text(
              title!,
              style: TextStyle(
                fontFamily: baseFontFamily,
              ),
            ),
      // Default is 0 bottom and 24 on 3 sides; we changed it to 20
      // titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),

      icon: icon == null ? null : Icon(icon),

      // Default is 20 to and 24 on 3 sides; we changed all to 20
      contentPadding: const EdgeInsets.all(20.0),

      // Default is 8 on all sides, we just removed top padding.
      actionsPadding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      content: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(
              fontFamily: baseFontFamily,
            ),
          ),
        ),
      ),
      actions: getActionButtons(context),
    );
  }

  List<Widget> getActionButtons(BuildContext context) {
    return [
      buildNegativeButton(context),
      buildPositiveButton(context),
    ];
  }

  Widget buildPositiveButton(BuildContext context, {Function()? onPressed}) {
    return TextButton(
      onPressed: onPressed ?? () => Navigator.pop(context),
      child: Text(
        positiveButtonTitle,
        style: TextStyle(
          color: Constants.accentColor,
          fontFamily: baseFontFamily,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildNegativeButton(BuildContext context, {Function()? onPressed}) {
    return Visibility(
      visible: isNegativeButtonRequired,
      child: TextButton(
        onPressed: onPressed ?? () => Navigator.pop(context),
        // color: Colors.red,
        // textColor: Colors.white,
        child: Text(
          negativeButtonTitle,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontFamily: baseFontFamily,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

class BooleanDialog extends InfoDialog {
  /// See how we are receiving a nullable value in the constructor and passing
  /// it to the null safe parent / super member variables such that if the
  /// received value is null, a default value is given.
  BooleanDialog(
    super.message, {
    required super.title,
    super.key,
    super.isNegativeButtonRequired = true,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
    super.icon,
  }) : super(
            positiveButtonTitle: positiveButtonTitle ?? 'YES',
            negativeButtonTitle: negativeButtonTitle ?? 'NO');

  @override
  List<Widget> getActionButtons(BuildContext context) {
    return [
      buildNegativeButton(context,
          onPressed: () => Navigator.pop(context, false)),
      buildPositiveButton(context,
          onPressed: () => Navigator.pop(context, true)),
    ];
  }
}

class BottomDialogOption {
  final String title;
  final IconData? icon;
  final Function() onTap;

  BottomDialogOption(this.title, this.onTap, {this.icon});
}
