
import 'package:json_annotation/json_annotation.dart';

part 'search.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SearchResult {
  int page;
  List<MovieResult> results;
  int totalPages;
  int totalResults;

  SearchResult(this.page, this.results, this.totalPages, this.totalResults);

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieResult {
  String? posterPath;
  bool adult;
  String overview;

  /// It has been made nullable after a bug where movie id 272803 has no
  /// release_date field
  String? releaseDate;
  List<int> genreIds;
  int id;
  String originalTitle;
  String originalLanguage;
  String title;
  String? backdropPath;
  double popularity;
  int voteCount;
  bool video;
  double voteAverage;

  MovieResult(
      this.adult,
      this.overview,
      this.genreIds,
      this.id,
      this.originalTitle,
      this.originalLanguage,
      this.title,
      this.popularity,
      this.voteCount,
      this.video,
      this.voteAverage,
      {this.posterPath,
        this.releaseDate,
        this.backdropPath});

  String get movieTitle => title;

  factory MovieResult.fromJson(Map<String, dynamic> json) =>
      _$MovieResultFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResultToJson(this);
}