// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MultiSearchResultCWProxy {
  MultiSearchResult page(int page);

  MultiSearchResult totalPages(int totalPages);

  MultiSearchResult totalResults(int totalResults);

  MultiSearchResult results(List<BaseResult> results);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MultiSearchResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MultiSearchResult(...).copyWith(id: 12, name: "My name")
  /// ````
  MultiSearchResult call({
    int? page,
    int? totalPages,
    int? totalResults,
    List<BaseResult>? results,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMultiSearchResult.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMultiSearchResult.copyWith.fieldName(...)`
class _$MultiSearchResultCWProxyImpl implements _$MultiSearchResultCWProxy {
  const _$MultiSearchResultCWProxyImpl(this._value);

  final MultiSearchResult _value;

  @override
  MultiSearchResult page(int page) => this(page: page);

  @override
  MultiSearchResult totalPages(int totalPages) => this(totalPages: totalPages);

  @override
  MultiSearchResult totalResults(int totalResults) =>
      this(totalResults: totalResults);

  @override
  MultiSearchResult results(List<BaseResult> results) => this(results: results);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MultiSearchResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MultiSearchResult(...).copyWith(id: 12, name: "My name")
  /// ````
  MultiSearchResult call({
    Object? page = const $CopyWithPlaceholder(),
    Object? totalPages = const $CopyWithPlaceholder(),
    Object? totalResults = const $CopyWithPlaceholder(),
    Object? results = const $CopyWithPlaceholder(),
  }) {
    return MultiSearchResult(
      page == const $CopyWithPlaceholder() || page == null
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as int,
      totalPages == const $CopyWithPlaceholder() || totalPages == null
          ? _value.totalPages
          // ignore: cast_nullable_to_non_nullable
          : totalPages as int,
      totalResults == const $CopyWithPlaceholder() || totalResults == null
          ? _value.totalResults
          // ignore: cast_nullable_to_non_nullable
          : totalResults as int,
      results == const $CopyWithPlaceholder() || results == null
          ? _value.results
          // ignore: cast_nullable_to_non_nullable
          : results as List<BaseResult>,
    );
  }
}

extension $MultiSearchResultCopyWith on MultiSearchResult {
  /// Returns a callable class that can be used as follows: `instanceOfMultiSearchResult.copyWith(...)` or like so:`instanceOfMultiSearchResult.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MultiSearchResultCWProxy get copyWith =>
      _$MultiSearchResultCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseSearchResult _$BaseSearchResultFromJson(Map<String, dynamic> json) =>
    BaseSearchResult(
      (json['page'] as num).toInt(),
      (json['total_pages'] as num).toInt(),
      (json['total_results'] as num).toInt(),
    );

Map<String, dynamic> _$BaseSearchResultToJson(BaseSearchResult instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

MovieSearchResult _$MovieSearchResultFromJson(Map<String, dynamic> json) =>
    MovieSearchResult(
      (json['page'] as num).toInt(),
      (json['total_pages'] as num).toInt(),
      (json['total_results'] as num).toInt(),
      (json['results'] as List<dynamic>)
          .map((e) => MovieResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieSearchResultToJson(MovieSearchResult instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
      'results': instance.results,
    };

PersonSearchResult _$PersonSearchResultFromJson(Map<String, dynamic> json) =>
    PersonSearchResult(
      (json['page'] as num).toInt(),
      (json['total_pages'] as num).toInt(),
      (json['total_results'] as num).toInt(),
      (json['results'] as List<dynamic>)
          .map((e) => PersonResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonSearchResultToJson(PersonSearchResult instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
      'results': instance.results,
    };

MultiSearchResult _$MultiSearchResultFromJson(Map<String, dynamic> json) =>
    MultiSearchResult(
      (json['page'] as num).toInt(),
      (json['total_pages'] as num).toInt(),
      (json['total_results'] as num).toInt(),
      (json['results'] as List<dynamic>)
          .map((e) => BaseResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MultiSearchResultToJson(MultiSearchResult instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
      'results': instance.results,
    };

BaseResult _$BaseResultFromJson(Map<String, dynamic> json) => BaseResult(
      (json['id'] as num).toInt(),
      mediaType: json['media_type'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BaseResultToJson(BaseResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
    };

MediaResult _$MediaResultFromJson(Map<String, dynamic> json) => MediaResult(
      (json['id'] as num).toInt(),
      json['overview'] as String,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      originalLanguage: json['original_language'] as String? ?? '',
      mediaType: json['media_type'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      adult: json['adult'] as bool?,
    );

Map<String, dynamic> _$MediaResultToJson(MediaResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'overview': instance.overview,
      'genre_ids': instance.genreIds,
      'vote_count': instance.voteCount,
      'vote_average': instance.voteAverage,
      'original_language': instance.originalLanguage,
      'adult': instance.adult,
    };

CombinedResult _$CombinedResultFromJson(Map<String, dynamic> json) =>
    CombinedResult(
      (json['id'] as num).toInt(),
      json['overview'] as String,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      originalLanguage: json['original_language'] as String? ?? '',
      mediaType: json['media_type'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      adult: json['adult'] as bool?,
      originalTitle: json['original_title'] as String?,
      title: json['title'] as String?,
      video: json['video'] as bool?,
      releaseDate: json['release_date'] as String?,
      originCountry: (json['origin_country'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      name: json['name'] as String?,
      originalName: json['original_name'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      deptJobsString: json['dept_jobs_string'] as String? ?? '',
      genreNamesString: json['genre_names_string'] as String? ?? '',
      dateString: json['date_string'] as String? ?? '',
      yearString: json['year_string'] as String? ?? '',
    );

Map<String, dynamic> _$CombinedResultToJson(CombinedResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'overview': instance.overview,
      'genre_ids': instance.genreIds,
      'vote_count': instance.voteCount,
      'vote_average': instance.voteAverage,
      'original_language': instance.originalLanguage,
      'adult': instance.adult,
      'release_date': instance.releaseDate,
      'first_air_date': instance.firstAirDate,
      'origin_country': instance.originCountry,
      'original_title': instance.originalTitle,
      'title': instance.title,
      'name': instance.name,
      'original_name': instance.originalName,
      'video': instance.video,
      'dept_jobs_string': instance.deptJobsString,
      'genre_names_string': instance.genreNamesString,
      'date_string': instance.dateString,
      'year_string': instance.yearString,
    };

MovieResult _$MovieResultFromJson(Map<String, dynamic> json) => MovieResult(
      (json['id'] as num).toInt(),
      json['overview'] as String,
      json['original_title'] as String,
      json['title'] as String,
      json['video'] as bool,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      originalLanguage: json['original_language'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      adult: json['adult'] as bool?,
      releaseDate: json['release_date'] as String?,
    )..mediaType = json['media_type'] as String?;

Map<String, dynamic> _$MovieResultToJson(MovieResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'overview': instance.overview,
      'genre_ids': instance.genreIds,
      'vote_count': instance.voteCount,
      'vote_average': instance.voteAverage,
      'original_language': instance.originalLanguage,
      'adult': instance.adult,
      'release_date': instance.releaseDate,
      'original_title': instance.originalTitle,
      'title': instance.title,
      'video': instance.video,
    };

TvResult _$TvResultFromJson(Map<String, dynamic> json) => TvResult(
      (json['id'] as num).toInt(),
      json['overview'] as String,
      (json['origin_country'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['name'] as String,
      json['original_name'] as String,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      originalLanguage: json['original_language'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      adult: json['adult'] as bool?,
    )..mediaType = json['media_type'] as String?;

Map<String, dynamic> _$TvResultToJson(TvResult instance) => <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'overview': instance.overview,
      'genre_ids': instance.genreIds,
      'vote_count': instance.voteCount,
      'vote_average': instance.voteAverage,
      'original_language': instance.originalLanguage,
      'adult': instance.adult,
      'first_air_date': instance.firstAirDate,
      'origin_country': instance.originCountry,
      'name': instance.name,
      'original_name': instance.originalName,
    };

BasePersonResult _$BasePersonResultFromJson(Map<String, dynamic> json) =>
    BasePersonResult(
      (json['id'] as num).toInt(),
      json['adult'] as bool,
      json['name'] as String,
      popularity: (json['popularity'] as num?)?.toDouble(),
      profilePath: json['profile_path'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      knownForDepartment: json['known_for_department'] as String? ?? '',
    )..mediaType = json['media_type'] as String?;

Map<String, dynamic> _$BasePersonResultToJson(BasePersonResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'adult': instance.adult,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'gender': instance.gender,
    };

PersonResult _$PersonResultFromJson(Map<String, dynamic> json) => PersonResult(
      (json['id'] as num).toInt(),
      json['adult'] as bool,
      json['name'] as String,
      popularity: (json['popularity'] as num?)?.toDouble(),
      profilePath: json['profile_path'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      knownForDepartment: json['known_for_department'] as String? ?? '',
      knownFor: (json['known_for'] as List<dynamic>?)
              ?.map((e) => CombinedResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )..mediaType = json['media_type'] as String?;

Map<String, dynamic> _$PersonResultToJson(PersonResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'adult': instance.adult,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'gender': instance.gender,
      'known_for': instance.knownFor,
    };
