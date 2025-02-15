import 'dart:math';

import 'package:async/async.dart';
import 'package:cinema_scope/providers/configuration_provider.dart';
import 'package:cinema_scope/providers/person_provider.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/person.dart';
import '../models/tv.dart';

abstract class MediaProvider<T extends Media> extends BaseMediaProvider {
  late final List<MediaGenre> allGenres;

  bool isMovie = T.toString() == (Movie).toString();

  List<Keyword> get keywords =>
      (isMovie
          ? (media as Movie?)?.keywords.keywords
          : (media as Tv?)?.keywords.results) ??
      [];

  T? media;

  int _recomPageIndex = 0;

  int get recomPageIndex => _recomPageIndex;

  double? get voteAverage => media?.voteAverage;

  List<Review> get reviews => media?.reviews.results ?? [];

  int get totalReviewsCount => media?.reviews.totalResults ?? 0;

  String get synopsis => media?.overview ?? '';

  String? get homepage => media?.homepage;

  String? get tagline => media?.tagline;

  String? year;

  /// Fields for Similar Titles
  Set<String> genrePairs = {};
  String keywordsString = '';
  String dateGte = '';
  String dateLte = '';

  List<Genre> get genres => media?.genres ?? [];

  List<String> get youtubeKeys => ((media?.videos.results
                  .where((video) =>
                      video.site == 'YouTube' && video.type == 'Trailer')
                  .map((vid) => vid.key)
                  .toList() ??
              <String>[]) +
          (media?.videos.results
                  .where((video) =>
                      video.site == 'YouTube' && video.type == 'Teaser')
                  .map((vid) => vid.key)
                  .toList() ??
              <String>[]))
      .take(2)
      .toList();

  RecommendationData? get recommendationData => media == null
      ? null
      : RecommendationData(media!.id, media!.recommendations);

  int get totalRecomCount => media?.recommendations.totalResults ?? 0;

  List<WatchProvider>? get streamingProviders =>
      media?.watchProviders?.results.wpResult?.flatrate
        ?..sort((a, b) {
          return b.displayPriority.compareTo(a.displayPriority);
        });

  CancelableOperation? _operation;
  CancelableOperation? _moreByLeadOperation;
  CancelableOperation? _moreByGenresOperation;
  CancelableOperation? _moreByDirectorOperation;

  List<CombinedResult>? moreByLead, moreByGenres;
  Tuple2<BasePersonResult, List<CombinedResult>>? moreByDirector;
  Tuple2<BasePersonResult, List<CombinedResult>>? moreByActor;

  Map<String, ThumbnailType> thumbMap = {};

  set recomPageIndex(int index) {
    _recomPageIndex = index;
    notifyListeners();
  }

  set operation(CancelableOperation value) {
    _operation = value;
  }

  String getMediaTitle();

  compileImages() async {
    if (media != null) {
      var imageResult = media!.images;
      List<ImageDetail> images = [];
      images.addAll(imageResult.backdrops
          .map((e) => e.copyWith.imageType(ImageType.backdrop.name)));
      images.addAll(imageResult.posters
          .map((e) => e.copyWith.imageType(ImageType.poster.name)));
      images.addAll(imageResult.logos
          .map((e) => e.copyWith.imageType(ImageType.logo.name)));
      this.images = images
        ..removeWhere((element) => element.filePath.contains('.svg'));
      notifyListeners();
    }
  }

  compileThumbnails() async {
    logIfDebug('isPinned, compileThumbnails called with movie:$media');
    if (media != null) {
      Map<String, ThumbnailType> thumbs = {};
      for (var key in youtubeKeys) {
        thumbs[key] = ThumbnailType.video;
      }
      // if (media!.backdropPath != null) {
      //   thumbs[media!.backdropPath!] = ThumbnailType.image;
      // } else if (media!.images.backdrops.isNotEmpty) {
      //   thumbs[media!.images.backdrops.first.filePath] = ThumbnailType.image;
      // }
      for (var imagePath in media!.images.backdrops.take(2)) {
        thumbs[imagePath.filePath] = ThumbnailType.image;
      }
      logIfDebug('isPinned, thumb:$thumbs');
      if (thumbs.isNotEmpty) thumbMap = thumbs;
      logIfDebug('isPinned, thumbMap:$thumbMap');
      notifyListeners();
    }
  }

  fetchMoreByDirector<C extends BasePersonResult>(
      C director, String department) async {
    _moreByDirectorOperation = CancelableOperation<Person>.fromFuture(
            api.getPersonWithDetail(director.id, append: 'combined_credits'))
        .then((person) {
      var moreByDirector = person.combinedCredits.crew
          .where((media) =>
              media.department == department &&
              media.id != this.media?.id &&
              media.posterPath != null)
          .toSet()
          .map((e) {
        e.dateString = getReadableDate(e.mediaReleaseDate);
        e.yearString = getYearStringFromDate(e.mediaReleaseDate);
        return e;
      }).toList()
        ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
      if (moreByDirector.isNotEmpty) {
        this.moreByDirector = Tuple2(director, moreByDirector);
        notifyListeners();
      }
    });
  }

  fetchMoreByLeadActor<C extends BasePersonResult>(C actor, int order) async {
    _moreByLeadOperation = CancelableOperation<Person>.fromFuture(
            api.getPersonWithDetail(actor.id, append: 'combined_credits'))
        .then((person) {
      var moreByActor = person.combinedCredits.cast
          .where((media) =>
              (media.order ?? 3) <= order &&
              media.id != this.media?.id &&
              media.posterPath != null)
          .map((e) {
        e.dateString = getReadableDate(e.mediaReleaseDate);
        e.yearString = getYearStringFromDate(e.mediaReleaseDate);
        return e;
      }).toList()
        ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
      // logIfDebug('moreByActor:$moreByActor');
      if (moreByActor.isNotEmpty) {
        this.moreByActor = Tuple2(actor, moreByActor);
        notifyListeners();
      }
    });
  }

  /// Movies having at least two genres from the movie in review, having primary
  /// release date falling in a period of 10 years spread around the movie in
  /// question.
  /// Ideal situation would be to have 5 years ahead and 5 behind. However, if
  /// the days ahead are less then 5 years (in case of more recent movies), days
  /// behind are extended beyond 5 years such that the era always spans to 10
  /// years in total
  fetchMoreByGenres() async {
    if (media != null) {
      var releaseDate = (media is Movie
              ? (media as Movie).releaseDate
              : (media as Tv).firstAirDate) ??
          '';
      if (releaseDate.isNotEmpty) {
        var date = DateTime.parse(releaseDate);
        var diffFromNow = DateTime.now().difference(date).inDays;
        var totalDays = 365 * 10; // 10 years
        var daysForward = min(diffFromNow, (365 * 5));
        var daysBackward = totalDays - daysForward;
        dateLte = DateFormat('yyyy-MM-dd')
            .format(date.add(Duration(days: daysForward)));
        dateGte = DateFormat('yyyy-MM-dd')
            .format(date.subtract(Duration(days: daysBackward)));

        var year = getYearFromDate(releaseDate);
        if (year != null) {
          String primaryYear = '$year';
          if (DateTime.now().difference(DateTime.parse('$year-01-01')).inDays <
              (30 * 6)) {
            primaryYear = '$year|${year - 1}';
          }

          var genreIds = media!.genres.map((e) => e.id).toList();
          Set<int> excludedGenreIds = allGenres
              .where((element) => !genreIds.contains(element.id))
              .map((e) => e.id)
              .toSet();
          if (genreIds.length > 2) {
            /// In case of more than two genres, we will create unique pairs of
            /// two genres and the pairs will be joined by ,
            for (int i = 0; i < genreIds.length; i++) {
              var genre = genreIds[i];
              var isLast = genre == genreIds.last;
              if (!isLast) {
                var nextGenres = genreIds.sublist(i + 1);
                for (int i = 0; i < nextGenres.length; i++) {
                  genrePairs.add('$genre,${nextGenres[i]}');
                }
              }
            }
          } else if (genreIds.isNotEmpty) {
            /// In case of two genres, both will be joined by ,
            /// In case of one genre, it alone will be added to the pairs.
            genrePairs.add(genreIds.join(','));
          }

          keywordsString = this.keywords.map((e) => e.id).join('|');
          logIfDebug('genrePairs:$genrePairs');
          logIfDebug('keywords:$keywordsString');
          logIfDebug(
              'dateGte:$dateGte, dateLte:$dateLte, origLang:${media!.originalLanguage}');
          final origLang = media!.originalLanguage;
          if (genrePairs.isNotEmpty) {
            var futures = genrePairs.map((pair) {
              return media is Movie
                  ? api.getMoreMoviesByGenres(
                      pair,
                      dateGte,
                      dateLte,
                      keywordsString,
                      originalLanguage:
                          origLang.startsWith('en') ? origLang : '$origLang|en',
                    )
                  : api.getMoreTvSeriesByGenres(
                      pair,
                      dateGte,
                      dateLte,
                      keywordsString,
                      originalLanguage:
                          origLang.startsWith('en') ? origLang : '$origLang|en',
                    );
            }).toList();

            _moreByGenresOperation =
                CancelableOperation<List<CombinedResults>>.fromFuture(
              Future.wait<CombinedResults>(futures),
            ).then((results) async {
              /// Combine all results into one set
              /// (set would automatically remove duplicates)
              Set<CombinedResult> combinedResults = {};
              logIfDebug('results size:${results.length}');
              for (var result in results) {
                logIfDebug('result size:${result.results.length}');
                combinedResults.addAll(result.results);
              }

              /// Sort the combined results randomly, remove the
              /// currently displayed movie from the list and notify
              /// listeners
              moreByGenres = combinedResults.map((e) {
                e.mediaType ??=
                    media is Movie ? MediaType.movie.name : MediaType.tv.name;
                e.dateString = getReadableDate(e.mediaReleaseDate);
                e.yearString = getYearStringFromDate(e.mediaReleaseDate);
                logIfDebug('title:${e.mediaTitle}');
                return e;
              }).toList()
                    ..removeWhere((element) => element.id == media?.id)
                    ..shuffle() /*
                    ..sort((a, b) {
                      return b.voteAverage.compareTo(a.voteAverage);
                    })*/
                  ;
              logIfDebug('moreByGenres length:${moreByGenres?.length}');

              notifyListeners();
            });
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _operation?.cancel();
    _moreByLeadOperation?.cancel();
    _moreByGenresOperation?.cancel();
    _moreByDirectorOperation?.cancel();
    super.dispose();
  }

// set moreByLeadOperation(CancelableOperation value) {
//   _moreByLeadOperation = value;
// }
//
// set moreByGenresOperation(CancelableOperation value) {
//   _moreByGenresOperation = value;
// }
//
// set moreByDirectorOperation(CancelableOperation value) {
//   _moreByDirectorOperation = value;
// }
}

class MovieViewModel extends MediaProvider<Movie> {
  // Movie? movie;

  String? get runtime {
    var runtime = media?.runtime;
    return runtime == null ? null : runtimeToString(runtime);
  }

  String? certification;

  String? get imdbId => media?.imdbId;

  List<Cast> get cast => media?.credits.cast ?? [];

  List<Crew> get crew => media?.credits.crew ?? [];

  int get totalCastCount => cast.length;

  bool _isTrailerPinned = false;

  bool get isTrailerPinned => _isTrailerPinned;

  set isTrailerPinned(bool value) {
    _isTrailerPinned = value;
    notifyListeners();
  }

  String? _initialVideoId;

  set initialVideoId(String? id) {
    _initialVideoId = id;
    notifyListeners();
  }

  String? get initialVideoId => _initialVideoId;

  // List<String> get youtubeKeys =>
  //     ((media?.videos.results
  //         .where((video) => video.type == 'Trailer')
  //         .map((vid) => vid.key)
  //         .toList() ??
  //         <String>[]) +
  //         (media?.videos.results
  //             .where((video) => video.type == 'Teaser')
  //             .map((vid) => vid.key)
  //             .toList() ??
  //             <String>[]))
  //         .take(3)
  //         .toList();

  MovieViewModel() : super();

  getMovieWithDetail(int id, List<MediaGenre> allGenres,
      {String? leadActors}) async {
    this.allGenres = allGenres;
    operation = CancelableOperation<Movie>.fromFuture(
      api.getMovieWithDetail(id),
    ).then((result) async {
      media = result;
      year = getYearStringFromDate(media!.releaseDate);
      logIfDebug('providers:${media?.watchProviders?.results.wpResult}');
      await _compileCertification();
      notifyListeners();
      _fetchMoreData();
    });
  }

  void _fetchMoreData() async {
    // _fetchMoreByLead();
    _fetchMoreByLeadActor();
    fetchMoreByGenres();
    _fetchMoreByDirector();
    compileThumbnails();
    compileImages();
  }

  _compileCertification() async {
    var usResults = media!.releaseDates.results
        .where((element) => element.iso31661 == Constants.region);
    if (usResults.isNotEmpty) {
      var theatrical = usResults.first.releaseDates;
      if (theatrical.isNotEmpty) certification = theatrical.first.certification;
    }
  }

  // _fetchMoreByLead() async {
  //   if (media != null) {
  //     var leadActors = media!.credits.cast.take(2).map((e) => e.id).join('|');
  //     moreByLeadOperation = CancelableOperation<CombinedResults>.fromFuture(
  //       api.getMoreMoviesByLeadActors(leadActors),
  //     ).then((results) {
  //       moreByLead = results.results
  //         ..removeWhere((element) => element.id == media?.id);
  //       notifyListeners();
  //     });
  //   }
  // }

  _fetchMoreByDirector() async {
    var directors = crew.where((element) {
      return element.job == Constants.departMap[Department.directing.name];
    }).toList();
    if (directors.isNotEmpty) {
      var director = directors[Random().nextInt(directors.length)];
      fetchMoreByDirector<Crew>(director, director.department);
    }
  }

  _fetchMoreByLeadActor() async {
    var actors = cast.take(3).toList();
    if (actors.isNotEmpty) {
      var actor = actors[Random().nextInt(actors.length)];
      fetchMoreByLeadActor<Cast>(actor, actor.order);
    }
  }

  @override
  String getMediaTitle() {
    return media!.movieTitle;
  }
}

enum ThumbnailType {
  video,
  image,
}
