import 'dart:math';

import 'package:async/async.dart';
import 'package:cinema_scope/architecture/config_view_model.dart';
import 'package:cinema_scope/architecture/person_view_model.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/person.dart';
import '../models/tv.dart';

abstract class MediaViewModel<T extends Media> extends BaseMediaViewModel {
  late final List<MediaGenre> allGenres;

  T? media;

  int _recomPageIndex = 0;

  int get recomPageIndex => _recomPageIndex;

  double? get voteAverage => media?.voteAverage;

  List<Review> get reviews => media?.reviews.results ?? [];

  int get totalReviewsCount => media?.reviews.totalResults ?? 0;

  String get synopsis => media?.overview ?? '';

  String? get homepage => media?.homepage;

  String? get tagline => media?.tagline;

  List<Genre> get genres => media?.genres ?? [];

  TvRecommendationData? get recommendationData =>
      media == null
          ? null
          : TvRecommendationData(media!.id, media!.recommendations);

  int get totalRecomCount => media?.recommendations.totalResults ?? 0;

  CancelableOperation? _operation;
  CancelableOperation? _moreByLeadOperation;
  CancelableOperation? _moreByGenresOperation;
  CancelableOperation? _moreByDirectorOperation;

  List<CombinedResult>? moreByLead, moreByGenres;
  Tuple2<BasePersonResult, List<CombinedResult>>? moreByDirector;
  Tuple2<BasePersonResult, List<CombinedResult>>? moreByActor;

  set recomPageIndex(int index) {
    _recomPageIndex = index;
    notifyListeners();
  }

  set operation(CancelableOperation value) {
    _operation = value;
  }

  fetchMoreByDirector<C extends BasePersonResult>(C director,
      String department) async {
    moreByDirectorOperation = CancelableOperation<Person>.fromFuture(
        api.getPersonWithDetail(director.id, append: 'combined_credits'))
        .then((person) {
      var moreByDirector = person.combinedCredits.crew
          .where((media) =>
      media.department == department &&
          media.id != this.media?.id &&
          media.posterPath != null)
          .toList()
        ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
      if (moreByDirector.isNotEmpty) {
        this.moreByDirector = Tuple2(director, moreByDirector);
        notifyListeners();
      }
    });
  }

  fetchMoreByLeadActor<C extends BasePersonResult>(C actor, int order) async {
    moreByLeadOperation = CancelableOperation<Person>.fromFuture(
        api.getPersonWithDetail(actor.id, append: 'combined_credits'))
        .then((person) {
      var moreByActor = person.combinedCredits.cast
          .where((media) =>
      (media.order ?? 3) <= order &&
          media.id != this.media?.id &&
          media.posterPath != null)
          .toList()
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
        var diffFromNow = DateTime
            .now()
            .difference(date)
            .inDays;
        var totalDays = 365 * 10; // 10 years
        var daysForward = min(diffFromNow, (365 * 5));
        var daysBackward = totalDays - daysForward;
        var dateLte = DateFormat('yyyy-MM-dd')
            .format(date.add(Duration(days: daysForward)));
        var dateGte = DateFormat('yyyy-MM-dd')
            .format(date.subtract(Duration(days: daysBackward)));

        var year = getYearFromDate(releaseDate);
        if (year != null) {
          String primaryYear = '$year';
          if (DateTime
              .now()
              .difference(DateTime.parse('$year-01-01'))
              .inDays <
              (30 * 6)) {
            primaryYear = '$year|${year - 1}';
          }

          Set<String> pairs = {};
          var genreIds = media!.genres.map((e) => e.id).toList();
          Set<int> excludedGenreIds = allGenres
              .where((element) => !genreIds.contains(element.id))
              .map((e) => e.id)
              .toSet();
          if (genreIds.length > 2) {
            /// In case of more than two genres, the pairs will be joined by ,
            for (int i = 0; i < genreIds.length; i++) {
              var genre = genreIds[i];
              var isLast = genre == genreIds.last;
              if (!isLast) {
                var nextGenres = genreIds.sublist(i + 1);
                for (int i = 0; i < nextGenres.length; i++) {
                  pairs.add('$genre,${nextGenres[i]}');
                }
              }
            }
          } else if (genreIds.isNotEmpty) {
            /// In case of two genres, both will be joined by ,
            /// In case of one genre, it alone will be added to the pairs.
            pairs.add(genreIds.join(','));
          }

          // var keywords = media!.keywords.keywords.map((e) => e.id).join(',');
          logIfDebug('genrePairs:$pairs');

          if (pairs.isNotEmpty) {
            List<Future<CombinedResults>> futures = pairs.map((pair) {
              return media is Movie
                  ? api.getMoreMoviesByGenres(
                pair,
                dateGte,
                dateLte,
              )
                  : api.getMoreTvSeriesByGenres(
                pair,
                dateGte,
                dateLte,
              );
            }).toList();

            moreByGenresOperation =
                CancelableOperation<List<CombinedResults>>.fromFuture(
                  Future.wait(futures),
                ).then((results) {
                  /// Combine all results into one set
                  /// (set would automatically remove duplicates)
                  Set<CombinedResult> combinedResults = {};
                  for (var result in results) {
                    combinedResults.addAll(result.results);
                  }

                  /// Sort the combined results by vote average, remove the
                  /// currently displayed movie from the list and notify
                  /// listeners
                  moreByGenres = combinedResults.map((e) {
                    e.mediaType ??=
                    media is Movie ? MediaType.movie.name : MediaType.tv.name;
                    return e;
                  }).toList()..removeWhere((element) => element.id == media?.id)
                    ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
                  // moreByGenres = combinedResults.toList()
                  //   ..removeWhere((element) => element.id == media?.id)
                  //   ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
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

  set moreByLeadOperation(CancelableOperation value) {
    _moreByLeadOperation = value;
  }

  set moreByGenresOperation(CancelableOperation value) {
    _moreByGenresOperation = value;
  }

  set moreByDirectorOperation(CancelableOperation value) {
    _moreByDirectorOperation = value;
  }
}

class MovieViewModel extends MediaViewModel<Movie> {
  // Movie? movie;

  String? year;

  String? get runtime {
    var runtime = media?.runtime;
    return runtime == null ? null : runtimeToString(runtime);
  }

  String? certification;

  String? get imdbId => media?.imdbId;

  // RecommendationData? get recommendationData => movie == null
  //     ? null
  //     : RecommendationData(movie!.id, movie!.recommendations);

  // List<MovieResult> get recommendations =>
  //     (movie?.recommendations.results
  //       ?..removeWhere((element) => element.posterPath == null)) ??
  //     [];

  List<Cast> get cast => media?.credits.cast ?? [];

  List<Crew> get crew => media?.credits.crew ?? [];

  int get totalCastCount => cast.length;

  List<Keyword> get keywords => media?.keywords.keywords ?? [];

  bool _isTrailerPinned = false;

  bool get isTrailerPinned => _isTrailerPinned;

  List<ImageDetail> thumbnails = <ImageDetail>[];

  Map<String, ThumbnailType> thumbMap = {};

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

  List<String> get youtubeKeys =>
      ((media?.videos.results
          .where((video) => video.type == 'Trailer')
          .map((vid) => vid.key)
          .toList() ??
          <String>[]) +
          (media?.videos.results
              .where((video) => video.type == 'Teaser')
              .map((vid) => vid.key)
              .toList() ??
              <String>[]))
          .take(3)
          .toList();

  MovieViewModel() : super();

  getMovieWithDetail(int id, List<MediaGenre> allGenres,
      {String? leadActors}) async {
    this.allGenres = allGenres;
    operation = CancelableOperation<Movie>.fromFuture(
      api.getMovieWithDetail(id),
    ).then((result) async {
      media = result;
      year = getYearStringFromDate(media!.releaseDate);
      await _compileCertification();
      notifyListeners();
      _fetchMoreData();
    });
  }

  void _fetchMoreData() async {
    _fetchMoreByLead();
    _fetchMoreByLeadActor();
    fetchMoreByGenres();
    _fetchMoreByDirector();
    _compileThumbnails();
    _compileImages();
  }

  _compileCertification() async {
    var usResults = media!.releaseDates.results
        .where((element) => element.iso31661 == Constants.region);
    if (usResults.isNotEmpty) {
      var theatrical = usResults.first.releaseDates;
      if (theatrical.isNotEmpty) certification = theatrical.first.certification;
    }
  }

  _fetchMoreByLead() async {
    if (media != null) {
      var leadActors = media!.credits.cast.take(2).map((e) => e.id).join('|');
      moreByLeadOperation = CancelableOperation<CombinedResults>.fromFuture(
        api.getMoreMoviesByLeadActors(leadActors),
      ).then((results) {
        moreByLead = results.results
          ..removeWhere((element) => element.id == media?.id);
        notifyListeners();
      });
    }
  }

  _fetchMoreByDirector() async {
    var directors = crew.where((element) {
      return element.job == Constants.departMap[Department.directing.name];
    });
    if (directors.isNotEmpty) {
      var director = directors.first;
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

  /// Movies having at least two genres from the movie in review, having primary
  /// release date falling in a period of 10 years spread around the movie in
  /// question.
  /// Ideal situation would be to have 5 years ahead and 5 behind. However, if
  /// the days ahead are less then 5 years (in case of more recent movies), days
  /// behind are extended beyond 5 years such that the era always spans to 10
  /// years in total
  _fetchMoreByGenres() async {
    if (media != null) {
      var releaseDate = media!.releaseDate ?? '';
      if (releaseDate.isNotEmpty) {
        var date = DateTime.parse(releaseDate);
        var diffFromNow = DateTime
            .now()
            .difference(date)
            .inDays;
        var totalDays = 365 * 10; // 10 years
        var daysForward = min(diffFromNow, (365 * 5));
        var daysBackward = totalDays - daysForward;
        var dateLte = DateFormat('yyyy-MM-dd')
            .format(date.add(Duration(days: daysForward)));
        var dateGte = DateFormat('yyyy-MM-dd')
            .format(date.subtract(Duration(days: daysBackward)));

        var year = getYearFromDate(releaseDate);
        if (year != null) {
          String primaryYear = '$year';
          if (DateTime
              .now()
              .difference(DateTime.parse('$year-01-01'))
              .inDays <
              (30 * 6)) {
            primaryYear = '$year|${year - 1}';
          }

          Set<String> pairs = {};
          var genreIds = media!.genres.map((e) => e.id).toList();
          Set<int> excludedGenreIds = allGenres
              .where((element) => !genreIds.contains(element.id))
              .map((e) => e.id)
              .toSet();
          if (genreIds.length > 2) {
            /// In case of more than two genres, the pairs will be joined by ,
            for (int i = 0; i < genreIds.length; i++) {
              var genre = genreIds[i];
              var isLast = genre == genreIds.last;
              if (!isLast) {
                var nextGenres = genreIds.sublist(i + 1);
                for (int i = 0; i < nextGenres.length; i++) {
                  pairs.add('$genre,${nextGenres[i]}');
                }
              }
            }
          } else if (genreIds.isNotEmpty) {
            /// In case of two genres, both will be joined by ,
            /// In case of one genre, it alone will be added to the pairs.
            pairs.add(genreIds.join(','));
          }

          var keywords = media!.keywords.keywords.map((e) => e.id).join(',');
          logIfDebug('genrePairs:$pairs');

          if (pairs.isNotEmpty) {
            List<Future<CombinedResults>> futures = pairs.map((pair) {
              return api.getMoreMoviesByGenres(
                pair,
                dateGte,
                dateLte,
                // excludedGenreIds.join(','),
                // keywords,
                /*primaryYear*/
              );
            }).toList();

            moreByGenresOperation =
                CancelableOperation<List<CombinedResults>>.fromFuture(
                  Future.wait(futures),
                ).then((results) {
                  /// Combine all results into one set
                  /// (set would automatically remove duplicates)
                  Set<CombinedResult> combinedResults = {};
                  for (var result in results) {
                    combinedResults.addAll(result.results);
                  }

                  /// Sort the combined results by vote average, remove the
                  /// currently displayed movie from the list and notify
                  /// listeners
                  moreByGenres = combinedResults.toList()
                    ..removeWhere((element) => element.id == media?.id)
                    ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
                  notifyListeners();
                });
          }
        }
      }
    }
  }

  _compileImages() async {
    if (media != null) {
      var imageResult = media!.images;
      List<ImageDetail> images = [];
      images.addAll(imageResult.backdrops
          .map((e) => e.copyWith.imageType(ImageType.backdrop.name)));
      images.addAll(imageResult.posters
          .map((e) => e.copyWith.imageType(ImageType.poster.name)));
      images.addAll(imageResult.logos
          .map((e) => e.copyWith.imageType(ImageType.logo.name)));
      this.images = images;
      notifyListeners();
    }
  }

  _compileThumbnails() async {
    logIfDebug('isPinned, compileThumbnails called with movie:$media');
    if (media != null) {
      Map<String, ThumbnailType> thumbs = {};
      for (var key in youtubeKeys) {
        thumbs[key] = ThumbnailType.video;
      }
      for (var imagePath in media!.images.backdrops.take(2)) {
        thumbs[imagePath.filePath] = ThumbnailType.image;
      }
      logIfDebug('isPinned, thumb:$thumbs');
      if (thumbs.isNotEmpty) thumbMap = thumbs;
      logIfDebug('isPinned, thumbMap:$thumbMap');
      notifyListeners();
    }
  }
}

enum ThumbnailType {
  video,
  image,
}
