import 'package:cinema_scope/models/search.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Person {
  bool adult;
  List<String> alsoKnownAs;
  String biography;
  String? birthday;
  String? deathday;
  int? gender;
  String? homepage;
  int id;
  String? imdbId;
  String knownForDepartment;
  String name;
  String? placeOfBirth;
  double popularity;
  String? profilePath;
  MovieCredits movieCredits;

  Person(
    this.adult,
    this.alsoKnownAs,
    this.biography,
    this.id,
    this.knownForDepartment,
    this.name,
    this.popularity,
    this.movieCredits, {
    this.gender,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    this.profilePath,
    this.homepage,
    this.imdbId,
  });

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
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
    super.adult,
    super.originalTitle,
    super.title,
    super.video,
    this.character,
    this.creditId, {
    super.mediaType,
    super.popularity,
    super.posterPath,
    super.releaseDate,
    super.backdropPath,
    this.order,
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
    super.adult,
    super.originalTitle,
    super.title,
    super.video,
    this.department,
    this.creditId,
    this.job, {
    super.mediaType,
    super.popularity,
    super.posterPath,
    super.releaseDate,
    super.backdropPath,
  });

  factory MovieOfCrew.fromJson(Map<String, dynamic> json) =>
      _$MovieOfCrewFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovieOfCrewToJson(this);

}
