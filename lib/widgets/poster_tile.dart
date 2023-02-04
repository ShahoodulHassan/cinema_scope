import 'package:cinema_scope/widgets/ink_well_overlay.dart';
import 'package:flutter/material.dart';

class PosterTile extends StatelessWidget {
  final double posterWidthRatio = 0.25;
  final Function()? onTap;
  final String title;
  final int titleMaxLines;
  final Widget poster;
  final Widget? subtitle, description;

  const PosterTile({
    required this.title,
    this.titleMaxLines = 2,
    required this.poster,
    this.subtitle,
    this.description,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellOverlay(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width) * posterWidthRatio,
                // height: (MediaQuery.of(context).size.width) * 0.25 / Constants.arPoster,
                child: poster,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: titleMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          height: 1.2,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SizedBox(height: 0.0),
                      if (subtitle != null) subtitle!,
                      if (description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: description!,
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
