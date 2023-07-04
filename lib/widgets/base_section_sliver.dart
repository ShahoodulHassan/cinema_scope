import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../utilities/common_functions.dart';
import '../utilities/utilities.dart';
import 'compact_text_button.dart';

class BaseSectionSliver extends StatelessWidget with Utilities, CommonFunctions {
  final String title;
  final List<Widget> children;

  final bool showSeeAll;
  final Function()? onPressed;
  final String buttonText;

  const BaseSectionSliver({
    required this.title,
    required this.children,
    this.showSeeAll = false,
    this.buttonText = 'See all',
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      sliver: SliverStack(
        children: [
          /// This serves as the base card on which the content card is
          /// stacked. The fill constructor helps match its height with
          /// the height of the content card.
          const SliverPositioned.fill(
            child: Card(
              elevation: 5.0,
              color: Colors.white,
              surfaceTintColor: Colors.white,
              margin: EdgeInsets.zero,
              shape: ContinuousRectangleBorder(),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sectionSeparator,
                getSectionTitleRow(),
                ...children,
                sectionSeparator,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSectionTitleRow() => Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            // height: 1.1,
          ),
        ),
        if (showSeeAll) CompactTextButton(buttonText, onPressed: onPressed),
      ],
    ),
  );
}