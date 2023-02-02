import 'package:cinema_scope/models/search.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieOfCast extends MovieResult {
  final String? character;
  final String? creditId;
  final int? order;

  MovieOfCast(
    super.adult,
    super.overview,
    super.genreIds,
    super.id,
    super.originalTitle,
    super.originalLanguage,
    super.title,
    super.popularity,
    super.voteCount,
    super.video,
    super.voteAverage, {
    super.posterPath,
    super.releaseDate,
    super.backdropPath,
    this.character,
    this.creditId,
    this.order,
  });

  factory MovieOfCast.fromJson(Map<String, dynamic> json) =>
      _$MovieOfCastFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovieOfCastToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieOfCrew extends MovieResult {
  final String? department;
  final String? job;
  final String? creditId;

  MovieOfCrew(
      super.adult,
      super.overview,
      super.genreIds,
      super.id,
      super.originalTitle,
      super.originalLanguage,
      super.title,
      super.popularity,
      super.voteCount,
      super.video,
      super.voteAverage, {
        super.posterPath,
        super.releaseDate,
        super.backdropPath,
        this.department,
        this.creditId,
        this.job,
      });

  factory MovieOfCrew.fromJson(Map<String, dynamic> json) =>
      _$MovieOfCrewFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovieOfCrewToJson(this);
}
