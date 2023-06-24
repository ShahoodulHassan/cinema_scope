// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      json['id'] as int,
      json['adult'] as bool,
      json['name'] as String,
      (json['also_known_as'] as List<dynamic>).map((e) => e as String).toList(),
      json['biography'] as String,
      CombinedCredits.fromJson(
          json['combined_credits'] as Map<String, dynamic>),
      json['external_ids'] == null
          ? null
          : ExternalIds.fromJson(json['external_ids'] as Map<String, dynamic>),
      json['images'] == null
          ? null
          : PersonImageResult.fromJson(json['images'] as Map<String, dynamic>),
      json['tagged_images'] == null
          ? null
          : TaggedImageResult.fromJson(
              json['tagged_images'] as Map<String, dynamic>),
      popularity: (json['popularity'] as num?)?.toDouble(),
      gender: json['gender'] as int?,
      knownForDepartment: json['known_for_department'] as String? ?? '',
      birthday: json['birthday'] as String?,
      deathday: json['deathday'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      profilePath: json['profile_path'] as String?,
      homepage: json['homepage'] as String?,
      imdbId: json['imdb_id'] as String?,
    )..mediaType = json['media_type'] as String?;

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'adult': instance.adult,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'gender': instance.gender,
      'also_known_as': instance.alsoKnownAs,
      'biography': instance.biography,
      'birthday': instance.birthday,
      'deathday': instance.deathday,
      'homepage': instance.homepage,
      'imdb_id': instance.imdbId,
      'place_of_birth': instance.placeOfBirth,
      'combined_credits': instance.combinedCredits,
      'external_ids': instance.externalIds,
      'images': instance.images,
      'tagged_images': instance.taggedImages,
    };

ExternalIds _$ExternalIdsFromJson(Map<String, dynamic> json) => ExternalIds(
      freebaseMid: json['freebase_mid'] as String?,
      freebaseId: json['freebase_id'] as String?,
      imdbId: json['imdb_id'] as String?,
      tvrageId: json['tvrage_id'] as int?,
      wikidataId: json['wikidata_id'] as String?,
      facebookId: json['facebook_id'] as String?,
      instagramId: json['instagram_id'] as String?,
      twitterId: json['twitter_id'] as String?,
    );

Map<String, dynamic> _$ExternalIdsToJson(ExternalIds instance) =>
    <String, dynamic>{
      'freebase_mid': instance.freebaseMid,
      'freebase_id': instance.freebaseId,
      'imdb_id': instance.imdbId,
      'tvrage_id': instance.tvrageId,
      'wikidata_id': instance.wikidataId,
      'facebook_id': instance.facebookId,
      'instagram_id': instance.instagramId,
      'twitter_id': instance.twitterId,
    };

CombinedCredits _$CombinedCreditsFromJson(Map<String, dynamic> json) =>
    CombinedCredits(
      (json['cast'] as List<dynamic>)
          .map((e) => CombinedOfCast.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['crew'] as List<dynamic>)
          .map((e) => CombinedOfCrew.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CombinedCreditsToJson(CombinedCredits instance) =>
    <String, dynamic>{
      'cast': instance.cast,
      'crew': instance.crew,
    };

MovieCredits _$MovieCreditsFromJson(Map<String, dynamic> json) => MovieCredits(
      (json['cast'] as List<dynamic>)
          .map((e) => MovieOfCast.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['crew'] as List<dynamic>)
          .map((e) => MovieOfCrew.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieCreditsToJson(MovieCredits instance) =>
    <String, dynamic>{
      'cast': instance.cast,
      'crew': instance.crew,
    };

TvCredits _$TvCreditsFromJson(Map<String, dynamic> json) => TvCredits(
      (json['cast'] as List<dynamic>)
          .map((e) => TvOfCast.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['crew'] as List<dynamic>)
          .map((e) => TvOfCrew.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TvCreditsToJson(TvCredits instance) => <String, dynamic>{
      'cast': instance.cast,
      'crew': instance.crew,
    };

CombinedOfCast _$CombinedOfCastFromJson(Map<String, dynamic> json) =>
    CombinedOfCast(
      json['id'] as int,
      json['overview'] as String,
      json['character'] as String,
      json['credit_id'] as String,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const <int>[],
      voteCount: json['vote_count'] as int? ?? 0,
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
      order: json['order'] as int?,
      episodeCount: json['episode_count'] as int?,
    );

Map<String, dynamic> _$CombinedOfCastToJson(CombinedOfCast instance) =>
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
      'character': instance.character,
      'credit_id': instance.creditId,
      'order': instance.order,
      'episode_count': instance.episodeCount,
    };

CombinedOfCrew _$CombinedOfCrewFromJson(Map<String, dynamic> json) =>
    CombinedOfCrew(
      json['id'] as int,
      json['overview'] as String,
      json['department'] as String,
      json['credit_id'] as String,
      json['job'] as String,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const <int>[],
      voteCount: json['vote_count'] as int? ?? 0,
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
      episodeCount: json['episode_count'] as int?,
    );

Map<String, dynamic> _$CombinedOfCrewToJson(CombinedOfCrew instance) =>
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
      'department': instance.department,
      'job': instance.job,
      'credit_id': instance.creditId,
      'episode_count': instance.episodeCount,
    };

MovieOfCast _$MovieOfCastFromJson(Map<String, dynamic> json) => MovieOfCast(
      json['id'] as int,
      json['overview'] as String,
      json['original_title'] as String,
      json['title'] as String,
      json['video'] as bool,
      json['character'] as String,
      json['credit_id'] as String,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const <int>[],
      voteCount: json['vote_count'] as int? ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      originalLanguage: json['original_language'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      order: json['order'] as int?,
      adult: json['adult'] as bool?,
    )..mediaType = json['media_type'] as String?;

Map<String, dynamic> _$MovieOfCastToJson(MovieOfCast instance) =>
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
      'character': instance.character,
      'credit_id': instance.creditId,
      'order': instance.order,
    };

MovieOfCrew _$MovieOfCrewFromJson(Map<String, dynamic> json) => MovieOfCrew(
      json['id'] as int,
      json['overview'] as String,
      json['original_title'] as String,
      json['title'] as String,
      json['video'] as bool,
      json['department'] as String,
      json['credit_id'] as String,
      json['job'] as String,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const <int>[],
      voteCount: json['vote_count'] as int? ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      originalLanguage: json['original_language'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      adult: json['adult'] as bool?,
    )..mediaType = json['media_type'] as String?;

Map<String, dynamic> _$MovieOfCrewToJson(MovieOfCrew instance) =>
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
      'department': instance.department,
      'job': instance.job,
      'credit_id': instance.creditId,
    };

TvOfCast _$TvOfCastFromJson(Map<String, dynamic> json) => TvOfCast(
      json['id'] as int,
      json['overview'] as String,
      (json['origin_country'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['name'] as String,
      json['original_name'] as String,
      json['character'] as String,
      json['credit_id'] as String,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const <int>[],
      voteCount: json['vote_count'] as int? ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      originalLanguage: json['original_language'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      adult: json['adult'] as bool?,
      episodeCount: json['episode_count'] as int?,
    )..mediaType = json['media_type'] as String?;

Map<String, dynamic> _$TvOfCastToJson(TvOfCast instance) => <String, dynamic>{
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
      'character': instance.character,
      'credit_id': instance.creditId,
      'episode_count': instance.episodeCount,
    };

TvOfCrew _$TvOfCrewFromJson(Map<String, dynamic> json) => TvOfCrew(
      json['id'] as int,
      json['overview'] as String,
      (json['origin_country'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['name'] as String,
      json['original_name'] as String,
      json['department'] as String,
      json['job'] as String,
      json['credit_id'] as String,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const <int>[],
      voteCount: json['vote_count'] as int? ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      originalLanguage: json['original_language'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      adult: json['adult'] as bool?,
      episodeCount: json['episode_count'] as int?,
    )..mediaType = json['media_type'] as String?;

Map<String, dynamic> _$TvOfCrewToJson(TvOfCrew instance) => <String, dynamic>{
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
      'department': instance.department,
      'job': instance.job,
      'credit_id': instance.creditId,
      'episode_count': instance.episodeCount,
    };

PersonImageResult _$PersonImageResultFromJson(Map<String, dynamic> json) =>
    PersonImageResult(
      (json['profiles'] as List<dynamic>)
          .map((e) => ImageDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonImageResultToJson(PersonImageResult instance) =>
    <String, dynamic>{
      'profiles': instance.profiles,
    };

TaggedImageResult _$TaggedImageResultFromJson(Map<String, dynamic> json) =>
    TaggedImageResult(
      json['page'] as int,
      json['total_pages'] as int,
      json['total_results'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => TaggedImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaggedImageResultToJson(TaggedImageResult instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
      'results': instance.results,
    };

TaggedImage _$TaggedImageFromJson(Map<String, dynamic> json) => TaggedImage(
      (json['aspect_ratio'] as num).toDouble(),
      json['height'] as int,
      json['file_path'] as String,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      json['width'] as int,
      json['id'] as String,
      json['media_type'] as String,
      BaseResult.fromJson(json['media'] as Map<String, dynamic>),
      iso6391: json['iso_639_1'] as String?,
      imageType: json['image_type'] as String?,
    );

Map<String, dynamic> _$TaggedImageToJson(TaggedImage instance) =>
    <String, dynamic>{
      'aspect_ratio': instance.aspectRatio,
      'height': instance.height,
      'iso_639_1': instance.iso6391,
      'file_path': instance.filePath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'width': instance.width,
      'image_type': instance.imageType,
      'id': instance.id,
      'media_type': instance.mediaType,
      'media': instance.media,
    };
