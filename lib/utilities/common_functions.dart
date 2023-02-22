import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/search.dart';
import '../pages/movie_page.dart';
import '../pages/movies_list_page.dart';
import '../pages/person_page.dart';
import '../pages/tv_page.dart';

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

  goToMovieListPage(
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
