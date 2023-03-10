import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/search.dart';
import '../pages/movie_page.dart';
import '../pages/movies_list_page.dart';
import '../pages/person_page.dart';
import '../pages/tv_page.dart';
import '../widgets/ink_well_overlay.dart';

mixin CommonFunctions on Utilities {
  @Deprecated('No need for a new slightly different method')
  goToMoviePageByMovieResult(
    BuildContext context,
    MovieResult movie, {
    String? destUrl,
  }) =>
      goToMoviePage(
        context,
        id: movie.id,
        title: movie.movieTitle,
        releaseDate: movie.releaseDate,
        voteAverage: movie.voteAverage,
        overview: movie.overview,
      );

  goToMoviePage(
    BuildContext context, {
    required int id,
    required String title,
    required String? releaseDate,
    required double voteAverage,
    required String? overview,
    String? destUrl,
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
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) {
        return MoviesListPage(
          mediaType: mediaType,
          keywords: keywords,
          genres: genres,
          mediaId: mediaId,
        );
      }),
    );
  }

  /// This method expects a non-empty list of genres
  Widget getGenreView<M extends Media>(List<Genre> genres) {
    // final genres = movie.genres;
    var isTv = M.toString() == MediaType.tv.name;
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
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.17),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Text(
                  genre.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
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

  Widget getSectionSeparator(BuildContext context) => Container(
    height: 1.0,
    color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
  );

  Color getScaffoldColor(BuildContext context) =>
      lighten2(Theme.of(context).colorScheme.primaryContainer, 75);

  Widget getIconButton(
    BuildContext context,
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
}
