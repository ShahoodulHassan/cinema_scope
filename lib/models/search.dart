import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
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
@CopyWith()
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
            return CombinedResult.fromJson(e);
          } else if (base.mediaType == MediaType.tv.name) {
            return CombinedResult.fromJson(e);
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

/// TODO 19/06/2023 'genreIds, voteCount, voteAverage, originalLanguage' have
/// been given a constant value after experiencing an issue where when
/// Judie Delpy was clicked in the cast of
/// movie named 'Before Sunset', the cast included a Collection [id:109701]
/// with null genreIds field.
/// I should report it by asking:
/// 1) why a collection is being returned in cast credits
/// 2) how to differentiate a collection from a regular cast credit
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
    this.overview, {
    this.genreIds = const <int>[],
    this.voteCount = 0,
    this.voteAverage = 0.0,
    this.originalLanguage = '',
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

@JsonSerializable(fieldRename: FieldRename.snake)
class CombinedResult extends MediaResult with GenericFunctions {
  /// It has been made nullable after a bug where movie id 272803 has no
  /// release_date field (in search endpoint)
  String? releaseDate, firstAirDate;
  List<String>? originCountry;
  String? originalTitle, title, name, originalName;
  bool? video;
  String deptJobsString;
  String genreNamesString;
  String dateString, yearString;

  CombinedResult(
    super.id,
    super.overview, {
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage,
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
    this.deptJobsString = '',
    this.genreNamesString = '',
    this.dateString = '',
    this.yearString = '',
  });

  String get mediaTitle => name ?? title ?? '';

  /*mediaType == MediaType.tv.name ? name! : title!*/

  String? get mediaReleaseDate => firstAirDate ?? releaseDate;

  /*mediaType == MediaType.tv.name ? firstAirDate : releaseDate;*/

  factory CombinedResult.fromJson(Map<String, dynamic> json) {
    if (json['overview'] == null) debugPrint('json:$json');
    return _$CombinedResultFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$CombinedResultToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CombinedResult && id == other.id;

  @override
  int get hashCode => title.hashCode;
}

// TODO See if we really need MovieResult and TvResult separately or having
//  only a CombinedResult suffices
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
    this.originalTitle,
    this.title,
    this.video, {
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage,
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
    this.originCountry,
    this.name,
    this.originalName, {
    super.genreIds,
    super.voteCount,
    super.voteAverage,
    super.originalLanguage,
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
    this.name, {
    // super.mediaType,
    super.popularity,
    this.profilePath,
    this.gender,
    this.knownForDepartment = '',
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
    this.knownFor, {
    // super.mediaType,
    super.popularity,
    super.profilePath,
    super.gender,
    super.knownForDepartment,
  });

  factory PersonResult.fromJson(Map<String, dynamic> json) =>
      _$PersonResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PersonResultToJson(this);
}
