

import 'package:flutter/material.dart';

class Constants {
  static const int vibrateDuration = 250;

  static Color accentColor = Colors.deepOrange.shade800;
  static Color scaffoldColor = const Color(0xFFf4fafe);
  static Color ratingIconColor = Colors.yellow.shade700;

  static const double arBackdrop = 780 / 439;
  static const double arPoster = 780 / 1170;
  static const double arProfile = 185 / 278;
  static const double arAvatar = 185 / 185;

  static const String moviePageHeroTag = 'movie_page_hero';

  static const String placeholderPath = 'assets/images/placeholder.png';

}

enum MediaType {
  all,
  movie,
  tv,
  people,

}

enum TimeWindow {
  day,
  week,

}