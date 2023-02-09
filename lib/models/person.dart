import 'package:cinema_scope/models/search.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Person extends BasePersonResult {
  List<String> alsoKnownAs;
  String biography;
  String? birthday;
  String? deathday;
  String? homepage;
  String? imdbId;
  String? placeOfBirth;
  MovieCredits movieCredits;
  TvCredits tvCredits;
  CombinedCredits combinedCredits;
  ExternalIds? externalIds;

  Person(
    super.id,
    super.adult,
    super.name,
    super.knownForDepartment,
    this.alsoKnownAs,
    this.biography,
    this.movieCredits,
    this.tvCredits,
    this.combinedCredits,
    this.externalIds, {
    super.popularity,
    super.gender,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    super.profilePath,
    this.homepage,
    this.imdbId,
  });

  int get knownCredits =>
      combinedCredits.cast.length + combinedCredits.crew.length;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ExternalIds {
  String? freebaseMid;
  String? freebaseId;
  String? imdbId;
  int? tvrageId;
  String? wikidataId;
  String? facebookId;
  String? instagramId;
  String? twitterId;

  ExternalIds(
      {this.freebaseMid,
      this.freebaseId,
      this.imdbId,
      this.tvrageId,
      this.wikidataId,
      this.facebookId,
      this.instagramId,
      this.twitterId});

  factory ExternalIds.fromJson(Map<String, dynamic> json) =>
      _$ExternalIdsFromJson(json);

  Map<String, dynamic> toJson() => _$ExternalIdsToJson(this);
}

class PersonWithKnownFor {
  Person? person;
  List<KnownFor>? knownFor;

  PersonWithKnownFor({this.person, this.knownFor});

  bool get isComplete => person != null && knownFor != null;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CombinedCredits {
  List<CombinedOfCast> cast;
  List<CombinedOfCrew> crew;

  CombinedCredits(this.cast, this.crew);

  factory CombinedCredits.fromJson(Map<String, dynamic> json) =>
      _$CombinedCreditsFromJson(json);

  Map<String, dynamic> toJson() => _$CombinedCreditsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieCredits {
  List<MovieOfCast> cast;
  List<MovieOfCrew> crew;

  MovieCredits(this.cast, this.crew);

  factory MovieCredits.fromJson(Map<String, dynamic> json) =>
      _$MovieCreditsFromJson(json);

  Map<String, dynamic> toJson() => _$MovieCreditsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvCredits {
  List<TvOfCast> cast;
  List<TvOfCrew> crew;

  TvCredits(this.cast, this.crew);

  factory TvCredits.fromJson(Map<String, dynamic> json) =>
      _$TvCreditsFromJson(json);

  Map<String, dynamic> toJson() => _$TvCreditsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CombinedOfCast extends CombinedResult {
  final String character;
  final String creditId;
  final int? order;
  final int? episodeCount;

  CombinedOfCast(
    super.id,
    super.overview,
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage,
    this.character,
    this.creditId, {
    super.mediaType,
    super.popularity,
    super.posterPath,
    super.backdropPath,
    super.adult,
    super.originalTitle,
    super.title,
    super.video,
    super.releaseDate,
    super.originCountry,
    super.name,
    super.originalName,
    super.firstAirDate,
    this.order,
    this.episodeCount,
  });

  factory CombinedOfCast.fromJson(Map<String, dynamic> json) =>
      _$CombinedOfCastFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombinedOfCastToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CombinedOfCrew extends CombinedResult {
  final String department, job, creditId;
  final int? episodeCount;

  CombinedOfCrew(
    super.id,
    super.overview,
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage,
    this.department,
    this.creditId,
    this.job, {
    super.mediaType,
    super.popularity,
    super.posterPath,
    super.backdropPath,
    super.adult,
    super.originalTitle,
    super.title,
    super.video,
    super.releaseDate,
    super.originCountry,
    super.name,
    super.originalName,
    super.firstAirDate,
    this.episodeCount,
  });

  factory CombinedOfCrew.fromJson(Map<String, dynamic> json) =>
      _$CombinedOfCrewFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombinedOfCrewToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieOfCast extends MovieResult {
  final String character;
  final String creditId;
  final int? order;

  MovieOfCast(
    super.id,
    super.overview,
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage,
    super.originalTitle,
    super.title,
    super.video,
    this.character,
    this.creditId, {
    // super.mediaType,
    super.popularity,
    super.posterPath,
    super.releaseDate,
    super.backdropPath,
    this.order,
    super.adult,
  });

  factory MovieOfCast.fromJson(Map<String, dynamic> json) =>
      _$MovieOfCastFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovieOfCastToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieOfCrew extends MovieResult {
  final String department;
  final String job;
  final String creditId;

  MovieOfCrew(
    super.id,
    super.overview,
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage,
    super.originalTitle,
    super.title,
    super.video,
    this.department,
    this.creditId,
    this.job, {
    // super.mediaType,
    super.popularity,
    super.posterPath,
    super.releaseDate,
    super.backdropPath,
    super.adult,
  });

  factory MovieOfCrew.fromJson(Map<String, dynamic> json) =>
      _$MovieOfCrewFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovieOfCrewToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvOfCast extends TvResult {
  final String character;
  final String creditId;
  final int? episodeCount;

  TvOfCast(
    super.id,
    super.overview,
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage,
    super.originCountry,
    super.name,
    super.originalName,
    this.character,
    this.creditId, {
    // super.mediaType,
    super.popularity,
    super.posterPath,
    super.backdropPath,
    super.firstAirDate,
    super.adult,
    this.episodeCount,
  });

  factory TvOfCast.fromJson(Map<String, dynamic> json) =>
      _$TvOfCastFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TvOfCastToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvOfCrew extends TvResult {
  final String department, job;
  final String creditId;
  final int? episodeCount;

  TvOfCrew(
    super.id,
    super.overview,
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage,
    super.originCountry,
    super.name,
    super.originalName,
    this.department,
    this.job,
    this.creditId, {
    // super.mediaType,
    super.popularity,
    super.posterPath,
    super.backdropPath,
    super.firstAirDate,
    super.adult,
    this.episodeCount,
  });

  factory TvOfCrew.fromJson(Map<String, dynamic> json) =>
      _$TvOfCrewFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TvOfCrewToJson(this);
}
