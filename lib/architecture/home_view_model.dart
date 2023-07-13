import 'dart:math';

import 'package:cinema_scope/architecture/search_view_model.dart';
import 'package:cinema_scope/constants.dart';
import 'package:cinema_scope/models/movie.dart';
import 'package:cinema_scope/utilities/utilities.dart';

import '../models/search.dart';
import '../pages/home_page.dart';

class HomeViewModel extends ApiViewModel with Utilities {
  CombinedResults? latestMoviesResult;
  CombinedResults? popularMoviesResult;
  CombinedResults? topRatedMoviesResult;
  CombinedResults? upcomingMoviesResult;
  CombinedResults? trendingResult;
  CombinedResults? nowPlayingResult;
  CombinedResults? streamingResult;
  CombinedResults? freeMediaResult;

  Map<SectionTitle, String> sectionParamMap = {};

  Map<SectionTitle, double> sectionOffsets = {};

  CombinedResults? getResultBySectionTitle(SectionTitle title) {
    switch (title) {
      case SectionTitle.nowPlaying:
        return nowPlayingResult;
      case SectionTitle.trending:
        return trendingResult;
      case SectionTitle.latest:
        return latestMoviesResult;
      case SectionTitle.popular:
        return popularMoviesResult;
      case SectionTitle.topRated:
        return topRatedMoviesResult;
      case SectionTitle.upcoming:
        return upcomingMoviesResult;
      case SectionTitle.streaming:
        return streamingResult;
      case SectionTitle.freeToWatch:
        return freeMediaResult;
    }
  }

  double getSectionOffset(SectionTitle title) {
    return sectionOffsets[title] ??
        sectionOffsets.putIfAbsent(title, () => 0.0);
  }

  setSectionOffset(SectionTitle title, double offset) async {
    sectionOffsets[title] = offset;
  }

  // getAllResults(MediaType mediaType, {TimeWindow? timeWindow}) async {
  //   /// We add two page long upcoming movies
  //   await _getTrending(timeWindow: timeWindow);
  //   await _getTrending(timeWindow: timeWindow, page: 2);
  //
  //   await getNowPlaying(mediaType);
  //   await getLatestMovies(MediaType.movie);
  //   await getPopularMovies(MediaType.movie);
  //   await getTopRatedMovies(mediaType);
  //
  //   /// We add two page long upcoming movies
  //   await _getDiscoverUpcomingMovies(mediaType);
  //   await _getDiscoverUpcomingMovies(mediaType, page: 2);
  // }

  /// Fetched latest movies having release date somewhere in the past 7 day,
  /// having 'en' language, sorted by latest first,
  getLatestMovies(MediaType? mediaType) async {
    String type = (mediaType ?? MediaType.movie).name;
    var param = sectionParamMap[SectionTitle.latest];
    if (type != param) {
      sectionParamMap[SectionTitle.latest] = type;
      var dateGte = getFormattedPastDate(15);
      var dateLte = getFormattedNow();
      logIfDebug('$dateGte, $dateLte');
      var result = type == MediaType.movie.name
          ? await api.getLatestMovies(dateGte, dateLte)
          : await api.getLatestTvShows(dateGte, dateLte);
      latestMoviesResult = result.copyWith.results(result.results.map((e) {
        e.mediaType ??= type;
        e.dateString = getReadableDate(e.mediaReleaseDate);
        e.yearString = getYearStringFromDate(e.mediaReleaseDate);
        return e;
      }).toList()
        ..removeWhere((element) => element.posterPath == null));
      // latestMoviesResult!.results
      //     .removeWhere((element) => element.posterPath == null);
      notifyListeners();
    }
  }

  getPopularMovies(MediaType? mediaType) async {
    String type = (mediaType ?? MediaType.movie).name;
    var param = sectionParamMap[SectionTitle.popular];
    if (type != param) {
      sectionParamMap[SectionTitle.popular] = type;
      var result = await api.getPopularMovies(type);
      popularMoviesResult = result.copyWith.results(result.results.map((e) {
        e.mediaType ??= type;
        e.dateString = getReadableDate(e.mediaReleaseDate);
        e.yearString = getYearStringFromDate(e.mediaReleaseDate);
        return e;
      }).toList());
      notifyListeners();
    }
  }

  getTopRatedMovies(MediaType? mediaType) async {
    String type = (mediaType ?? MediaType.movie).name;
    var param = sectionParamMap[SectionTitle.topRated];
    if (type != param) {
      sectionParamMap[SectionTitle.topRated] = type;
      var result = await api.getTopRatedMovies(type);
      topRatedMoviesResult = result.copyWith.results(result.results.map((e) {
        e.mediaType ??= type;
        e.dateString = getReadableDate(e.mediaReleaseDate);
        e.yearString = getYearStringFromDate(e.mediaReleaseDate);
        return e;
      }).toList());
      notifyListeners();
    }
  }

  @Deprecated('Provides misleading results based on release_date. '
      'See getDiscoverUpcomingMovies')
  getUpcomingMovies() async {
    api.getUpcomingMovies().then((value) {
      upcomingMoviesResult = value;
      notifyListeners();
    });
  }

  /// We allow refreshable results here, hence no check for type != param
  getDiscoverUpcoming(MediaType? mediaType) async {
    var type = (mediaType ?? MediaType.movie).name;
    var param = sectionParamMap[SectionTitle.upcoming];
    if (type != param) {
      /// We add two page long upcoming movies
      await _getDiscoverUpcoming(type);
      await _getDiscoverUpcoming(type, page: 2);
      // await _getDiscoverUpcoming(type, page: 3);
    }
  }

  /// release_date.gte (tomorrow [Now + 1])
  /// release_date.lte (30 days from tomorrow [Now + 31])
  _getDiscoverUpcoming(String type, {int page = 1}) async {
    logIfDebug('discover upcoming called with page:$page');
    var dateGte = getFormattedFutureDate(1);
    var dateLte = getFormattedFutureDate(31);
    logIfDebug('$dateGte, $dateLte');
    if (page == 1) {
      sectionParamMap[SectionTitle.upcoming] = type;
    }
    var result = type == MediaType.movie.name
        ? await api.discoverUpcomingMovies(
            dateGte,
            dateLte,
            page: page,
          )
        : await api.discoverUpcomingTvShows(
            dateGte,
            dateLte,
            page: page,
          );
    var modified = result.copyWith.results((result.results
          ..removeWhere((element) => element.posterPath == null)
          ..shuffle())
        .map((e) {
      e.mediaType ??= type;
      e.dateString = getReadableDate(e.mediaReleaseDate);
      e.yearString = getYearStringFromDate(e.mediaReleaseDate);
      return e;
    }).toList());
    // logIfDebug(result.results.first.movieTitle);
    if (page > 1) {
      var allItems = upcomingMoviesResult?.results ?? [];
      allItems.addAll(modified.results);
      modified.results = allItems;
    }
    upcomingMoviesResult = modified;
    notifyListeners();
  }

  getTrending({TimeWindow? timeWindow}) async {
    var window = (timeWindow ?? TimeWindow.day).name;
    var param = sectionParamMap[SectionTitle.trending];
    if (window != param) {
      /// We add two page long upcoming movies and TV shows
      await _getTrending(window);
      await _getTrending(window, page: 2);
    }
  }

  _getTrending(String timeWindow, {int page = 1}) async {
    var result =
        await api.getTrending(MediaType.all.name, timeWindow, page: page);
    var modified = result.copyWith.results((result.results
      ..removeWhere((element) => element.mediaType == MediaType.person.name))
      .map((e) {
        e.dateString = getReadableDate(e.mediaReleaseDate);
        e.yearString = getYearStringFromDate(e.mediaReleaseDate);
        return e;
      }).toList());
    if (page == 1) {
      sectionParamMap[SectionTitle.trending] = timeWindow;
      trendingResult = modified;
    } else if (page > 1) {
      var allItems = trendingResult?.results ?? [];
      allItems.addAll(modified.results);
      modified.results = allItems;
      trendingResult = modified;
    }
    notifyListeners();
  }

  getNowPlaying(MediaType? mediaType) async {
    var type = (mediaType ?? MediaType.movie).name;
    var param = sectionParamMap[SectionTitle.nowPlaying];
    if (type != param) {
      sectionParamMap[SectionTitle.nowPlaying] = type;
      CombinedResults result;
      var dateGte = getFormattedPastDate(30);
      var dateLte = getFormattedNow();
      if (type == MediaType.movie.name) {
        result = await api.discoverInTheaters(dateGte, dateLte);
      } else {
        result = await api.discoverOnTv(dateGte, dateLte);
      }
      // var result = type == MediaType.movie.name
      //     ? await api.getNowPlaying()
      //     : await api.getOnTheAir();
      nowPlayingResult = result.copyWith.results(result.results.map((e) {
        e.mediaType ??= type;
        e.dateString = getReadableDate(e.mediaReleaseDate);
        e.yearString = getYearStringFromDate(e.mediaReleaseDate);
        return e;
      }).toList());
      notifyListeners();
    }
  }

  // TODO document the logic applied here
  /// We allow refreshable results here, hence no check for type != param
  getStreamingMedia(MediaType? mediaType) async {
    var type = (mediaType ?? MediaType.movie).name;
    // var param = sectionParamMap[SectionTitle.streaming];
    // if (type != param) {
    sectionParamMap[SectionTitle.streaming] = type;

    int maxItemCount = 30;
    List<CombinedResult> combined = [];
    var result = await api.discoverStreamingMedia(type);
    combined.addAll(result.results);

    if (result.totalPages > 1) {
      int maxPageCount = min(3, result.totalPages);
      for (int i = 2; i <= maxPageCount; i++) {
        var res = await api.discoverStreamingMedia(type, page: i);
        combined.addAll(res.results);
      }
    }
    logIfDebug('streaming:${combined.length}');

    streamingResult = result.copyWith
        .results((combined..shuffle()).take(maxItemCount).map((e) {
      e.mediaType ??= type;
      e.dateString = getReadableDate(e.mediaReleaseDate);
      e.yearString = getYearStringFromDate(e.mediaReleaseDate);
      return e;
    }).toList());
    notifyListeners();
    // }
  }

  /// We allow refreshable results here, hence no check for type != param
  getFreeMedia(MediaType? mediaType) async {
    var type = (mediaType ?? MediaType.movie).name;
    sectionParamMap[SectionTitle.freeToWatch] = type;

    int maxItemCount = 30;
    List<CombinedResult> combined = [];
    var result = await api.discoverFreeMedia(type);
    combined.addAll(result.results);

    if (result.totalPages > 1) {
      int maxPageCount = min(3, result.totalPages);
      for (int i = 2; i <= maxPageCount; i++) {
        var res = await api.discoverFreeMedia(type, page: i);
        combined.addAll(res.results);
      }
    }
    logIfDebug('freeMedia:${combined.length}');

    freeMediaResult = result.copyWith
        .results((combined..shuffle()).take(maxItemCount).map((e) {
      e.mediaType ??= type;
      e.dateString = getReadableDate(e.mediaReleaseDate);
      e.yearString = getYearStringFromDate(e.mediaReleaseDate);
      return e;
    }).toList());
    notifyListeners();
    // }
  }
}
