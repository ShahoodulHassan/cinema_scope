import 'package:cinema_scope/models/search.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tv.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TvBaseResult extends BaseResult {
  String name;
  String overview;
  String? airDate;
  int seasonNumber;
  int showId;

  TvBaseResult(
    super.id,
    this.name,
    this.overview,
    this.seasonNumber,
    this.showId, {
    super.mediaType,
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
    super.seasonNumber,
    super.showId, {
    super.mediaType,
    super.airDate,
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
    super.showId,
    this.voteAverage,
    this.voteCount,
    this.episodeNumber, {
    super.mediaType,
    super.airDate,
    this.productionCode,
    this.runtime,
    this.stillPath,
  });

  factory TvEpisode.fromJson(Map<String, dynamic> json) =>
      _$TvEpisodeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TvEpisodeToJson(this);
}
