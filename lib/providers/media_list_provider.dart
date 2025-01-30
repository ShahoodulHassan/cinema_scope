import 'package:async/async.dart';
import 'package:cinema_scope/providers/search_provider.dart';
import 'package:cinema_scope/models/similar_titles_params.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/search.dart';

class MediaListProvider extends ApiProvider with Utilities, CommonFunctions {
  late final List<MediaGenre> _combinedGenres;

  CombinedResults? searchResult;

  final PagingController<int, CombinedResult> _pagingController;

  PagingController<int, CombinedResult> get pagingController =>
      _pagingController;

  Function(int)? _listener;

  CancelableOperation? _operation;

  static const firstPageKey = 1;

  /// Map of page number & genrePairs
  Map<int, Set<String>> genrePairsMap = {};

  MediaListProvider()
      : _pagingController = PagingController(
          firstPageKey: firstPageKey,
        );

  initializePaging({
    required MediaType mediaType,
    required List<MediaGenre> combinedGenres,
    List<int>? genreIds,
    List<Keyword>? keywords,
    int? mediaId,
    SimilarTitlesParams? similarTitlesParams,
  }) {
    _combinedGenres = combinedGenres;
    if (similarTitlesParams != null) {
      genrePairsMap[firstPageKey] = similarTitlesParams.genrePairs;
    }
    _listener ??= (pageKey) {
      logIfDebug('page listener called for pageKey=$pageKey');
      if (keywords != null) {
        _discoverByKeyword(
          mediaType: mediaType,
          genreIds: genreIds ?? [],
          keywords: keywords,
          page: pageKey,
        );
      } else if (genreIds.isNotNullNorEmpty) {
        _discoverByGenre(
          mediaType: mediaType,
          genreIds: genreIds!,
          page: pageKey,
        );
      } else if (mediaId != null) {
        _getRecommendations(
          mediaType: mediaType,
          mediaId: mediaId,
          page: pageKey,
        );
      } else if (similarTitlesParams != null) {
        _getSimilarTitles(similarTitlesParams, page: pageKey);
      }
    };
    _pagingController.addPageRequestListener(_listener!);
  }

  void _appendPageAndNotify(
    MediaType mediaType,
    CombinedResults result,
    int page,
  ) {
    searchResult = result;
    final isLastPage = result.totalPages == page;
    if (page == 1) _pagingController.itemList = <CombinedResult>[];
    var results = result.results
        .map((r) {
          if (r.mediaType.isNullOrEmpty) r.mediaType = mediaType.name;
          r.genreNamesString = getGenreNamesFromIds(
              _combinedGenres,
              r.genreIds,
              r.mediaType == MediaType.tv.name
                  ? MediaType.tv
                  : MediaType.movie);
          r.dateString = getReadableDate(r.mediaReleaseDate);
          r.yearString = getYearStringFromDate(r.mediaReleaseDate);

          /// This has been added especially for Similar Titles, in which case,
          /// there is a chance of having duplicate items in the next pages and so,
          /// we don't add those.
          if (!(_pagingController.itemList ?? []).contains(r)) return r;
        })
        .nonNulls
        .toList();
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

  void _getSimilarTitles(
    SimilarTitlesParams similarTitlesParams, {
    int page = 1,
  }) {
    final mediaId = similarTitlesParams.mediaId;
    final mediaType = similarTitlesParams.mediaType;
    final genrePairs = genrePairsMap[page];
    final dateGte = similarTitlesParams.dateGte;
    final dateLte = similarTitlesParams.dateLte;
    final keywordsString = similarTitlesParams.keywordsString;
    final origLang = similarTitlesParams.originalLanguage;

    if (genrePairs.isNotNullNorEmpty) {
      final futures = genrePairs!.map((pair) {
        return mediaType == MediaType.movie
            ? api.getMoreMoviesByGenres(
                pair,
                dateGte,
                dateLte,
                keywordsString,
                page: page,
                originalLanguage:
                    origLang.startsWith('en') ? origLang : '$origLang|en',
              )
            : api.getMoreTvSeriesByGenres(
                pair,
                dateGte,
                dateLte,
                keywordsString,
                page: page,
                originalLanguage:
                    origLang.startsWith('en') ? origLang : '$origLang|en',
              );
      }).toList();

      _operation = CancelableOperation<List<CombinedResults>>.fromFuture(
        Future.wait<CombinedResults>(futures),
      ).then((results) async {
        /// These values are the same for each page iteration though
        final totalPages = results.map((e) => e.totalPages).max;
        final totalResults = results.map((e) => e.totalResults).max;
        logIfDebug('totalPages:$totalPages, totalResults:$totalResults');

        /// Combine all results into one set
        /// (set would automatically remove duplicates)
        Set<CombinedResult> combinedResults = {};
        Set<String> reducedGenrePairs = {};
        logIfDebug('results size:${results.length}');
        for (int i = 0; i < results.length; i++) {
          var result = results[i];
          logIfDebug('result size:${result.results.length}');
          combinedResults.addAll(result.results);

          /// Add genre pairs, if there is a next page available for them
          if (result.totalPages > page) {
            reducedGenrePairs.add(genrePairs.elementAt(i));
          }
        }

        /// If there is gonna be a next page, save genre pairs with reference to
        /// next page number
        if (totalPages > page) genrePairsMap[page + 1] = reducedGenrePairs;

        /// Remove the
        /// currently displayed movie from the list, append page and notify
        /// listeners
        var similarTitles = combinedResults.toList()
          ..removeWhere((element) => element.id == mediaId);
        logIfDebug('similarTitles length:${similarTitles.length}');

        final newResults = CombinedResults(
          page,
          totalPages,
          totalResults,
          similarTitles,
        );

        _appendPageAndNotify(mediaType, newResults, page);
      });
    }
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
