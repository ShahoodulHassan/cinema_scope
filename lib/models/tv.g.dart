// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvBaseResult _$TvBaseResultFromJson(Map<String, dynamic> json) => TvBaseResult(
      json['id'] as int,
      json['name'] as String,
      json['overview'] as String,
      json['season_number'] as int,
      json['show_id'] as int,
      mediaType: json['media_type'] as String?,
      airDate: json['air_date'] as String?,
    )..popularity = (json['popularity'] as num?)?.toDouble();

Map<String, dynamic> _$TvBaseResultToJson(TvBaseResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'name': instance.name,
      'overview': instance.overview,
      'air_date': instance.airDate,
      'season_number': instance.seasonNumber,
      'show_id': instance.showId,
    };

TvSeason _$TvSeasonFromJson(Map<String, dynamic> json) => TvSeason(
      json['id'] as int,
      json['name'] as String,
      json['overview'] as String,
      json['season_number'] as int,
      json['show_id'] as int,
      mediaType: json['media_type'] as String?,
      airDate: json['air_date'] as String?,
      episodeCount: json['episode_count'] as int?,
      posterPath: json['poster_path'] as String?,
    )..popularity = (json['popularity'] as num?)?.toDouble();

Map<String, dynamic> _$TvSeasonToJson(TvSeason instance) => <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'name': instance.name,
      'overview': instance.overview,
      'air_date': instance.airDate,
      'season_number': instance.seasonNumber,
      'show_id': instance.showId,
      'episode_count': instance.episodeCount,
      'poster_path': instance.posterPath,
    };

TvEpisode _$TvEpisodeFromJson(Map<String, dynamic> json) => TvEpisode(
      json['id'] as int,
      json['name'] as String,
      json['overview'] as String,
      json['season_number'] as int,
      json['show_id'] as int,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      json['episode_number'] as int,
      mediaType: json['media_type'] as String?,
      airDate: json['air_date'] as String?,
      productionCode: json['production_code'] as String?,
      runtime: json['runtime'] as int?,
      stillPath: json['still_path'] as String?,
    )..popularity = (json['popularity'] as num?)?.toDouble();

Map<String, dynamic> _$TvEpisodeToJson(TvEpisode instance) => <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'name': instance.name,
      'overview': instance.overview,
      'air_date': instance.airDate,
      'season_number': instance.seasonNumber,
      'show_id': instance.showId,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'episode_number': instance.episodeNumber,
      'production_code': instance.productionCode,
      'runtime': instance.runtime,
      'still_path': instance.stillPath,
    };
