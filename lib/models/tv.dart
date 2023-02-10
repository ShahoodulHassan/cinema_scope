import 'package:cinema_scope/models/search.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tv.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TvEpisode extends BaseResult {
  String name;
  String overview;
  double voteAverage;
  int voteCount;
  String? airDate;
  int episodeNumber;
  String? productionCode;
  int? runtime;
  int seasonNumber;
  int showId;
  String? stillPath;

  TvEpisode(super.id, this.name, this.overview, this.voteAverage,
      this.voteCount, this.episodeNumber, this.seasonNumber, this.showId,
      {super.mediaType,
      this.airDate,
      this.productionCode,
      this.runtime,
      this.stillPath});

  factory TvEpisode.fromJson(Map<String, dynamic> json) =>
      _$TvEpisodeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TvEpisodeToJson(this);
}
