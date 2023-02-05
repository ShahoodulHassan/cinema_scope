// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieSearchResult _$MovieSearchResultFromJson(Map<String, dynamic> json) =>
    MovieSearchResult(
      json['page'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => MovieResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['total_pages'] as int,
      json['total_results'] as int,
    );

Map<String, dynamic> _$MovieSearchResultToJson(MovieSearchResult instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

MultiSearchResult _$MultiSearchResultFromJson(Map<String, dynamic> json) =>
    MultiSearchResult(
      json['page'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => BaseResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['total_pages'] as int,
      json['total_results'] as int,
    );

Map<String, dynamic> _$MultiSearchResultToJson(MultiSearchResult instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

BaseResult _$BaseResultFromJson(Map<String, dynamic> json) => BaseResult(
      json['id'] as int,
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
      json['id'] as int,
      json['overview'] as String,
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['vote_count'] as int,
      (json['vote_average'] as num).toDouble(),
      json['original_language'] as String,
      mediaType: json['media_type'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
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
    };

KnownFor _$KnownForFromJson(Map<String, dynamic> json) => KnownFor(
      json['id'] as int,
      json['overview'] as String,
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['vote_count'] as int,
      (json['vote_average'] as num).toDouble(),
      json['original_language'] as String,
      json['title'] as String?,
      json['name'] as String?,
      json['first_air_date'] as String?,
      json['release_date'] as String?,
      (json['origin_country'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      json['original_name'] as String?,
      json['original_title'] as String?,
      mediaType: json['media_type'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      adult: json['adult'] as bool?,
      video: json['video'] as bool?,
    );

Map<String, dynamic> _$KnownForToJson(KnownFor instance) => <String, dynamic>{
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
      'video': instance.video,
      'release_date': instance._releaseDate,
      'original_title': instance._originalTitle,
      'title': instance._title,
      'first_air_date': instance._firstAirDate,
      'origin_country': instance._originCountry,
      'name': instance._name,
      'original_name': instance._originalName,
    };

MovieResult _$MovieResultFromJson(Map<String, dynamic> json) => MovieResult(
      json['id'] as int,
      json['overview'] as String,
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['vote_count'] as int,
      (json['vote_average'] as num).toDouble(),
      json['original_language'] as String,
      json['adult'] as bool,
      json['original_title'] as String,
      json['title'] as String,
      json['video'] as bool,
      mediaType: json['media_type'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
    );

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
      'release_date': instance.releaseDate,
      'adult': instance.adult,
      'original_title': instance.originalTitle,
      'title': instance.title,
      'video': instance.video,
    };

TvResult _$TvResultFromJson(Map<String, dynamic> json) => TvResult(
      json['id'] as int,
      json['overview'] as String,
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['vote_count'] as int,
      (json['vote_average'] as num).toDouble(),
      json['original_language'] as String,
      (json['origin_country'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['name'] as String,
      json['original_name'] as String,
      mediaType: json['media_type'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      firstAirDate: json['first_air_date'] as String?,
    );

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
      'first_air_date': instance.firstAirDate,
      'origin_country': instance.originCountry,
      'name': instance.name,
      'original_name': instance.originalName,
    };

BasePersonResult _$BasePersonResultFromJson(Map<String, dynamic> json) =>
    BasePersonResult(
      json['id'] as int,
      json['adult'] as bool,
      json['name'] as String,
      json['known_for_department'] as String,
      mediaType: json['media_type'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      profilePath: json['profile_path'] as String?,
      gender: json['gender'] as int?,
    );

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
      json['id'] as int,
      json['adult'] as bool,
      json['name'] as String,
      json['known_for_department'] as String,
      (json['known_for'] as List<dynamic>)
          .map((e) => KnownFor.fromJson(e as Map<String, dynamic>))
          .toList(),
      mediaType: json['media_type'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      profilePath: json['profile_path'] as String?,
      gender: json['gender'] as int?,
    );

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
