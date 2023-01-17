// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Collection _$CollectionFromJson(Map<String, dynamic> json) => Collection(
      json['id'] as int,
      json['name'] as String,
      json['overview'] as String,
      (json['parts'] as List<dynamic>)
          .map((e) => CollectionPart.fromJson(e as Map<String, dynamic>))
          .toList(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
    );

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'overview': instance.overview,
      'parts': instance.parts,
    };

CollectionPart _$CollectionPartFromJson(Map<String, dynamic> json) =>
    CollectionPart(
      json['adult'] as bool,
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['id'] as int,
      json['original_language'] as String,
      json['original_title'] as String,
      json['overview'] as String,
      json['release_date'] as String,
      (json['popularity'] as num).toDouble(),
      json['title'] as String,
      json['video'] as bool,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      backdropPath: json['backdrop_path'] as String?,
      posterPath: json['poster_path'] as String?,
    );

Map<String, dynamic> _$CollectionPartToJson(CollectionPart instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'release_date': instance.releaseDate,
      'poster_path': instance.posterPath,
      'popularity': instance.popularity,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };
