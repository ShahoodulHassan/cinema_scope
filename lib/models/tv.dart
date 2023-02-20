import 'package:cinema_scope/models/person.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:json_annotation/json_annotation.dart';

import 'configuration.dart';
import 'movie.dart';

part 'tv.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Tv extends Media {
  List<CreatedBy> createdBy;
  List<int> episodeRunTime;
  String firstAirDate;
  bool inProduction;
  List<String> languages;
  String lastAirDate;
  TvEpisode lastEpisodeToAir;
  String name;
  TvEpisode? nextEpisodeToAir;
  List<Network> networks;
  int numberOfEpisodes;
  int numberOfSeasons;
  List<String> originCountry;
  String originalName;
  List<TvSeason> seasons;
  List<LanguageConfig> spokenLanguages;
  String type;

  TvAltTitleResult alternativeTitles;
  TvKeywordResult keywords;
  AggregateCredits aggregateCredits;
  ExternalIds? externalIds;

  Tv(
    super.adult,
    super.genres,
    super.id,
    super.originalLanguage,
    super.popularity,
    super.productionCompanies,
    super.productionCountries,
    super.status,
    super.voteAverage,
    super.voteCount,
    super.videos,
    super.recommendations,
    super.images,
    super.reviews,
    this.createdBy,
    this.episodeRunTime,
    this.firstAirDate,
    this.inProduction,
    this.languages,
    this.lastAirDate,
    this.lastEpisodeToAir,
    this.name,
    this.networks,
    this.numberOfEpisodes,
    this.numberOfSeasons,
    this.originCountry,
    this.originalName,
    this.seasons,
    this.spokenLanguages,
    this.type,
    this.keywords,
    this.aggregateCredits,
    this.externalIds,
    this.alternativeTitles, {
    super.backdropPath,
    super.homepage,
    super.overview,
    super.posterPath,
    super.tagline,
    this.nextEpisodeToAir,
  });

  factory Tv.fromJson(Map<String, dynamic> json) => _$TvFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TvToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CreatedBy {
  int id;
  String creditId;
  String name;
  int gender;
  String? profilePath;

  CreatedBy(
    this.id,
    this.creditId,
    this.name,
    this.gender, {
    this.profilePath,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) =>
      _$CreatedByFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedByToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Network {
  int id;
  String name;
  String? logoPath;
  String originCountry;

  Network(
    this.id,
    this.name,
    this.originCountry, {
    this.logoPath,
  });

  factory Network.fromJson(Map<String, dynamic> json) =>
      _$NetworkFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BaseTvCredit extends BasePersonResult {
  int totalEpisodeCount;

  BaseTvCredit(
    super.id,
    super.adult,
    super.name,
    super.knownForDepartment,
    this.totalEpisodeCount, {
    super.popularity,
    super.profilePath,
    super.gender,
  });

  factory BaseTvCredit.fromJson(Map<String, dynamic> json) =>
      _$BaseTvCreditFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BaseTvCreditToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AggregateCredits {
  List<TvCast> cast;
  List<TvCrew> crew;

  AggregateCredits(this.cast, this.crew);

  factory AggregateCredits.fromJson(Map<String, dynamic> json) =>
      _$AggregateCreditsFromJson(json);

  Map<String, dynamic> toJson() => _$AggregateCreditsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvCast extends BaseTvCredit {
  int order;
  List<Role> roles;

  TvCast(
    super.id,
    super.adult,
    super.name,
    super.knownForDepartment,
    super.totalEpisodeCount,
    this.order,
    this.roles, {
    super.popularity,
    super.profilePath,
    super.gender,
  });

  factory TvCast.fromJson(Map<String, dynamic> json) => _$TvCastFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TvCastToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvCrew extends BaseTvCredit {
  String department;
  List<Job> jobs;

  TvCrew(
    super.id,
    super.adult,
    super.name,
    super.knownForDepartment,
    super.totalEpisodeCount,
    this.department,
    this.jobs, {
    super.popularity,
    super.profilePath,
    super.gender,
  });

  factory TvCrew.fromJson(Map<String, dynamic> json) => _$TvCrewFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TvCrewToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Role {
  String creditId;
  String character;
  int episodeCount;

  Role(this.creditId, this.character, this.episodeCount);

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Job {
  String creditId;
  String job;
  int episodeCount;

  Job(this.creditId, this.job, this.episodeCount);

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

  Map<String, dynamic> toJson() => _$JobToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvAltTitleResult {
  List<AlternativeTitle> results;

  TvAltTitleResult(this.results);

  factory TvAltTitleResult.fromJson(Map<String, dynamic> json) =>
      _$TvAltTitleResultFromJson(json);

  Map<String, dynamic> toJson() => _$TvAltTitleResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvBaseResult extends BaseResult {
  String name;
  String overview;
  String? airDate;
  int seasonNumber;
  int? showId;

  TvBaseResult(
    super.id,
    this.name,
    this.overview,
    this.seasonNumber, {
    super.mediaType,
    this.showId,
    this.airDate,
  });

  factory TvBaseResult.fromJson(Map<String, dynamic> json) =>
      _$TvBaseResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TvBaseResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvSeason extends TvBaseResult {
  int? episodeCount;
  String? posterPath;

  TvSeason(
    super.id,
    super.name,
    super.overview,
    super.seasonNumber, {
    super.mediaType,
    super.airDate,
    super.showId,
    this.episodeCount,
    this.posterPath,
  });

  factory TvSeason.fromJson(Map<String, dynamic> json) =>
      _$TvSeasonFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TvSeasonToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvEpisode extends TvBaseResult {
  double voteAverage;
  int voteCount;
  int episodeNumber;
  String? productionCode;
  int? runtime;
  String? stillPath;

  TvEpisode(
    super.id,
    super.name,
    super.overview,
    super.seasonNumber,
    this.voteAverage,
    this.voteCount,
    this.episodeNumber, {
    super.mediaType,
    super.airDate,
    super.showId,
    this.productionCode,
    this.runtime,
    this.stillPath,
  });

  factory TvEpisode.fromJson(Map<String, dynamic> json) =>
      _$TvEpisodeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TvEpisodeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvKeywordResult {
  List<Keyword> results;

  TvKeywordResult(this.results);

  factory TvKeywordResult.fromJson(Map<String, dynamic> json) =>
      _$TvKeywordResultFromJson(json);

  Map<String, dynamic> toJson() => _$TvKeywordResultToJson(this);
}
