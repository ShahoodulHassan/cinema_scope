import 'package:flutter/material.dart';

class InkWellOverlay extends StatelessWidget {
  final Function()? onTap;
  final BorderRadius? borderRadius;
  final Widget child;

  const InkWellOverlay({
    required this.onTap,
    this.borderRadius,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}