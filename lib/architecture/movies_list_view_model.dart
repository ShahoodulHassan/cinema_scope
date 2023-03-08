import 'package:async/async.dart';
import 'package:cinema_scope/architecture/search_view_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/search.dart';

class MediaListViewModel extends ApiViewModel {
  CombinedResults? searchResult;

  final PagingController<int, CombinedResult> _pagingController;

  PagingController<int, CombinedResult> get pagingController =>
      _pagingController;

  Function(int)? _listener;

  CancelableOperation? _operation;

  MediaListViewModel() : _pagingController = PagingController(firstPageKey: 1);

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

  void _appendPageAndNotify(
      MediaType mediaType, CombinedResults result, int page) {
    searchResult = result;
    final isLastPage = (result.totalPages ?? 1) == page;
    if (page == 1) _pagingController.itemList = <CombinedResult>[];
    var results = result.results.map((r) {
      if (r.mediaType == null || r.mediaType!.isEmpty) {
        r.mediaType = mediaType.name;
      }
      return r;
    }).toList();
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
    _operation = CancelableOperation<CombinedResults>.fromFuture(
      api.getMediaRecommendations(mediaType.name, mediaId, page: page),
    ).then((result) => _appendPageAndNotify(mediaType, result, page));
  }

  _discoverByGenre({
    required MediaType mediaType,
    required List<int> genreIds,
    int page = 1,
  }) async {
    String gIds = genreIds.join('|');
    logIfDebug('gIds:$gIds');
    _operation = CancelableOperation<CombinedResults>.fromFuture(
      api.discoverMediaByGenre(mediaType.name, gIds, page: page),
    ).then((result) => _appendPageAndNotify(mediaType, result, page));
  }

  /// We keep region and originalLanguage off because if we didn't, we might be
  /// served with nothing.
  /// For example, if we started from the Trending titles, there is no region
  /// in the query, so we might click on a title that is not of the selected
  /// region. When we click on a keyword, we might end up with no results
  /// because this query is region specific.
  /// This is not an ideal solution though.
  /// TODO 08/03/2023 Reconsider the region and originalLanguage params once
  /// region is taken from the preferences
  ///
  _discoverByKeyword({
    required MediaType mediaType,
    required List<int> genreIds,
    required List<Keyword> keywords,
    int page = 1,
  }) async {
    String gIds = genreIds.join('|');
    String kIds = keywords.map((e) => e.id).join(',');
    logIfDebug('gIds:$gIds, kIds:$kIds');
    _operation = CancelableOperation<CombinedResults>.fromFuture(
      api.discoverMediaByKeyword(
        mediaType.name,
        kIds,
        gIds,
        page: page,
        region: '',
        originalLanguage: '',
      ),
    ).then((result) {
      _appendPageAndNotify(mediaType, result, page);
    });
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
