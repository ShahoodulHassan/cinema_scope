import 'package:async/async.dart';
import 'package:cinema_scope/architecture/person_view_model.dart';
import 'package:cinema_scope/architecture/search_view_model.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:tuple/tuple.dart';

import '../models/movie.dart';
import '../models/search.dart';
import '../models/tv.dart';
import 'config_view_model.dart';
import 'movie_view_model.dart';

class TvViewModel extends MediaViewModel {
  late final List<MediaGenre> allGenres;

  Tv? tv;

  int _recomPageIndex = 0;

  int get recomPageIndex => _recomPageIndex;

  CancelableOperation? _operation,
      _moreByLeadOperation,
      _moreByGenresOperation,
      _moreByDirectorOperation;

  String? year;

  double? get voteAverage => tv?.voteAverage;

  String? certification;

  String? get imdbId => tv?.externalIds?.imdbId;

  String? get homepage => tv?.homepage;

  List<CombinedResult>? moreByLead, moreByGenres;

  Tuple2<TvCrew, List<CombinedResult>>? moreByDirector;

  Tuple2<TvCast, List<CombinedResult>>? moreByActor;

  set recomPageIndex(int index) {
    _recomPageIndex = index;
    notifyListeners();
  }

  TvRecommendationData? get recommendationData =>
      tv == null ? null : TvRecommendationData(tv!.id, tv!.recommendations);

  int get totalRecomCount => tv?.recommendations.totalResults ?? 0;

  List<TvCast> get casts => tv?.aggregateCredits.cast ?? [];

  List<TvCrew> get crew => tv?.aggregateCredits.crew ?? [];

  int get totalCastCount => casts.length;

  List<Review> get reviews => tv?.reviews.results ?? [];

  int get totalReviewsCount => tv?.reviews.totalResults ?? 0;

  List<Keyword> get keywords => tv?.keywords.results ?? [];

  String get synopsis => tv?.overview ?? '';

  String? get runtime {
    var runtime = tv?.episodeRunTime ?? [];
    return runtime.isEmpty ? null : runtimeToString(runtime.first);
  }

  String? years;

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

  List<String> get youtubeKeys => ((tv?.videos.results
                  .where((video) => video.type == 'Trailer')
                  .map((vid) => vid.key)
                  .toList() ??
              <String>[]) +
          (tv?.videos.results
                  .where((video) => video.type == 'Teaser')
                  .map((vid) => vid.key)
                  .toList() ??
              <String>[]))
      .take(3)
      .toList();

  getTvWithDetail(int id, List<MediaGenre> allGenres,
      {String? leadActors}) async {
    this.allGenres = allGenres;
    _operation = CancelableOperation<Tv>.fromFuture(
      api.getTvWithDetail(id),
    ).then((result) async {
      tv = result;
      year = getYearStringFromDate(tv!.firstAirDate);
      await _compileYears();
      // await _compileCertification();
      notifyListeners();
      _fetchMoreData();
    });
  }

  void _fetchMoreData() async {
    // _fetchMoreByLead();
    // _fetchMoreByLeadActor();
    // _fetchMoreByGenres();
    // _fetchMoreByDirector();
    _compileThumbnails();
    _compileImages();
  }

  _compileYears() async {
    var years = '';
    var y1 = getYearStringFromDate(tv?.firstAirDate);
    var status = tv?.status;
    var continued = status != TvStatus.cancelled.name &&
        status != TvStatus.ended.name;
    if (continued) {
      if (y1.isNotEmpty) years = '$y1-';
    } else {
      var y2 = getYearStringFromDate(tv?.lastAirDate);
      if (y1.isNotEmpty && y2.isNotEmpty) years = '$y1-$y2';
    }
    this.years = years;
  }

  _compileThumbnails() async {
    logIfDebug('isPinned, compileThumbnails called with tv:$tv');
    if (tv != null) {
      Map<String, ThumbnailType> thumbs = {};
      for (var key in youtubeKeys) {
        thumbs[key] = ThumbnailType.video;
      }
      for (var imagePath in tv!.images.backdrops.take(2)) {
        thumbs[imagePath.filePath] = ThumbnailType.image;
      }
      logIfDebug('isPinned, thumb:$thumbs');
      if (thumbs.isNotEmpty) thumbMap = thumbs;
      logIfDebug('isPinned, thumbMap:$thumbMap');
      notifyListeners();
    }
  }

  _compileImages() async {
    if (tv != null) {
      var imageResult = tv!.images;
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

  @override
  void dispose() {
    _operation?.cancel();
    _moreByLeadOperation?.cancel();
    _moreByGenresOperation?.cancel();
    _moreByDirectorOperation?.cancel();
    super.dispose();
  }
}
