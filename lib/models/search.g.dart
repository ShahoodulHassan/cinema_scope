// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
      json['page'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => MovieResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['total_pages'] as int,
      json['total_results'] as int,
    );

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

MovieResult _$MovieResultFromJson(Map<String, dynamic> json) => MovieResult(
      json['adult'] as bool,
      json['overview'] as String,
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['id'] as int,
      json['original_title'] as String,
      json['original_language'] as String,
      json['title'] as String,
      (json['popularity'] as num).toDouble(),
      json['vote_count'] as int,
      json['video'] as bool,
      (json['vote_average'] as num).toDouble(),
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      backdropPath: json['backdrop_path'] as String?,
    );

Map<String, dynamic> _$MovieResultToJson(MovieResult instance) =>
    <String, dynamic>{
      'poster_path': instance.posterPath,
      'adult': instance.adult,
      'overview': instance.overview,
      'release_date': instance.releaseDate,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'original_title': instance.originalTitle,
      'original_language': instance.originalLanguage,
      'title': instance.title,
      'backdrop_path': instance.backdropPath,
      'popularity': instance.popularity,
      'vote_count': instance.voteCount,
      'video': instance.video,
      'vote_average': instance.voteAverage,
    };
