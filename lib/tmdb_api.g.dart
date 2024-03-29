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
    language = 'en-US',
    append =
        'videos,images,recommendations,keywords,reviews,credits,release_dates'
            ',alternative_titles,watch/providers',
    imageLanguage = 'en,null',
  }) async {
    const _extra = <String, dynamic>{};
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
  Future<CombinedResults> getMoreMoviesByLeadActors(
    withPeople, {
    language = 'en-US',
    region = 'US',
    sortBy = 'vote_average.desc',
    includeAdult = 'false',
    page = 1,
    voteAverage = 6.1,
    voteCount = 100,
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> getMoreMoviesByGenres(
    withGenres,
    releaseDateGte,
    releaseDateLte,
    withKeywords, {
    language = 'en-US',
    originalLanguage = 'en',
    region = 'US',
    sortBy = 'vote_average.desc',
    includeAdult = 'false',
    page = 1,
    voteAverage = 6.1,
    voteCount = 50,
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
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
  Future<CombinedResults> getLatestMovies(
    dateGte,
    dateLte, {
    page = 1,
    language = 'en-US',
    region = 'US',
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> getPopularMovies(
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
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> getTopRatedMovies(
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
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> getUpcomingMovies({
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
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> discoverUpcomingMovies(
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
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> getTrending(
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
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> getNowPlaying({
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
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> discoverInTheaters(
    dateGte,
    dateLte, {
    page = 1,
    language = 'en-US',
    region = 'US',
    sortBy = 'popularity.desc',
    includeAdult = 'false',
    releaseType = 3,
    originalLanguage = '',
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
      r'with_release_type': releaseType,
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
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> getLastYearTopRatedMovies(
    dateFrom,
    dateTo, {
    page = 1,
    language = 'en',
    region = 'US',
    sortBy = 'vote_average.desc',
    includeAdult = 'false',
    voteAverage = 6.1,
    voteCount = 50,
    withLanguage = 'en',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> discoverStreamingMedia(
    mediaType, {
    page = 1,
    language = 'en-US',
    watchRegion = 'US',
    withMonetizationTypes = 'flatrate',
    sortBy = 'popularity.desc',
    includeAdult = 'false',
    originalLanguage = '',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> discoverFreeMedia(
    mediaType, {
    page = 1,
    language = 'en-US',
    watchRegion = 'US',
    withMonetizationTypes = 'free|ads',
    sortBy = 'popularity.desc',
    includeAdult = 'false',
    originalLanguage = '',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> discoverMediaByKeyword(
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
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> discoverMediaByGenre(
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
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> getMediaRecommendations(
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
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Person> getPersonWithDetail(
    id, {
    append = 'combined_credits,external_ids,images,tagged_images',
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

  @override
  Future<Tv> getTvWithDetail(
    id, {
    language = 'en-US',
    append = 'videos,images,recommendations,keywords,reviews,aggregate_credits,'
        'external_ids,alternative_titles,watch/providers',
    imageLanguage = 'en,null',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<Tv>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Tv.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> getMoreTvSeriesByGenres(
    withGenres,
    releaseDateGte,
    releaseDateLte,
    withKeywords, {
    language = 'en-US',
    originalLanguage = 'en',
    region = 'US',
    sortBy = 'vote_average.desc',
    includeAdult = 'false',
    page = 1,
    voteAverage = 6.1,
    voteCount = 50,
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> getOnTheAir({
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
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> discoverOnTv(
    dateGte,
    dateLte, {
    page = 1,
    language = 'en-US',
    region = 'US',
    sortBy = 'popularity.desc',
    includeAdult = 'false',
    timezone = '',
    originalLanguage = '',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> discoverUpcomingTvShows(
    releaseDateGte,
    releaseDateLte, {
    page = 1,
    language = 'en-US',
    region = 'US',
    sortBy = 'popularity.desc',
    includeAdult = 'false',
    originalLanguage = 'en',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> getLatestTvShows(
    releaseDateGte,
    releaseDateLte, {
    page = 1,
    language = 'en-US',
    region = 'US',
    sortBy = 'first_air_date.desc',
    includeAdult = 'false',
    withLanguage = 'en',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CombinedResults.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CombinedResults> getLastYearTopRatedTvShows(
    firstAirDateFrom,
    firstAirDateTo, {
    page = 1,
    language = 'en',
    region = 'US',
    sortBy = 'vote_average.desc',
    includeAdult = 'false',
    voteAverage = 6.1,
    voteCount = 50,
    withLanguage = 'en',
  }) async {
    const _extra = <String, dynamic>{};
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
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CombinedResults>(Options(
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
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CombinedResults.fromJson(_result.data!);
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
