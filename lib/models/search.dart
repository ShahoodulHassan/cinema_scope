import 'package:json_annotation/json_annotation.dart';

import '../constants.dart';

part 'search.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BaseSearchResult {
  int page;
  int totalPages;
  int totalResults;

  BaseSearchResult(this.page, this.totalPages, this.totalResults);

  factory BaseSearchResult.fromJson(Map<String, dynamic> json) =>
      _$BaseSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$BaseSearchResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieSearchResult extends BaseSearchResult {
  List<MovieResult> results;

  MovieSearchResult(
      super.page, super.totalPages, super.totalResults, this.results);

  factory MovieSearchResult.fromJson(Map<String, dynamic> json) =>
      _$MovieSearchResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovieSearchResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PersonSearchResult extends BaseSearchResult {
  List<PersonResult> results;

  PersonSearchResult(
      super.page, super.totalPages, super.totalResults, this.results);

  factory PersonSearchResult.fromJson(Map<String, dynamic> json) =>
      _$PersonSearchResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PersonSearchResultToJson(this);
}

/// Custom fromJson had to be implemented to cater for the different sub classes
/// of BaseResult that may be found inside the 'results' variable.
@JsonSerializable(fieldRename: FieldRename.snake)
class MultiSearchResult extends BaseSearchResult {
  List<BaseResult> results;

  MultiSearchResult(
      super.page, super.totalPages, super.totalResults, this.results);

  factory MultiSearchResult.fromJson(Map<String, dynamic> json) =>
      MultiSearchResult(
        json['page'] as int,
        json['total_pages'] as int,
        json['total_results'] as int,
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
      );

  // factory MultiSearchResult.fromJson(Map<String, dynamic> json) =>
  //     _$MultiSearchResultFromJson(json);

  @override
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
  bool? adult;

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
    this.adult,
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
// @JsonSerializable(fieldRename: FieldRename.snake)
// class KnownFor extends MediaResult {
//   /// Movie related fields
//   bool? video;
//
//   @JsonKey(name: 'release_date', includeFromJson: true, includeToJson: true)
//   String? _releaseDate;
//
//   @JsonKey(name: 'original_title', includeFromJson: true, includeToJson: true)
//   String? _originalTitle;
//
//   @JsonKey(name: 'title', includeFromJson: true, includeToJson: true)
//   String? _title;
//
//   /// TV related fields
//   @JsonKey(name: 'first_air_date', includeFromJson: true, includeToJson: true)
//   String? _firstAirDate;
//
//   @JsonKey(name: 'origin_country', includeFromJson: true, includeToJson: true)
//   List<String>? _originCountry;
//
//   @JsonKey(name: 'name', includeFromJson: true, includeToJson: true)
//   String? _name;
//
//   @JsonKey(name: 'original_name', includeFromJson: true, includeToJson: true)
//   String? _originalName;
//
//   KnownFor(
//     super.id,
//     super.overview,
//     super.genreIds,
//     super.voteCount,
//     super.voteAverage,
//     super.originalLanguage,
//     this._title,
//     this._name,
//     this._firstAirDate,
//     this._releaseDate,
//     this._originCountry,
//     this._originalName,
//     this._originalTitle, {
//     super.mediaType,
//     super.popularity,
//     super.posterPath,
//     super.backdropPath,
//     super.adult,
//     String? originalTitle,
//     String? title,
//     String? firstAirDate,
//     this.video,
//     String? releaseDate,
//     List<String>? originCountry,
//     String? name,
//     String? originalName,
//   });
//
//   String get mediaTitle =>
//       (mediaType == MediaType.movie.name ? _title : _name) ?? '-';
//
//   String? get mediaReleaseDate =>
//       mediaType == MediaType.movie.name ? _releaseDate : _firstAirDate;
//
//   factory KnownFor.fromJson(Map<String, dynamic> json) =>
//       _$KnownForFromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() => _$KnownForToJson(this);
// }

@JsonSerializable(fieldRename: FieldRename.snake)
class CombinedResult extends MediaResult {
  /// It has been made nullable after a bug where movie id 272803 has no
  /// release_date field (in search endpoint)
  String? releaseDate, firstAirDate;
  List<String>? originCountry;
  String? originalTitle, title, name, originalName;
  bool? video;

  CombinedResult(
    super.id,
    super.overview,
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage, {
    super.mediaType,
    super.popularity,
    super.posterPath,
    super.backdropPath,
    super.adult,
    this.originalTitle,
    this.title,
    this.video,
    this.releaseDate,
    this.originCountry,
    this.name,
    this.originalName,
    this.firstAirDate,
  });

  String get mediaTitle => name ?? title ?? ''/*mediaType == MediaType.tv.name ? name! : title!*/;

  String? get mediaReleaseDate => firstAirDate ?? releaseDate;
      /*mediaType == MediaType.tv.name ? firstAirDate : releaseDate;*/

  factory CombinedResult.fromJson(Map<String, dynamic> json) =>
      _$CombinedResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombinedResultToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CombinedResult &&
          id == other.id;

  @override
  int get hashCode => title.hashCode;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieResult extends MediaResult {
  /// It has been made nullable after a bug where movie id 272803 has no
  /// release_date field
  String? releaseDate;
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
    this.originalTitle,
    this.title,
    this.video, {
    // super.mediaType,
    super.popularity,
    super.posterPath,
    super.backdropPath,
    super.adult,
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
    // super.mediaType,
    super.popularity,
    super.posterPath,
    super.backdropPath,
    this.firstAirDate,
    super.adult,
  });

  factory TvResult.fromJson(Map<String, dynamic> json) =>
      _$TvResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TvResultToJson(this);
}

/// Subclasses: BaseCast, Person
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
    // super.mediaType,
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
  List<CombinedResult> knownFor;

  PersonResult(
    super.id,
    super.adult,
    super.name,
    super.knownForDepartment,
    this.knownFor, {
    // super.mediaType,
    super.popularity,
    super.profilePath,
    super.gender,
  });

  factory PersonResult.fromJson(Map<String, dynamic> json) =>
      _$PersonResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PersonResultToJson(this);
}
