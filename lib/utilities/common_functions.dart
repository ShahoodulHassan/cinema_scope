import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/search.dart';
import '../pages/movie_page.dart';
import '../pages/movies_list_page.dart';
import '../pages/person_page.dart';

mixin CommonFunctions on Utilities {

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

  goToMovieListPage(
    BuildContext context, {
    List<Keyword>? keywords,
    List<Genre>? genres,
    int? mediaId,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) {
        return MoviesListPage(
          mediaType: MediaType.movie,
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
