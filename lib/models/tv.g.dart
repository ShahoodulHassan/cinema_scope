// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tv _$TvFromJson(Map<String, dynamic> json) => Tv(
      json['adult'] as bool,
      (json['created_by'] as List<dynamic>)
          .map((e) => CreatedBy.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['episode_run_time'] as List<dynamic>).map((e) => e as int).toList(),
      json['first_air_date'] as String,
      (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['id'] as int,
      json['in_production'] as bool,
      (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      json['last_air_date'] as String,
      TvEpisode.fromJson(json['last_episode_to_air'] as Map<String, dynamic>),
      json['name'] as String,
      (json['networks'] as List<dynamic>)
          .map((e) => Network.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['number_of_episodes'] as int,
      json['number_of_seasons'] as int,
      (json['origin_country'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['original_language'] as String,
      json['original_name'] as String,
      (json['popularity'] as num).toDouble(),
      (json['production_companies'] as List<dynamic>)
          .map((e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['production_countries'] as List<dynamic>)
          .map((e) => ProductionCountry.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['seasons'] as List<dynamic>)
          .map((e) => TvSeason.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['spoken_languages'] as List<dynamic>)
          .map((e) => LanguageConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['status'] as String,
      json['type'] as String,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      AggregateCredits.fromJson(
          json['aggregate_credits'] as Map<String, dynamic>),
      json['external_ids'] == null
          ? null
          : ExternalIds.fromJson(json['external_ids'] as Map<String, dynamic>),
      ReviewResult.fromJson(json['reviews'] as Map<String, dynamic>),
      ImageResult.fromJson(json['images'] as Map<String, dynamic>),
      VideoResult.fromJson(json['videos'] as Map<String, dynamic>),
      KeywordResult.fromJson(json['keywords'] as Map<String, dynamic>),
      TvAltTitleResult.fromJson(
          json['alternative_titles'] as Map<String, dynamic>),
      RecommendationResult.fromJson(
          json['recommendations'] as Map<String, dynamic>),
      backdropPath: json['backdrop_path'] as String?,
      homepage: json['homepage'] as String?,
      nextEpisodeToAir: json['next_episode_to_air'] == null
          ? null
          : TvEpisode.fromJson(
              json['next_episode_to_air'] as Map<String, dynamic>),
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      tagline: json['tagline'] as String?,
    );

Map<String, dynamic> _$TvToJson(Tv instance) => <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'created_by': instance.createdBy,
      'episode_run_time': instance.episodeRunTime,
      'first_air_date': instance.firstAirDate,
      'genres': instance.genres,
      'homepage': instance.homepage,
      'id': instance.id,
      'in_production': instance.inProduction,
      'languages': instance.languages,
      'last_air_date': instance.lastAirDate,
      'last_episode_to_air': instance.lastEpisodeToAir,
      'name': instance.name,
      'next_episode_to_air': instance.nextEpisodeToAir,
      'networks': instance.networks,
      'number_of_episodes': instance.numberOfEpisodes,
      'number_of_seasons': instance.numberOfSeasons,
      'origin_country': instance.originCountry,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'production_companies': instance.productionCompanies,
      'production_countries': instance.productionCountries,
      'seasons': instance.seasons,
      'spoken_languages': instance.spokenLanguages,
      'status': instance.status,
      'tagline': instance.tagline,
      'type': instance.type,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'aggregate_credits': instance.aggregateCredits,
      'videos': instance.videos,
      'recommendations': instance.recommendations,
      'images': instance.images,
      'keywords': instance.keywords,
      'reviews': instance.reviews,
      'external_ids': instance.externalIds,
      'alternative_titles': instance.alternativeTitles,
    };

CreatedBy _$CreatedByFromJson(Map<String, dynamic> json) => CreatedBy(
      json['id'] as int,
      json['credit_id'] as String,
      json['name'] as String,
      json['gender'] as int,
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$CreatedByToJson(CreatedBy instance) => <String, dynamic>{
      'id': instance.id,
      'credit_id': instance.creditId,
      'name': instance.name,
      'gender': instance.gender,
      'profile_path': instance.profilePath,
    };

Network _$NetworkFromJson(Map<String, dynamic> json) => Network(
      json['id'] as int,
      json['name'] as String,
      json['origin_country'] as String,
      logoPath: json['logo_path'] as String?,
    );

Map<String, dynamic> _$NetworkToJson(Network instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo_path': instance.logoPath,
      'origin_country': instance.originCountry,
    };

BaseTvCredit _$BaseTvCreditFromJson(Map<String, dynamic> json) => BaseTvCredit(
      json['id'] as int,
      json['adult'] as bool,
      json['name'] as String,
      json['known_for_department'] as String,
      json['total_episode_count'] as int,
      popularity: (json['popularity'] as num?)?.toDouble(),
      profilePath: json['profile_path'] as String?,
      gender: json['gender'] as int?,
    )..mediaType = json['media_type'] as String?;

Map<String, dynamic> _$BaseTvCreditToJson(BaseTvCredit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'adult': instance.adult,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'gender': instance.gender,
      'total_episode_count': instance.totalEpisodeCount,
    };

AggregateCredits _$AggregateCreditsFromJson(Map<String, dynamic> json) =>
    AggregateCredits(
      (json['cast'] as List<dynamic>)
          .map((e) => TvCast.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['crew'] as List<dynamic>)
          .map((e) => TvCrew.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AggregateCreditsToJson(AggregateCredits instance) =>
    <String, dynamic>{
      'cast': instance.cast,
      'crew': instance.crew,
    };

TvCast _$TvCastFromJson(Map<String, dynamic> json) => TvCast(
      json['id'] as int,
      json['adult'] as bool,
      json['name'] as String,
      json['known_for_department'] as String,
      json['total_episode_count'] as int,
      json['order'] as int,
      (json['roles'] as List<dynamic>)
          .map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      popularity: (json['popularity'] as num?)?.toDouble(),
      profilePath: json['profile_path'] as String?,
      gender: json['gender'] as int?,
    )..mediaType = json['media_type'] as String?;

Map<String, dynamic> _$TvCastToJson(TvCast instance) => <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'adult': instance.adult,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'gender': instance.gender,
      'total_episode_count': instance.totalEpisodeCount,
      'order': instance.order,
      'roles': instance.roles,
    };

TvCrew _$TvCrewFromJson(Map<String, dynamic> json) => TvCrew(
      json['id'] as int,
      json['adult'] as bool,
      json['name'] as String,
      json['known_for_department'] as String,
      json['total_episode_count'] as int,
      json['order'] as int,
      (json['roles'] as List<dynamic>)
          .map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      popularity: (json['popularity'] as num?)?.toDouble(),
      profilePath: json['profile_path'] as String?,
      gender: json['gender'] as int?,
    )..mediaType = json['media_type'] as String?;

Map<String, dynamic> _$TvCrewToJson(TvCrew instance) => <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'adult': instance.adult,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'gender': instance.gender,
      'total_episode_count': instance.totalEpisodeCount,
      'order': instance.order,
      'roles': instance.roles,
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      json['credit_id'] as String,
      json['character'] as String,
      json['episode_count'] as int,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'credit_id': instance.creditId,
      'character': instance.character,
      'episode_count': instance.episodeCount,
    };

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      json['credit_id'] as String,
      json['job'] as String,
      json['episode_count'] as int,
    );

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'credit_id': instance.creditId,
      'job': instance.job,
      'episode_count': instance.episodeCount,
    };

TvAltTitleResult _$TvAltTitleResultFromJson(Map<String, dynamic> json) =>
    TvAltTitleResult(
      (json['results'] as List<dynamic>)
          .map((e) => AlternativeTitle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TvAltTitleResultToJson(TvAltTitleResult instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

TvBaseResult _$TvBaseResultFromJson(Map<String, dynamic> json) => TvBaseResult(
      json['id'] as int,
      json['name'] as String,
      json['overview'] as String,
      json['season_number'] as int,
      mediaType: json['media_type'] as String?,
      showId: json['show_id'] as int?,
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
      mediaType: json['media_type'] as String?,
      airDate: json['air_date'] as String?,
      showId: json['show_id'] as int?,
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
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      json['episode_number'] as int,
      mediaType: json['media_type'] as String?,
      airDate: json['air_date'] as String?,
      showId: json['show_id'] as int?,
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
