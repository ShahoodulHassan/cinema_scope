import 'dart:math';

import 'package:async/async.dart';
import 'package:cinema_scope/architecture/config_view_model.dart';
import 'package:cinema_scope/architecture/search_view_model.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/person.dart';

class MovieViewModel extends ApiViewModel with Utilities {
  late final List<MediaGenre> allGenres;

  Movie? movie;

  int _recomPageIndex = 0;

  int get recomPageIndex => _recomPageIndex;

  CancelableOperation? _operation,
      _moreByLeadOperation,
      _moreByGenresOperation,
      _moreByDirectorOperation;

  String? year;

  double? get voteAverage => movie?.voteAverage;

  String? get runtime {
    var runtime = movie?.runtime;
    return runtime == null ? null : runtimeToString(runtime);
  }

  String? certification;

  String? get imdbId => movie?.imdbId;

  String? get homepage => movie?.homepage;

  List<ImageDetail>? images;

  List<CombinedResult>? moreByLead, moreByGenres;

  Tuple2<Crew, List<CombinedResult>>? moreByDirector;

  Tuple2<Cast, List<CombinedResult>>? moreByActor;

  set recomPageIndex(int index) {
    _recomPageIndex = index;
    notifyListeners();
  }

  RecommendationData? get recommendationData => movie == null
      ? null
      : RecommendationData(movie!.id, movie!.recommendations);

  List<MovieResult> get recommendations =>
      (movie?.recommendations.results
        ?..removeWhere((element) => element.posterPath == null)) ??
      [];

  int get totalRecomCount => movie?.recommendations.totalResults ?? 0;

  List<Cast> get casts => movie?.credits.cast ?? [];

  List<Crew> get crew => movie?.credits.crew ?? [];

  int get totalCastCount => casts.length;

  List<Review> get reviews => movie?.reviews.results ?? [];

  int get totalReviewsCount => movie?.reviews.totalResults ?? 0;

  List<Keyword> get keywords => movie?.keywords.keywords ?? [];

  String get synopsis => movie?.overview ?? '';

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

  List<String> get youtubeKeys => ((movie?.videos.results
                  .where((video) => video.type == 'Trailer')
                  .map((vid) => vid.key)
                  .toList() ??
              <String>[]) +
          (movie?.videos.results
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
    _operation = CancelableOperation<Movie>.fromFuture(
      api.getMovieWithDetail(id),
    ).then((result) async {
      movie = result;
      year = getYearStringFromDate(movie!.releaseDate);
      await _compileCertification();
      notifyListeners();
      _fetchMoreData();
    });
  }

  void _fetchMoreData() async {
    _fetchMoreByLead();
    _fetchMoreByLeadActor();
    _fetchMoreByGenres();
    _fetchMoreByDirector();
    _compileThumbnails();
    _compileImages();
  }

  _compileCertification() async {
    var usResults = movie!.releaseDates.results
        .where((element) => element.iso31661 == Constants.region);
    if (usResults.isNotEmpty) {
      var theatrical = usResults.first.releaseDates;
      if (theatrical.isNotEmpty) certification = theatrical.first.certification;
    }
  }

  _fetchMoreByLead() async {
    if (movie != null) {
      var leadActors = movie!.credits.cast.take(2).map((e) => e.id).join('|');
      _moreByLeadOperation = CancelableOperation<CombinedResults>.fromFuture(
        api.getMoreMoviesByLeadActors(leadActors),
      ).then((results) {
        moreByLead = results.results
          ..removeWhere((element) => element.id == movie?.id);
        notifyListeners();
      });
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
    if (movie != null) {
      var releaseDate = movie!.releaseDate ?? '';
      if (releaseDate.isNotEmpty) {
        var date = DateTime.parse(releaseDate);
        var diffFromNow = DateTime.now().difference(date).inDays;
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
          if (DateTime.now().difference(DateTime.parse('$year-01-01')).inDays <
              (30 * 6)) {
            primaryYear = '$year|${year - 1}';
          }

          Set<String> pairs = {};
          var genreIds = movie!.genres.map((e) => e.id).toList();
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

          var keywords = movie!.keywords.keywords.map((e) => e.id).join(',');
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

            _moreByGenresOperation =
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
                ..removeWhere((element) => element.id == movie?.id)
                ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
              notifyListeners();
            });
          }
        }
      }
    }
  }

  _fetchMoreByDirector() async {
    // logIfDebug('crew:$crew');
    var directors = crew.where((element) {
      // logIfDebug('job:${element.job}');
      return element.job == Constants.departMap[Department.directing.name];
    });
    // logIfDebug('directors:$directors');
    if (directors.isNotEmpty) {
      var director = directors.first;
      // logIfDebug('directorId:${director.id}');
      _moreByDirectorOperation = CancelableOperation<Person>.fromFuture(
              api.getPersonWithDetail(director.id, append: 'combined_credits'))
          .then((person) {
        var moreByDirector = person.combinedCredits.crew
            .where((media) =>
                media.department == director.department &&
                media.id != movie?.id &&
                media.posterPath != null)
            .toList()
          ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
        // logIfDebug('moreByDirector:$moreByDirector');
        if (moreByDirector.isNotEmpty) {
          this.moreByDirector = Tuple2<Crew, List<CombinedResult>>(
            director,
            moreByDirector,
          );
          notifyListeners();
        }
      });
    }
  }

  _fetchMoreByLeadActor() async {
    var actors = casts.take(3).toList();
    // logIfDebug('actors:$actors');
    if (actors.isNotEmpty) {
      var actor = actors[Random().nextInt(actors.length)];
      // logIfDebug('directorId:${actor.id}');
      _moreByLeadOperation = CancelableOperation<Person>.fromFuture(
              api.getPersonWithDetail(actor.id, append: 'combined_credits'))
          .then((person) {
        var moreByActor = person.combinedCredits.cast
            .where((media) =>
                (media.order ?? 3) <= actor.order &&
                media.id != movie!.id &&
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
  }

  _compileImages() async {
    if (movie != null) {
      var imageResult = movie!.images;
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
    logIfDebug('isPinned, compileThumbnails called with movie:$movie');
    if (movie != null) {
      Map<String, ThumbnailType> thumbs = {};
      for (var key in youtubeKeys) {
        thumbs[key] = ThumbnailType.video;
      }
      for (var imagePath in movie!.images.backdrops.take(2)) {
        thumbs[imagePath.filePath] = ThumbnailType.image;
      }
      logIfDebug('isPinned, thumb:$thumbs');
      if (thumbs.isNotEmpty) thumbMap = thumbs;
      logIfDebug('isPinned, thumbMap:$thumbMap');
      notifyListeners();
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
}

enum ThumbnailType {
  video,
  image,
}
