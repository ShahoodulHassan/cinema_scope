import 'package:json_annotation/json_annotation.dart';

import '../constants.dart';

part 'search.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieSearchResult {
  int page;
  List<MovieResult> results;
  int totalPages;
  int totalResults;

  MovieSearchResult(
      this.page, this.results, this.totalPages, this.totalResults);

  factory MovieSearchResult.fromJson(Map<String, dynamic> json) =>
      _$MovieSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$MovieSearchResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MultiSearchResult {
  int page;
  List<BaseResult> results;
  int totalPages;
  int totalResults;

  MultiSearchResult(
      this.page, this.results, this.totalPages, this.totalResults);

  factory MultiSearchResult.fromJson(Map<String, dynamic> json) =>
      MultiSearchResult(
        json['page'] as int,
        (json['results'] as List<dynamic>).map((e) {
          var base = BaseResult.fromJson(e as Map<String, dynamic>);
          if (base.mediaType == MediaType.movie.name) {
            return MovieResult.fromJson(e);
          } else if (base.mediaType == MediaType.tv.name) {
            return TvResult.fromJson(e);
          } else {
            return PersonResult.fromJson(e);
          }
        }).toList(),
        json['total_pages'] as int,
        json['total_results'] as int,
      );

  // factory MultiSearchResult.fromJson(Map<String, dynamic> json) =>
  //     _$MultiSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$MultiSearchResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BaseResult {
  int id;
  String? mediaType;
  double? popularity;

  BaseResult(
    this.id, {
    this.mediaType,
    this.popularity,
  });

  factory BaseResult.fromJson(Map<String, dynamic> json) =>
      _$BaseResultFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MediaResult extends BaseResult {
  String? posterPath;
  String? backdropPath;
  String overview;
  List<int> genreIds;
  int voteCount;
  double voteAverage;
  String originalLanguage;

  MediaResult(
    super.id,
    this.overview,
    this.genreIds,
    this.voteCount,
    this.voteAverage,
    this.originalLanguage, {
    super.mediaType,
    super.popularity,
    this.posterPath,
    this.backdropPath,
  });

  factory MediaResult.fromJson(Map<String, dynamic> json) =>
      _$MediaResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MediaResultToJson(this);
}

/// Decided to combine both movie and tv related fields into this one object,
/// just for the sake of less objects to choose from.
/// For ease, getters have been implemented to provide the value according to
/// the mediaType the instance belongs to.
@JsonSerializable(fieldRename: FieldRename.snake)
class KnownFor extends MediaResult {
  /// Movie related field
  bool? adult;
  bool? video;

  @JsonKey(name: 'release_date', includeFromJson: true, includeToJson: true)
  String? _releaseDate;

  @JsonKey(name: 'original_title', includeFromJson: true, includeToJson: true)
  String? _originalTitle;

  @JsonKey(name: 'title', includeFromJson: true, includeToJson: true)
  String? _title;

  /// TV related fields
  @JsonKey(name: 'first_air_date', includeFromJson: true, includeToJson: true)
  String? _firstAirDate;

  @JsonKey(name: 'origin_country', includeFromJson: true, includeToJson: true)
  List<String>? _originCountry;

  @JsonKey(name: 'name', includeFromJson: true, includeToJson: true)
  String? _name;

  @JsonKey(name: 'original_name', includeFromJson: true, includeToJson: true)
  String? _originalName;

  KnownFor(
    super.id,
    super.overview,
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage,
    this._title,
    this._name,
    this._firstAirDate,
    this._releaseDate,
    this._originCountry,
    this._originalName,
    this._originalTitle, {
    super.mediaType,
    super.popularity,
    super.posterPath,
    super.backdropPath,
    this.adult,
    String? originalTitle,
    String? title,
    String? firstAirDate,
    this.video,
    String? releaseDate,
    List<String>? originCountry,
    String? name,
    String? originalName,
  });

  String get mediaTitle =>
      (mediaType == MediaType.movie.name ? _title : _name) ?? '-';

  String? get mediaReleaseDate =>
      mediaType == MediaType.movie.name ? _releaseDate : _firstAirDate;

  factory KnownFor.fromJson(Map<String, dynamic> json) =>
      _$KnownForFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$KnownForToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieResult extends MediaResult {
  /// It has been made nullable after a bug where movie id 272803 has no
  /// release_date field
  String? releaseDate;
  bool adult;
  String originalTitle;
  String title;
  bool video;

  MovieResult(
    super.id,
    super.overview,
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage,
    this.adult,
    this.originalTitle,
    this.title,
    this.video, {
    super.mediaType,
    super.popularity,
    super.posterPath,
    super.backdropPath,
    this.releaseDate,
  });

  String get movieTitle => title;

  factory MovieResult.fromJson(Map<String, dynamic> json) =>
      _$MovieResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovieResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TvResult extends MediaResult {
  String? firstAirDate;
  List<String> originCountry;
  String name;
  String originalName;

  TvResult(
    super.id,
    super.overview,
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage,
    this.originCountry,
    this.name,
    this.originalName, {
    super.mediaType,
    super.popularity,
    super.posterPath,
    super.backdropPath,
    this.firstAirDate,
  });

  factory TvResult.fromJson(Map<String, dynamic> json) =>
      _$TvResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TvResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BasePersonResult extends BaseResult {
  String? profilePath;
  bool adult;
  String knownForDepartment;
  String name;
  int? gender;

  BasePersonResult(
    super.id,
    this.adult,
    this.name,
    this.knownForDepartment, {
    super.mediaType,
    super.popularity,
    this.profilePath,
    this.gender,
  });

  factory BasePersonResult.fromJson(Map<String, dynamic> json) =>
      _$BasePersonResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BasePersonResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PersonResult extends BasePersonResult {
  List<KnownFor> knownFor;

  PersonResult(
    super.id,
    super.adult,
    super.name,
    super.knownForDepartment,
    this.knownFor, {
    super.mediaType,
    super.popularity,
    super.profilePath,
    super.gender,
  });

  factory PersonResult.fromJson(Map<String, dynamic> json) =>
      _$PersonResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PersonResultToJson(this);
}
