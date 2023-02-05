// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      json['adult'] as bool,
      (json['also_known_as'] as List<dynamic>).map((e) => e as String).toList(),
      json['biography'] as String,
      json['id'] as int,
      json['known_for_department'] as String,
      json['name'] as String,
      (json['popularity'] as num).toDouble(),
      MovieCredits.fromJson(json['movie_credits'] as Map<String, dynamic>),
      gender: json['gender'] as int?,
      birthday: json['birthday'] as String?,
      deathday: json['deathday'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      profilePath: json['profile_path'] as String?,
      homepage: json['homepage'] as String?,
      imdbId: json['imdb_id'] as String?,
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'adult': instance.adult,
      'also_known_as': instance.alsoKnownAs,
      'biography': instance.biography,
      'birthday': instance.birthday,
      'deathday': instance.deathday,
      'gender': instance.gender,
      'homepage': instance.homepage,
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'place_of_birth': instance.placeOfBirth,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'movie_credits': instance.movieCredits,
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

MovieOfCast _$MovieOfCastFromJson(Map<String, dynamic> json) => MovieOfCast(
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
      json['character'] as String,
      json['credit_id'] as String,
      mediaType: json['media_type'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      order: json['order'] as int?,
    );

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
      'release_date': instance.releaseDate,
      'adult': instance.adult,
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
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['vote_count'] as int,
      (json['vote_average'] as num).toDouble(),
      json['original_language'] as String,
      json['adult'] as bool,
      json['original_title'] as String,
      json['title'] as String,
      json['video'] as bool,
      json['department'] as String,
      json['credit_id'] as String,
      json['job'] as String,
      mediaType: json['media_type'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      backdropPath: json['backdrop_path'] as String?,
    );

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
      'release_date': instance.releaseDate,
      'adult': instance.adult,
      'original_title': instance.originalTitle,
      'title': instance.title,
      'video': instance.video,
      'department': instance.department,
      'job': instance.job,
      'credit_id': instance.creditId,
    };
