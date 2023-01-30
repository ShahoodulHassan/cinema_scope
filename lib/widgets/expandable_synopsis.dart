import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../architecture/movie_view_model.dart';
import '../utilities/generic_functions.dart';

class ExpandableSynopsis extends StatefulWidget {

  final String? overview;

  const ExpandableSynopsis(this.overview, {Key? key}) : super(key: key);

  @override
  State<ExpandableSynopsis> createState() => _ExpandableSynopsisState();
}

class _ExpandableSynopsisState extends State<ExpandableSynopsis>
    with GenericFunctions {
  final colSize = 14.5;
  final expSize = 16.5;
  final colHeight = 1.2;
  final expHeight = 1.3;
  late var height = expHeight;
  late var fontSize = expSize;

  @override
  Widget build(BuildContext context) {
    logIfDebug(
        'build called with movie:${context.read<MovieViewModel>().movie}');
    if (widget.overview != null && widget.overview!.isNotEmpty) {
      return Padding(
        padding:
        const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
        child: ExpandableText(
          widget.overview!,
          expandText: 'Show more',
          collapseText: 'Show less',
          expanded: true,
          maxLines: 3,
          linkColor: Colors.blue.shade600,
          animation: true,
          animationCurve: Curves.fastOutSlowIn,
          expandOnTextTap: true,
          collapseOnTextTap: true,
          onExpandedChanged: (isExpanded) {
            setState(() {
              height = isExpanded ? expHeight : colHeight;
              fontSize = isExpanded ? expSize : colSize;
            });
          },
          style: TextStyle(height: height, fontSize: fontSize),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}