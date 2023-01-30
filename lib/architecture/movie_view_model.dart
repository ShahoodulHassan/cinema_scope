import 'package:cinema_scope/architecture/search_view_model.dart';
import 'package:cinema_scope/models/search.dart';

import '../models/movie.dart';

class MovieViewModel extends ApiViewModel {
  Movie? movie;

  int _recomPageIndex = 0;

  int get recomPageIndex => _recomPageIndex;

  set recomPageIndex(int index) {
    _recomPageIndex = index;
    notifyListeners();
  }

  List<MovieResult> get recommendations =>
      (movie?.recommendations.results
        ?..removeWhere((element) => element.posterPath == null)) ??
      [];

  int get totalRecomCount => movie?.recommendations.totalResults ?? 0;

  List<Cast> get casts => movie?.credits.cast ?? [];

  List<Crew> get crew => movie?.credits.crew ?? [];

  int get totalCastCount => casts.length;

  // List<MovieResult> getRecommendationsForPage(int itemsPerPage) {
  //   return recommendations
  //       .skip(itemsPerPage * _recomPageIndex)
  //       .take(itemsPerPage)
  //       .toList();
  // }

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

  getMovieWithDetail(int id) async {
    movie = await api.getMovieWithDetail(id);
    notifyListeners();
    compileThumbnails();
  }

  // getMovie(int id) async {
  //   movie = await api.getMovie(id);
  //   notifyListeners();
  // }

  compileThumbnails() async {
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
}

enum ThumbnailType {
  video,
  image,
}
