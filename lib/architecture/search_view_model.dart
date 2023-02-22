import 'package:async/async.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/search.dart';
import '../tmdb_api.dart';

class SearchViewModel extends ApiViewModel with Utilities {
  MultiSearchResult? searchResult;

  String query = '';

  late PagingController<int, BaseResult> _pagingController;

  PagingController<int, BaseResult> get pagingController => _pagingController;

  Function(int)? _listener;

  CancelableOperation? _operation;

  // bool _isInitialized = false;

  SearchViewModel() : super() {
    _pagingController = PagingController(firstPageKey: 1)
      ..appendLastPage(<BaseResult>[]);
  }

  initializePaging() {
    _listener ??= (pageKey) {
      logIfDebug('page listener called for pageKey=$pageKey');
      searchPagedMovies(query, page: pageKey);
    };
    _pagingController.addPageRequestListener(_listener!);
  }

  searchPagedMovies(String query, {int page = 1}) async {
    logIfDebug('searchPagedMovies called for query:{$query}, page:$page');
    this.query = query;
    _operation?.cancel();
    if (query.isEmpty) {
      _processResult(null, page);
      // _pagingController.itemList = <BaseResult>[];
      // notifyListeners();
    } else {
      _operation = CancelableOperation<MultiSearchResult>.fromFuture(
        Future.delayed(const Duration(milliseconds: 500),
            () => api.performMultiSearch(query, page: page)),
      ).then((result) async {
        debugPrint('searchResult:$result');
        _processResult(result, page);
      });
    }
  }

  void _processResult(MultiSearchResult? result, int page) {
    searchResult = result;
    final isLastPage = (result?.totalPages ?? 1) == page;
    if (page == 1) _pagingController.itemList = <BaseResult>[];
    var results = result?.results ?? <BaseResult>[];
    // await sortResults(results);
    if (isLastPage) {
      _pagingController.appendLastPage(results);
    } else {
      final nextPage = page + 1;
      _pagingController.appendPage(results, nextPage);
    }
    notifyListeners();
  }

  sortResults(List<MovieResult> results) async {
    results.sort((a, b) {
      var yearA =
          a.releaseDate != null ? getYearFromDate(a.releaseDate!) : null;
      var yearB =
          b.releaseDate != null ? getYearFromDate(b.releaseDate!) : null;
      logIfDebug('yearA:$yearA, yearB:$yearB');
      if (yearA == null || yearB == null) return -1;
      return yearB.compareTo(yearA);
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

abstract class ApiViewModel extends ChangeNotifier with GenericFunctions {
  final TmdbApi api;

  ApiViewModel() : api = TmdbApi(Dio());
}
