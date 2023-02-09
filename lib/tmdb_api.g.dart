// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _TmdbApi implements TmdbApi {
  _TmdbApi(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://api.themoviedb.org/3/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ApiConfiguration> getApiConfiguration() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<ApiConfiguration>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ApiConfiguration.fromJson(_result.data!);
    return value;
  }

  @override
  Future<List<CountryConfig>> getCountryConfiguration() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<CountryConfig>>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => CountryConfig.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<LanguageConfig>> getLanguageConfiguration() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<LanguageConfig>>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => LanguageConfig.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<String>> getTranslationConfiguration() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.fetch<List<dynamic>>(_setStreamType<List<String>>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!.cast<String>();
    return value;
  }

  @override
  Future<GenreResult> getGenres(
    mediaType, {
    language = 'en-US',
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'language': language};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GenreResult>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GenreResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Movie> getMovie(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<Movie>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Movie.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Movie> getMovieWithDetail(
    id, {
    append = 'videos,images,recommendations,similar,keywords,reviews,credits',
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'append_to_response': append};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<Movie>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Movie.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MovieSearchResult> searchMovies(
    query, {
    page = 1,
    language = 'en',
    includeAdult = 'false',
    region = 'US',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MovieSearchResult>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MovieSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PersonSearchResult> searchPersons(
    query, {
    page = 1,
    language = 'en',
    includeAdult = 'false',
    region = 'US',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<PersonSearchResult>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PersonSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MultiSearchResult> performMultiSearch(
    query, {
    page = 1,
    language = 'en',
    includeAdult = 'false',
    region = 'US',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MultiSearchResult>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MultiSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MovieSearchResult> getLatestMovies(
    dateGte,
    dateLte, {
    page = 1,
    language = 'en-US',
    sortBy = 'release_date.desc',
    includeAdult = 'false',
    withLanguage = 'en',
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'release_date.gte': dateGte,
      r'release_date.lte': dateLte,
      r'page': page,
      r'language': language,
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MovieSearchResult>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MovieSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MovieSearchResult> getPopularMovies({
    page = 1,
    language = 'en-US',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MovieSearchResult>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
            .compose(
              _dio.options,
              '/movie/popular',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MovieSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MovieSearchResult> getTopRatedMovies({
    page = 1,
    language = 'en-US',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MovieSearchResult>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
            .compose(
              _dio.options,
              '/movie/top_rated',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MovieSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MovieSearchResult> getUpcomingMovies({
    page = 1,
    language = 'en-US',
    region = 'US',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MovieSearchResult>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MovieSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MovieSearchResult> discoverUpcomingMovies(
    mediaType,
    dateGte,
    dateLte, {
    page = 1,
    language = 'en-US',
    region = 'US',
    sortBy = 'popularity.desc',
    includeAdult = 'false',
    originalLanguage = 'en',
    releaseType = '3|2',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MovieSearchResult>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MovieSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MovieSearchResult> getTrending(
    mediaType,
    timeWindow, {
    page = 1,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json;charset=utf-8',
      r'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzdiNTdjNTY2ZThhZjk0MTE1YmIyYzBkOTEwZjYxMCIsInN1YiI6IjVhMGE3MDk5YzNhMzY4MjE4YTAxMTc2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uyDhjXOvRNfjg_gJFPkSfAuT-F-MFmWVwPoEUftgq1g',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MovieSearchResult>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MovieSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MovieSearchResult> getNowPlaying(
    mediaType, {
    page = 1,
    language = 'en-US',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MovieSearchResult>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json;charset=utf-8',
    )
            .compose(
              _dio.options,
              '/${mediaType}/now_playing',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MovieSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MovieSearchResult> discoverMoviesByKeyword(
    mediaType,
    keywords,
    genres, {
    page = 1,
    language = 'en-US',
    region = 'US',
    sortBy = 'popularity.desc',
    includeAdult = 'false',
    originalLanguage = 'en',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MovieSearchResult>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MovieSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MovieSearchResult> discoverMoviesByGenre(
    mediaType,
    genres, {
    page = 1,
    language = 'en-US',
    region = 'US',
    sortBy = 'popularity.desc',
    includeAdult = 'false',
    originalLanguage = 'en',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MovieSearchResult>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MovieSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MovieSearchResult> getRecommendations(
    mediaType,
    mediaId, {
    page = 1,
    language = 'en-US',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MovieSearchResult>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MovieSearchResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Person> getPersonWithDetail(
    id, {
    append =
        'movie_credits,tv_credits,combined_credits,external_ids,images,tagged_images',
    language = 'en-US',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<Person>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Person.fromJson(_result.data!);
    return value;
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
}
