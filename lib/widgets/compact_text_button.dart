import 'package:flutter/material.dart';

class CompactTextButton extends StatelessWidget {

  final String title;
  final Function()? onPressed;

  const CompactTextButton(this.title, {required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all<Size>(Size.zero),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          // color: Theme.of(context).colorScheme.primary,
          // height: 1.1,
        ),
      ),
    );
  }
}