import 'package:cinema_scope/models/similar_titles_params.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../main.dart';
import '../models/movie.dart';
import '../models/search.dart';
import '../pages/movie_page.dart';
import '../pages/movies_list_page.dart';
import '../pages/person_page.dart';
import '../pages/tv_page.dart';
import '../widgets/ink_well_overlay.dart';

mixin CommonFunctions on Utilities, GenericFunctions {
  goToMoviePage(
    BuildContext context, {
    required int id,
    required String title,
    required String? releaseDate,
    required double voteAverage,
    required String? overview,
    String? destUrl,
    String? backdrop,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoviePage(
            id: id,
            title: title,
            year: getYearStringFromDate(releaseDate),
            voteAverage: voteAverage,
            overview: overview,
            sourceUrl: null,
            destUrl: destUrl,
            backdrop: backdrop,
            heroImageTag: ''),
      ),
    ).then((value) {});
  }

  goToTvPage(
    BuildContext context, {
    required int id,
    required String title,
    required String? releaseDate,
    required double voteAverage,
    required String? overview,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TvPage(
            id: id,
            title: title,
            year: getYearStringFromDate(releaseDate),
            voteAverage: voteAverage,
            overview: overview,
            heroImageTag: ''),
      ),
    ).then((value) {});
  }

  goToMediaListPage(
    BuildContext context, {
    required MediaType mediaType,
    List<Keyword>? keywords,
    List<Genre>? genres,
    int? mediaId,
    SimilarTitlesParams? similarTitlesParams,
    String? mediaTitle,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) {
        return MoviesListPage(
          mediaType: mediaType,
          keywords: keywords,
          genres: genres,
          mediaId: mediaId,
          similarTitlesParams: similarTitlesParams,
          mediaTitle: mediaTitle,
        );
      }),
    );
  }

  /// This method expects a non-empty list of genres
  Widget getGenreView<M extends Media>(List<Genre> genres) {
    // final genres = movie.genres;
    var isTv = M.toString().toLowerCase() == MediaType.tv.name;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          separatorBuilder: (_, index) => const SizedBox(width: 8),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            final genre = genres[index];
            return InkWellOverlay(
              onTap: () {
                goToMediaListPage(
                  context,
                  mediaType: isTv ? MediaType.tv : MediaType.movie,
                  genres: [genre],
                );
              },
              borderRadius: BorderRadius.circular(6.0),
              child: Chip(
                backgroundColor: kPrimary.withOpacity(0.07),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Text(
                  genre.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: kPrimary,
                  ),
                ),
                side: BorderSide(
                  color: kPrimary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            );
          },
          itemCount: genres.length,
        ),
      ),
    );
  }

  Widget get sectionSeparator => Container(
        height: 1.0,
        color: kPrimary.withOpacity(0.6),
      );

  Color get scaffoldColor => kPrimaryContainer.lighten2(75);

  Widget getIconButton(
    Widget icon,
    Function() onPressed, {
    Color? color,
    double iconSize = 24.0,
  }) =>
      IconButton(
        onPressed: onPressed,
        icon: icon,
        iconSize: iconSize,
        color: color,
        // padding: EdgeInsets.zero,
        // visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
      );

  void goToPersonPage(BuildContext context, BasePersonResult person) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonPage(
          id: person.id,
          name: person.name,
          gender: person.gender,
          profilePath: person.profilePath,
          knownForDepartment: person.knownForDepartment,
        ),
      ),
    );
  }

  String getGenderText(int? gender) {
    if (gender == null) return '-';
    switch (gender) {
      case 1:
        return 'Female';
      case 2:
        return 'Male';
      default:
        return '-';
    }
  }

  String departmentToRole(String department) =>
      Constants.departMap[department] ?? department;

  /// Since I found the bug reported in
  /// https://www.themoviedb.org/talk/63ea28b1a2e60200932b0343, I've decided to
  /// not rely on the genre segregation made by the API.
  String getGenreNamesFromIds(
    List<MediaGenre> combinedGenres,
    List<int> genreIds,
    MediaType mediaType,
  ) {
    return (genreIds.map((id) {
      var genres = combinedGenres
          .where((genre) => genre.mediaType == mediaType && genre.id == id);
      if (genres.isNotEmpty) return genres.first.name;
    }).toList()
          ..removeWhere((element) => element == null))
        .join(', ');
  }

  openImdbParentalGuide(String imdbId) {
    openUrlString(
      '${Constants.imdbTitleUrl}$imdbId/parentalguide',
      launchMode: LaunchMode.inAppWebView,
    );
  }
}
