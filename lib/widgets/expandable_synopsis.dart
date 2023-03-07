import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

import '../utilities/generic_functions.dart';

class ExpandableSynopsis extends StatefulWidget {
  final String? overview;
  final int maxLines;
  final bool expanded;
  final bool changeSize;

  final double horizontal, vertical;

  const ExpandableSynopsis(
    this.overview, {
    this.maxLines = 6,
    this.expanded = true,
    this.changeSize = true,
    this.horizontal = 16.0,
    this.vertical = 8.0,
    Key? key,
  }) : super(key: key);

  @override
  State<ExpandableSynopsis> createState() => _ExpandableSynopsisState();
}

class _ExpandableSynopsisState extends State<ExpandableSynopsis>
    with GenericFunctions {
  final expandedFontSize = 16.0;
  late final collapsedFontSize = expandedFontSize - (widget.changeSize ? 2 : 0);
  final expandedHeight = 1.3;
  late final collapsedHeight = expandedHeight - (widget.changeSize ? 0.1 : 0);
  late var height = widget.expanded ? expandedHeight : collapsedHeight;
  late var fontSize = widget.expanded ? expandedFontSize : collapsedFontSize;

  @override
  Widget build(BuildContext context) {
    // logIfDebug(
    //     'build called with movie:${context.read<MovieViewModel>().movie}');
    if (widget.overview != null && widget.overview!.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.horizontal,
          vertical: widget.vertical,
        ),
        child: ExpandableText(
          widget.overview!,
          expandText: 'Show more',
          collapseText: 'Show less',
          expanded: widget.expanded,
          maxLines: widget.maxLines,
          linkColor: Colors.blue.shade600,
          animation: true,
          animationCurve: Curves.fastOutSlowIn,
          expandOnTextTap: true,
          collapseOnTextTap: true,
          onExpandedChanged: (isExpanded) {
            if (widget.changeSize) {
              setState(() {
                height = isExpanded ? expandedHeight : collapsedHeight;
                fontSize = isExpanded ? expandedFontSize : collapsedFontSize;
              });
            }
          },
          style: TextStyle(height: height, fontSize: fontSize),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
