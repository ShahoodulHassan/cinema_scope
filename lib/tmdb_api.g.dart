// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _TmdbApi implements TmdbApi {
  _TmdbApi(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  }) {
    baseUrl ??= 'https://api.themoviedb.org/3/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<ApiConfiguration> getApiConfiguration() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiConfiguration>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/configuration',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiConfiguration _value;
    try {
      _value = ApiConfiguration.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<CountryConfig>> getCountryConfiguration() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<CountryConfig>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/configuration/countries',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<CountryConfig> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => CountryConfig.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<LanguageConfig>> getLanguageConfiguration() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<LanguageConfig>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/configuration/languages',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<LanguageConfig> _value;
    try {
      _value = _result.data!
          .map(
              (dynamic i) => LanguageConfig.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<String>> getTranslationConfiguration() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<String>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/configuration/primary_translations',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<String> _value;
    try {
      _value = _result.data!.cast<String>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GenreResult> getGenres(
    String mediaType, {
    String language = 'en-US',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'language': language};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GenreResult>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/genre/${mediaType}/list',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GenreResult _value;
    try {
      _value = GenreResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Movie> getMovie(int id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Movie>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/movie/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Movie _value;
    try {
      _value = Movie.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Movie> getMovieWithDetail(
    int id, {
    String language = 'en-US',
    String append =
        'videos,images,recommendations,keywords,reviews,credits,release_dates'
            ',alternative_titles,watch/providers',
    String imageLanguage = 'en,null',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'language': language,
      r'append_to_response': append,
      r'include_image_language': imageLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Movie>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/movie/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Movie _value;
    try {
      _value = Movie.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getMoreMoviesByLeadActors(
    String withPeople, {
    String language = 'en-US',
    String region = 'US',
    String sortBy = 'vote_average.desc',
    String includeAdult = 'false',
    int page = 1,
    double voteAverage = 6.1,
    int voteCount = 100,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'with_people': withPeople,
      r'language': language,
      r'region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'page': page,
      r'vote_average.gte': voteAverage,
      r'vote_count.gte': voteCount,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/movie',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getMoreMoviesByGenres(
    String withGenres,
    String releaseDateGte,
    String releaseDateLte,
    String withKeywords, {
    String language = 'en-US',
    String originalLanguage = 'en',
    String region = 'US',
    String sortBy = 'vote_average.desc',
    String includeAdult = 'false',
    int page = 1,
    double voteAverage = 6.1,
    int voteCount = 50,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'with_genres': withGenres,
      r'primary_release_date.gte': releaseDateGte,
      r'primary_release_date.lte': releaseDateLte,
      r'with_keywords': withKeywords,
      r'language': language,
      r'with_original_language': originalLanguage,
      r'region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'page': page,
      r'vote_average.gte': voteAverage,
      r'vote_count.gte': voteCount,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/movie',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<MovieSearchResult> searchMovies(
    String query, {
    int page = 1,
    String language = 'en',
    String includeAdult = 'false',
    String region = 'US',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'query': query,
      r'page': page,
      r'language': language,
      r'include_adult': includeAdult,
      r'region': region,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MovieSearchResult>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/search/movie',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MovieSearchResult _value;
    try {
      _value = MovieSearchResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<PersonSearchResult> searchPersons(
    String query, {
    int page = 1,
    String language = 'en',
    String includeAdult = 'false',
    String region = 'US',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'query': query,
      r'page': page,
      r'language': language,
      r'include_adult': includeAdult,
      r'region': region,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<PersonSearchResult>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/search/person',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PersonSearchResult _value;
    try {
      _value = PersonSearchResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<MultiSearchResult> performMultiSearch(
    String query, {
    int page = 1,
    String language = 'en',
    String includeAdult = 'false',
    String region = 'US',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'query': query,
      r'page': page,
      r'language': language,
      r'include_adult': includeAdult,
      r'region': region,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MultiSearchResult>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/search/multi',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MultiSearchResult _value;
    try {
      _value = MultiSearchResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getLatestMovies(
    String dateGte,
    String dateLte, {
    int page = 1,
    String language = 'en-US',
    String region = 'US',
    String sortBy = 'release_date.desc',
    String includeAdult = 'false',
    String withLanguage = 'en',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'release_date.gte': dateGte,
      r'release_date.lte': dateLte,
      r'page': page,
      r'language': language,
      r'region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'with_original_language': withLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/movie',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getPopularMovies(
    String mediaType, {
    int page = 1,
    String language = 'en-US',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'language': language,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/${mediaType}/popular',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getTopRatedMovies(
    String mediaType, {
    int page = 1,
    String language = 'en-US',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'language': language,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/${mediaType}/top_rated',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getUpcomingMovies({
    int page = 1,
    String language = 'en-US',
    String region = 'US',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'language': language,
      r'region': region,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/movie/upcoming',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> discoverUpcomingMovies(
    String dateGte,
    String dateLte, {
    int page = 1,
    String language = 'en-US',
    String region = 'US',
    String sortBy = 'popularity.desc',
    String includeAdult = 'false',
    String originalLanguage = 'en',
    String releaseType = '3|2',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'release_date.gte': dateGte,
      r'release_date.lte': dateLte,
      r'page': page,
      r'language': language,
      r'region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'with_original_language': originalLanguage,
      r'with_release_type': releaseType,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/movie',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<MultiSearchResult> getTrending(
    String mediaType,
    String timeWindow, {
    int page = 1,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MultiSearchResult>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/trending/${mediaType}/${timeWindow}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MultiSearchResult _value;
    try {
      _value = MultiSearchResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getNowPlaying({
    int page = 1,
    String language = 'en-US',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'language': language,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/movie/now_playing',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> discoverInTheaters(
    String dateGte,
    String dateLte, {
    int page = 1,
    String language = 'en-US',
    String region = 'US',
    String sortBy = 'popularity.desc',
    String includeAdult = 'false',
    int releaseType = 3,
    String originalLanguage = '',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'release_date.gte': dateGte,
      r'release_date.lte': dateLte,
      r'page': page,
      r'language': language,
      r'region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'with_release_type': releaseType,
      r'with_original_language': originalLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/movie',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getLastYearTopRatedMovies(
    String dateFrom,
    String dateTo, {
    int page = 1,
    String language = 'en',
    String region = 'US',
    String sortBy = 'vote_average.desc',
    String includeAdult = 'false',
    double voteAverage = 6.1,
    int voteCount = 50,
    String withLanguage = 'en',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'primary_release_date.gte': dateFrom,
      r'primary_release_date.lte': dateTo,
      r'page': page,
      r'language': language,
      r'region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'vote_average.gte': voteAverage,
      r'vote_count.gte': voteCount,
      r'with_original_language': withLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/movie',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> discoverStreamingMedia(
    String mediaType, {
    int page = 1,
    String language = 'en-US',
    String watchRegion = 'US',
    String withMonetizationTypes = 'flatrate',
    String sortBy = 'popularity.desc',
    String includeAdult = 'false',
    String originalLanguage = '',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'language': language,
      r'watch_region': watchRegion,
      r'with_watch_monetization_types': withMonetizationTypes,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'with_original_language': originalLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/${mediaType}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> discoverFreeMedia(
    String mediaType, {
    int page = 1,
    String language = 'en-US',
    String watchRegion = 'US',
    String withMonetizationTypes = 'free|ads',
    String sortBy = 'popularity.desc',
    String includeAdult = 'false',
    String originalLanguage = '',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'language': language,
      r'watch_region': watchRegion,
      r'with_watch_monetization_types': withMonetizationTypes,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'with_original_language': originalLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/${mediaType}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> discoverMediaByKeyword(
    String mediaType,
    String keywords,
    String genres, {
    int page = 1,
    String language = 'en-US',
    String region = 'US',
    String sortBy = 'popularity.desc',
    String includeAdult = 'false',
    String originalLanguage = 'en',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'with_keywords': keywords,
      r'with_genres': genres,
      r'page': page,
      r'language': language,
      r'region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'with_original_language': originalLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/${mediaType}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> discoverMediaByGenre(
    String mediaType,
    String genres, {
    int page = 1,
    String language = 'en-US',
    String region = 'US',
    String sortBy = 'popularity.desc',
    String includeAdult = 'false',
    String originalLanguage = 'en',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'with_genres': genres,
      r'page': page,
      r'language': language,
      r'region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'with_original_language': originalLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/${mediaType}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getMediaRecommendations(
    String mediaType,
    int mediaId, {
    int page = 1,
    String language = 'en-US',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'language': language,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/${mediaType}/${mediaId}/recommendations',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Person> getPersonWithDetail(
    int id, {
    String append = 'combined_credits,external_ids,images,tagged_images',
    String language = 'en-US',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'append_to_response': append,
      r'language': language,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Person>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/person/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Person _value;
    try {
      _value = Person.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Tv> getTvWithDetail(
    int id, {
    String language = 'en-US',
    String append =
        'videos,images,recommendations,keywords,reviews,aggregate_credits,'
            'external_ids,alternative_titles,watch/providers',
    String imageLanguage = 'en,null',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'language': language,
      r'append_to_response': append,
      r'include_image_language': imageLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Tv>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/tv/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Tv _value;
    try {
      _value = Tv.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getMoreTvSeriesByGenres(
    String withGenres,
    String releaseDateGte,
    String releaseDateLte,
    String withKeywords, {
    String language = 'en-US',
    String originalLanguage = 'en',
    String region = 'US',
    String sortBy = 'vote_average.desc',
    String includeAdult = 'false',
    int page = 1,
    double voteAverage = 6.1,
    int voteCount = 50,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'with_genres': withGenres,
      r'first_air_date.gte': releaseDateGte,
      r'first_air_date.lte': releaseDateLte,
      r'with_keywords': withKeywords,
      r'language': language,
      r'with_original_language': originalLanguage,
      r'watch_region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'page': page,
      r'vote_average.gte': voteAverage,
      r'vote_count.gte': voteCount,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/tv',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getOnTheAir({
    int page = 1,
    String language = 'en-US',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'language': language,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/tv/on_the_air',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> discoverOnTv(
    String dateGte,
    String dateLte, {
    int page = 1,
    String language = 'en-US',
    String region = 'US',
    String sortBy = 'popularity.desc',
    String includeAdult = 'false',
    String timezone = '',
    String originalLanguage = '',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'air_date.gte': dateGte,
      r'air_date.lte': dateLte,
      r'page': page,
      r'language': language,
      r'region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'timezone': timezone,
      r'with_original_language': originalLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/tv',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> discoverUpcomingTvShows(
    String releaseDateGte,
    String releaseDateLte, {
    int page = 1,
    String language = 'en-US',
    String region = 'US',
    String sortBy = 'popularity.desc',
    String includeAdult = 'false',
    String originalLanguage = 'en',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'air_date.gte': releaseDateGte,
      r'air_date.lte': releaseDateLte,
      r'page': page,
      r'language': language,
      r'region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'with_original_language': originalLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/tv',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getLatestTvShows(
    String releaseDateGte,
    String releaseDateLte, {
    int page = 1,
    String language = 'en-US',
    String region = 'US',
    String sortBy = 'first_air_date.desc',
    String includeAdult = 'false',
    String withLanguage = 'en',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'air_date.gte': releaseDateGte,
      r'air_date.lte': releaseDateLte,
      r'page': page,
      r'language': language,
      r'region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'with_original_language': withLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/tv',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CombinedResults> getLastYearTopRatedTvShows(
    String firstAirDateFrom,
    String firstAirDateTo, {
    int page = 1,
    String language = 'en',
    String region = 'US',
    String sortBy = 'vote_average.desc',
    String includeAdult = 'false',
    double voteAverage = 6.1,
    int voteCount = 50,
    String withLanguage = 'en',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'first_air_date.gte': firstAirDateFrom,
      r'first_air_date.lte': firstAirDateTo,
      r'page': page,
      r'language': language,
      r'region': region,
      r'sort_by': sortBy,
      r'include_adult': includeAdult,
      r'vote_average.gte': voteAverage,
      r'vote_count.gte': voteCount,
      r'with_original_language': withLanguage,
    };
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CombinedResults>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
        .compose(
          _dio.options,
          '/discover/tv',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CombinedResults _value;
    try {
      _value = CombinedResults.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
