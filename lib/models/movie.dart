import 'package:cinema_scope/constants.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utilities/utilities.dart';
import 'configuration.dart';

part 'movie.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Media {
  bool adult;
  String? backdropPath;
  List<Genre> genres;
  String? homepage;
  int id;
  String originalLanguage;
  String? overview;
  double popularity;
  String? posterPath;
  List<ProductionCompany> productionCompanies;
  List<ProductionCountry> productionCountries;
  String status;
  String? tagline;
  double voteAverage;
  int voteCount;

  VideoResult videos;
  ImageResult images;
  CombinedResults recommendations;
  ReviewResult reviews;

  @JsonKey(name: 'watch/providers')
  WatchProviders? watchProviders;

  Media(
      this.adult,
      this.genres,
      this.id,
      this.originalLanguage,
      this.popularity,
      this.productionCompanies,
      this.productionCountries,
      this.status,
      this.voteAverage,
      this.voteCount,
      this.videos,
      this.recommendations,
      this.images,
      this.reviews,
      this.watchProviders,
      {this.backdropPath,
      this.homepage,
      this.overview,
      this.posterPath,
      this.tagline});

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  Map<String, dynamic> toJson() => _$MediaToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Movie extends Media {
  BaseCollection? belongsToCollection;
  int budget;
  bool video;
  String? imdbId;
  String originalTitle;
  String? releaseDate;
  int revenue;
  int? runtime;
  List<LanguageConfig> spokenLanguages;
  KeywordResult keywords;
  MovieAltTitleResult alternativeTitles;

  String title;

  // // MovieSearchResult similar;
  // MovieSearchResult recommendations;

  Credits credits;

  ReleaseDates releaseDates;

  Movie(
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
    super.watchProviders,
    this.originalTitle,
    this.budget,
    this.revenue,
    this.spokenLanguages,
    this.title,
    this.video,
    this.credits,
    this.keywords,
    this.releaseDates,
    this.alternativeTitles, {
    super.backdropPath,
    super.homepage,
    super.overview,
    super.posterPath,
    super.tagline,
    this.releaseDate,
    this.belongsToCollection,
    this.runtime,
    this.imdbId,
  });

  String get movieTitle => title;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  @override
  String toString() {
    return (StringBuffer('Movie: ')
          ..write('title: $title\t')
          ..write(
              'synopsis: ${overview?.substring(0, (overview?.length ?? 0) ~/ 3)}\t')
          ..write('genres: $genres\t')
          ..write('date: $releaseDate'))
        .toString();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BaseCollection {
  int id;
  String name;
  String? posterPath;
  String? backdropPath;

  BaseCollection(this.id, this.name, {this.posterPath, this.backdropPath});

  factory BaseCollection.fromJson(Map<String, dynamic> json) =>
      _$BaseCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$BaseCollectionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Genre {
  int id;
  String name;

  Genre(this.id, this.name);

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);

  @override
  String toString() {
    return (StringBuffer('Genre: ')..write('name: $name')).toString();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductionCompany {
  int id;
  String? logoPath;
  String name;
  String? originCountry;

  ProductionCompany(this.id, this.name, {this.logoPath, this.originCountry});

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      _$ProductionCompanyFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCompanyToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductionCountry {
  @JsonKey(name: 'iso_3166_1')
  String iso31661;

  String name;

  ProductionCountry(this.iso31661, this.name);

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      _$ProductionCountryFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCountryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class VideoResult {
  List<Video> results;

  VideoResult(this.results);

  factory VideoResult.fromJson(Map<String, dynamic> json) =>
      _$VideoResultFromJson(json);

  Map<String, dynamic> toJson() => _$VideoResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Video {
  @JsonKey(name: 'iso_639_1')
  String iso6391;

  @JsonKey(name: 'iso_3166_1')
  String iso31661;

  String name;
  String key;
  String site;
  int size;
  String type;
  bool official;
  String publishedAt;
  String id;

  Video(this.iso6391, this.iso31661, this.name, this.key, this.site, this.size,
      this.type, this.official, this.publishedAt, this.id);

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ImageResult {
  List<ImageDetail> backdrops;
  List<ImageDetail> logos;
  List<ImageDetail> posters;

  ImageResult(this.backdrops, this.logos, this.posters);

  factory ImageResult.fromJson(Map<String, dynamic> json) =>
      _$ImageResultFromJson(json);

  Map<String, dynamic> toJson() => _$ImageResultToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class ImageDetail {
  double aspectRatio;
  int height;

  @JsonKey(name: 'iso_639_1')
  String? iso6391;

  String filePath;
  double voteAverage;
  int voteCount;
  int width;

  String? imageType;

  ImageDetail(this.aspectRatio, this.height, this.filePath, this.voteAverage,
      this.voteCount, this.width,
      {this.iso6391, this.imageType});

  factory ImageDetail.fromJson(Map<String, dynamic> json) =>
      _$ImageDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ImageDetailToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class CombinedResults extends BaseSearchResult {
  List<CombinedResult> results;

  CombinedResults(
      super.page, super.totalPages, super.totalResults, this.results);

  factory CombinedResults.fromJson(Map<String, dynamic> json) =>
      _$CombinedResultsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombinedResultsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReviewResult {
  int page;
  List<Review> results;
  int totalPages;
  int totalResults;

  ReviewResult(this.page, this.results, this.totalPages, this.totalResults);

  factory ReviewResult.fromJson(Map<String, dynamic> json) =>
      _$ReviewResultFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Review {
  String author;
  AuthorDetail authorDetails;
  String content;
  String createdAt;
  String id;
  String updatedAt;
  String url;

  Review(this.author, this.authorDetails, this.content, this.createdAt, this.id,
      this.updatedAt, this.url);

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthorDetail {
  String name;
  String username;
  String? avatarPath;
  double? rating;

  AuthorDetail(this.name, this.username, {this.avatarPath, this.rating});

  factory AuthorDetail.fromJson(Map<String, dynamic> json) =>
      _$AuthorDetailFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorDetailToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class KeywordResult {
  List<Keyword> keywords;

  KeywordResult(this.keywords);

  factory KeywordResult.fromJson(Map<String, dynamic> json) =>
      _$KeywordResultFromJson(json);

  Map<String, dynamic> toJson() => _$KeywordResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Keyword {
  int id;
  String name;

  Keyword(this.id, this.name);

  factory Keyword.fromJson(Map<String, dynamic> json) =>
      _$KeywordFromJson(json);

  Map<String, dynamic> toJson() => _$KeywordToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Credits {
  List<Cast> cast;
  List<Crew> crew;

  Credits(this.cast, this.crew);

  factory Credits.fromJson(Map<String, dynamic> json) =>
      _$CreditsFromJson(json);

  Map<String, dynamic> toJson() => _$CreditsToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class BaseCredit extends BasePersonResult {
  String originalName;
  String creditId;

  BaseCredit(
    super.id,
    super.adult,
    super.name,
    this.originalName,
    this.creditId, {
    // super.mediaType,
    super.popularity,
    super.profilePath,
    super.gender,
    super.knownForDepartment,
  });

  factory BaseCredit.fromJson(Map<String, dynamic> json) =>
      _$BaseCreditFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BaseCreditToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class Cast extends BaseCredit {
  int castId;
  String character;
  int order;

  Cast(
    super.id,
    super.adult,
    super.name,
    super.originalName,
    super.creditId,
    this.castId,
    this.character,
    this.order, {
    super.popularity,
    super.profilePath,
    super.gender,
    super.knownForDepartment,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CastToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class Crew extends BaseCredit {
  String department;
  String job;

  /// A custom field that contains comma separated jobs of a crew member in a
  /// media title.
  /// e.g., (Screenplay, Writer, Adaptation)
  String? jobs;

  Crew(
    super.id,
    super.adult,
    super.name,
    super.originalName,
    super.creditId,
    this.department,
    this.job, {
    super.popularity,
    super.gender,
    super.knownForDepartment,
    super.profilePath,
    this.jobs,
  });

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CrewToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MediaGenre extends Genre {
  final MediaType mediaType;

  MediaGenre(super.id, super.name, this.mediaType);

  factory MediaGenre.fromGenre({
    required Genre genre,
    required MediaType mediaType,
  }) =>
      MediaGenre(genre.id, genre.name, mediaType);

  factory MediaGenre.fromJson(Map<String, dynamic> json) =>
      _$MediaGenreFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MediaGenreToJson(this);

  @override
  String toString() {
    return (StringBuffer('MediaGenre: ')
          ..write('type: ${mediaType.name}\t')
          ..write('name: $name'))
        .toString();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReleaseDates {
  List<ReleaseDatesResult> results;

  ReleaseDates({required this.results});

  factory ReleaseDates.fromJson(Map<String, dynamic> json) =>
      _$ReleaseDatesFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseDatesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReleaseDatesResult {
  @JsonKey(name: 'iso_3166_1')
  String iso31661;

  List<ReleaseDate> releaseDates;

  ReleaseDatesResult(this.iso31661, this.releaseDates);

  factory ReleaseDatesResult.fromJson(Map<String, dynamic> json) =>
      _$ReleaseDatesResultFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseDatesResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReleaseDate {
  String certification;

  @JsonKey(name: 'iso_639_1')
  String iso6391;

  String? note;

  String releaseDate;
  int type;

  ReleaseDate(
    this.certification,
    this.iso6391,
    this.releaseDate,
    this.type, {
    this.note,
  });

  factory ReleaseDate.fromJson(Map<String, dynamic> json) =>
      _$ReleaseDateFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseDateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieAltTitleResult {
  List<AlternativeTitle> titles;

  MovieAltTitleResult(this.titles);

  factory MovieAltTitleResult.fromJson(Map<String, dynamic> json) =>
      _$MovieAltTitleResultFromJson(json);

  Map<String, dynamic> toJson() => _$MovieAltTitleResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AlternativeTitle {
  @JsonKey(name: 'iso_3166_1')
  String iso31661;

  String title;
  String type;

  AlternativeTitle(this.iso31661, this.title, this.type);

  factory AlternativeTitle.fromJson(Map<String, dynamic> json) =>
      _$AlternativeTitleFromJson(json);

  Map<String, dynamic> toJson() => _$AlternativeTitleToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RecommendationResult extends BaseSearchResult {
  List<CombinedResult> results;

  RecommendationResult(
      super.page, super.totalPages, super.totalResults, this.results);

  factory RecommendationResult.fromJson(Map<String, dynamic> json) =>
      _$RecommendationResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RecommendationResultToJson(this);
}

/// That's a custom object unrelated to what objects the API has to offer
class RecommendationData with Utilities, GenericFunctions {
  final int mediaId;
  final CombinedResults result;

  RecommendationData(this.mediaId, this.result);

  List<CombinedResult> get recommendations =>
      (result.results..removeWhere((element) => element.posterPath == null)..map((e) {
        e.yearString = getYearStringFromDate(e.mediaReleaseDate);
        e.dateString = getReadableDate(e.mediaReleaseDate);
        return e;
      }).toList());

  int get totalResults => result.totalResults;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WatchProvider {
  String? logoPath;
  int providerId;
  String providerName;
  int displayPriority;

  WatchProvider(
    this.providerId,
    this.providerName,
    this.displayPriority, {
    this.logoPath,
  });

  factory WatchProvider.fromJson(Map<String, dynamic> json) =>
      _$WatchProviderFromJson(json);

  Map<String, dynamic> toJson() => _$WatchProviderToJson(this);

  @override
  String toString() {
    return 'WatchProvider{logoPath: $logoPath, providerId: $providerId, providerName: $providerName, displayPriority: $displayPriority}';
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WatchProviderResult {
  String link;
  List<WatchProvider>? flatrate;
  List<WatchProvider>? buy;
  List<WatchProvider>? rent;
  List<WatchProvider>? free;
  List<WatchProvider>? ads;

  WatchProviderResult(
    this.link, {
    this.flatrate,
    this.buy,
    this.rent,
    this.free,
    this.ads,
  });

  factory WatchProviderResult.fromJson(Map<String, dynamic> json) =>
      _$WatchProviderResultFromJson(json);

  Map<String, dynamic> toJson() => _$WatchProviderResultToJson(this);

  @override
  String toString() {
    return 'WatchProviderResult{link: $link, flatrate: $flatrate, buy: $buy, '
        'rent: $rent, free: $free, ads: $ads}';
  }
}

/// Custom JSON serialization has to be implemented due to the unusual JSON
/// structure as pointed out here:
/// https://www.themoviedb.org/talk/63fba2e757176f008544a439
@JsonSerializable(fieldRename: FieldRename.snake)
class WatchProviderResults {
  // @JsonKey(name: 'US')
  WatchProviderResult? wpResult;

  WatchProviderResults(this.wpResult);

  factory WatchProviderResults.fromJson(Map<String, dynamic> json) {
    String region = PrefUtil.getValue(Constants.pkRegion, 'US');
    return WatchProviderResults(
      json[region] == null
          ? null
          : WatchProviderResult.fromJson(json[region] as Map<String, dynamic>),
    );
  }

  // factory WatchProviderResults.fromJson(Map<String, dynamic> json) =>
  //     _$WatchProviderResultsFromJson(json);

  Map<String, dynamic> toJson() => _$WatchProviderResultsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WatchProviders {
  WatchProviderResults results;

  WatchProviders(this.results);

  factory WatchProviders.fromJson(Map<String, dynamic> json) =>
      _$WatchProvidersFromJson(json);

  Map<String, dynamic> toJson() => _$WatchProvidersToJson(this);
}
