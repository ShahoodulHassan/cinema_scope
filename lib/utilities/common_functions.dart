import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/search.dart';
import '../pages/movie_page.dart';
import '../pages/movies_list_page.dart';

mixin CommonFunctions on Utilities {

  goToMoviePage(BuildContext context, MovieResult movie, {String? destUrl}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoviePage(
            id: movie.id,
            title: movie.movieTitle,
            year: getYearStringFromDate(movie.releaseDate),
            voteAverage: movie.voteAverage,
            overview: movie.overview,
            sourceUrl: null,
            destUrl: destUrl,
            heroImageTag: ''),
      ),
    ).then((value) {});
  }

  goToMovieListPage(BuildContext context,
      {List<Keyword>? keywords, List<Genre>? genres, int? mediaId,}) {
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

}