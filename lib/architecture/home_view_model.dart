import 'package:cinema_scope/architecture/search_view_model.dart';
import 'package:cinema_scope/constants.dart';
import 'package:cinema_scope/widgets/home_section.dart';

import '../models/search.dart';

class HomeViewModel extends ApiViewModel {
  MovieSearchResult? latestMoviesResult;
  MovieSearchResult? popularMoviesResult;
  MovieSearchResult? topRatedMoviesResult;
  MovieSearchResult? upcomingMoviesResult;
  MovieSearchResult? trendingResult;
  MovieSearchResult? nowPlayingResult;

  MovieSearchResult? getResultBySectionTitle(SectionTitle title) {
    switch (title) {
      case SectionTitle.nowPlaying:
        return nowPlayingResult;
      case SectionTitle.dailyTrending:
        return trendingResult;
      case SectionTitle.latest:
        return latestMoviesResult;
      case SectionTitle.popular:
        return popularMoviesResult;
      case SectionTitle.topRated:
        return topRatedMoviesResult;
      case SectionTitle.upcoming:
        return upcomingMoviesResult;
    }
  }

  getAllResults(MediaType mediaType, {TimeWindow? timeWindow}) async {
    await getNowPlaying(mediaType);
    await getTrending(mediaType, timeWindow: timeWindow);
    await getLatestMovies();
    await getPopularMovies();
    await getTopRatedMovies();

    /// We add two page long upcoming movies
    await getDiscoverUpcomingMovies(mediaType);
    await getDiscoverUpcomingMovies(mediaType, page: 2);
  }

  /// Fetched latest movies having release date somewhere in the past 7 day,
  /// having 'en' language, sorted by latest first,
  getLatestMovies() async {
    var dateGte = getFormattedPastDate(15);
    var dateLte = getFormattedNow();
    logIfDebug('$dateGte, $dateLte');
    var value = await api.getLatestMovies(dateGte, dateLte);
    latestMoviesResult = value;
    latestMoviesResult!.results
        .removeWhere((element) => element.posterPath == null);
    notifyListeners();
  }

  getPopularMovies() async {
    var value = await api.getPopularMovies();
    popularMoviesResult = value;
    notifyListeners();
  }

  getTopRatedMovies() async {
    var value = await api.getTopRatedMovies();
    topRatedMoviesResult = value;
    notifyListeners();
  }

  @Deprecated('Provides misleading results based on release_date. '
      'See getDiscoverUpcomingMovies')
  getUpcomingMovies() async {
    api.getUpcomingMovies().then((value) {
      upcomingMoviesResult = value;
      notifyListeners();
    });
  }

  /// release_date.gte (tomorrow [Now + 1])
  /// release_date.lte (30 days from tomorrow [Now + 31])
  getDiscoverUpcomingMovies(MediaType mediaType, {int page = 1}) async {
    logIfDebug('discover upcoming called with page:$page');
    var dateGte = getFormattedFutureDate(1);
    var dateLte = getFormattedFutureDate(31);
    logIfDebug('$dateGte, $dateLte');
    var result = await api
        .discoverUpcomingMovies(mediaType.name, dateGte, dateLte, page: page);
    logIfDebug(result.results.first.movieTitle);
    if (page == 1) {
      upcomingMoviesResult = result
        ..results.removeWhere((element) => element.posterPath == null);
    } else if (page > 1) {
      var allItems = upcomingMoviesResult?.results ?? [];
      allItems.addAll(
          result.results..removeWhere((element) => element.posterPath == null));
      result.results = allItems;
      upcomingMoviesResult = result;
    }
    notifyListeners();
  }

  getTrending(MediaType mediaType, {TimeWindow? timeWindow}) async {
    var value = await api.getTrending(
        mediaType.name, (timeWindow ?? TimeWindow.day).name);
    trendingResult = value;
    notifyListeners();
  }

  getNowPlaying(MediaType mediaType) async {
    var value = await api.getNowPlaying(mediaType.name);
    nowPlayingResult = value;
    notifyListeners();
  }
}
