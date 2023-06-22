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

  static const double cardMargin = 4.0;
  static const double posterWidth = 100.0;
  static const double posterVPadding = 8.0;
  static const double posterWidthFactor = 0.25;

  static const String moviePageHeroTag = 'movie_page_hero';

  static const String placeholderPath = 'assets/images/placeholder.png';

  static const String imdbPersonUrl = 'https://www.imdb.com/name/';
  static const String imdbTitleUrl = 'https://www.imdb.com/title/';
  static const String twitterBaseUrl = 'https://twitter.com/';
  static const String facebookBaseUrl = 'https://www.facebook.com/';
  static const String instagramBaseUrl = 'https://www.instagram.com/';

  static const String pkApiConfig = 'pk_api_config';
  static const String pkCountryConfig = 'pk_country_config';
  static const String pkLanguageConfig = 'pk_language_config';
  static const String pkTranslationConfig = 'pk_translation_config';
  static const String pkCombinedGenres = 'pk_combined_genres';
  static const String pkConfigStoreDate = 'pk_config_store_date';

  static const String pkRegion = 'pk_region';


  static final Map<String, String> departMap = {
    Department.acting.name: 'Actor',
    Department.directing.name: 'Director',
    Department.editing.name: 'Editor',
    Department.production.name: 'Producer',
    Department.writing.name: 'Writer',
  };

  // TODO Create user preferences for region
  /// Later to be replaced with a value from shared_preferences as per user
  /// preference
  static const String region = 'US';

}

enum MediaType {
  all,
  movie,
  tv,
  season,
  episode,
  person,
}

enum TimeWindow {
  day,
  week,
}

enum Department {
  acting('Acting'),
  directing('Directing'),
  editing('Editing'),
  production('Production'),
  writing('Writing'),
  crew('Crew');

  final String name;

  const Department(this.name);
}
