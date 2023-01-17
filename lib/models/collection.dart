import 'package:cinema_scope/models/movie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Collection extends BaseCollection {
  String overview;
  List<CollectionPart> parts;

  Collection(super.id, super.name, this.overview, this.parts,
      {super.posterPath, super.backdropPath});

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CollectionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CollectionPart {
  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  String releaseDate;
  String? posterPath;
  double popularity;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  CollectionPart(
      this.adult,
      this.genreIds,
      this.id,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.releaseDate,
      this.popularity,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount,
      {this.backdropPath,
      this.posterPath});

  factory CollectionPart.fromJson(Map<String, dynamic> json) =>
      _$CollectionPartFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionPartToJson(this);
}
