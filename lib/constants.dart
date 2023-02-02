

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

  static const String pkApiConfig = 'pk_api_config';
  static const String pkCountryConfig = 'pk_country_config';
  static const String pkLanguageConfig = 'pk_language_config';
  static const String pkTranslationConfig = 'pk_translation_config';
  static const String pkCombinedGenres = 'pk_combined_genres';
  static const String pkConfigStoreDate = 'pk_config_store_date';

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