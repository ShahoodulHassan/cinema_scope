import 'package:async/async.dart';
import 'package:cinema_scope/architecture/search_view_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/search.dart';

class MoviesListViewModel extends ApiViewModel {
  MovieSearchResult? searchResult;

  final PagingController<int, MovieResult> _pagingController;

  PagingController<int, MovieResult> get pagingController => _pagingController;

  Function(int)? _listener;

  CancelableOperation? _operation;

  MoviesListViewModel() : _pagingController = PagingController(firstPageKey: 1);

  initializePaging({
    required MediaType mediaType,
    List<int>? genreIds,
    List<Keyword>? keywords,
    int? mediaId,
  }) {
    _listener ??= (pageKey) {
      logIfDebug('page listener called for pageKey=$pageKey');
      if (keywords != null) {
        _discoverByKeyword(
          mediaType: mediaType,
          genreIds: genreIds ?? [],
          keywords: keywords,
          page: pageKey,
        );
      } else if (genreIds != null && genreIds.isNotEmpty) {
        _discoverByGenre(
          mediaType: mediaType,
          genreIds: genreIds,
          page: pageKey,
        );
      } else if (mediaId != null) {
        _getRecommendations(
          mediaType: mediaType,
          mediaId: mediaId,
          page: pageKey,
        );
      }
    };
    _pagingController.addPageRequestListener(_listener!);
  }

  void _appendPageAndNotify(MovieSearchResult result, int page) {
    searchResult = result;
    final isLastPage = (result.totalPages ?? 1) == page;
    if (page == 1) _pagingController.itemList = <MovieResult>[];
    var results = result.results;
    if (isLastPage) {
      _pagingController.appendLastPage(results);
    } else {
      final nextPage = page + 1;
      _pagingController.appendPage(results, nextPage);
    }
    notifyListeners();
  }

  _getRecommendations({
    required MediaType mediaType,
    required int mediaId,
    int page = 1,
  }) async {
    logIfDebug('id:$mediaId');
    _operation = CancelableOperation<MovieSearchResult>.fromFuture(
      api.getRecommendations(mediaType.name, mediaId, page: page),
    ).then((result) => _appendPageAndNotify(result, page));
  }

  _discoverByGenre({
    required MediaType mediaType,
    required List<int> genreIds,
    int page = 1,
  }) async {
    String gIds = genreIds.join('|');
    logIfDebug('gIds:$gIds');
    _operation = CancelableOperation<MovieSearchResult>.fromFuture(
      api.discoverMoviesByGenre(mediaType.name, gIds, page: page),
    ).then((result) => _appendPageAndNotify(result, page));
  }

  _discoverByKeyword({
    required MediaType mediaType,
    required List<int> genreIds,
    required List<Keyword> keywords,
    int page = 1,
  }) async {
    String gIds = genreIds.join('|');
    String kIds = keywords.map((e) => e.id).join(',');
    logIfDebug('gIds:$gIds, kIds:$kIds');
    _operation = CancelableOperation<MovieSearchResult>.fromFuture(
      api.discoverMoviesByKeyword(mediaType.name, kIds, gIds, page: page),
    ).then((result) => _appendPageAndNotify(result, page));
  }

  _disposePageController() {
    _operation?.cancel();
    _pagingController.refresh();
    _pagingController.dispose();
  }

  @override
  void dispose() {
    _disposePageController();
    super.dispose();
  }
}
