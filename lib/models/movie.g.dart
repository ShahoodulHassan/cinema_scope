// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      json['adult'] as bool,
      json['budget'] as int,
      (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['id'] as int,
      json['original_language'] as String,
      json['original_title'] as String,
      (json['popularity'] as num).toDouble(),
      (json['production_companies'] as List<dynamic>)
          .map((e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['production_countries'] as List<dynamic>)
          .map((e) => ProductionCountry.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['revenue'] as int,
      (json['spoken_languages'] as List<dynamic>)
          .map((e) => LanguageConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['status'] as String,
      json['title'] as String,
      json['video'] as bool,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      VideoResult.fromJson(json['videos'] as Map<String, dynamic>),
      SearchResult.fromJson(json['similar'] as Map<String, dynamic>),
      SearchResult.fromJson(json['recommendations'] as Map<String, dynamic>),
      ImageResult.fromJson(json['images'] as Map<String, dynamic>),
      KeywordResult.fromJson(json['keywords'] as Map<String, dynamic>),
      ReviewResult.fromJson(json['reviews'] as Map<String, dynamic>),
      Credits.fromJson(json['credits'] as Map<String, dynamic>),
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      belongsToCollection: json['belongs_to_collection'] == null
          ? null
          : BaseCollection.fromJson(
              json['belongs_to_collection'] as Map<String, dynamic>),
      homepage: json['homepage'] as String?,
      imdbId: json['imdb_id'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      runtime: json['runtime'] as int?,
      tagline: json['tagline'] as String?,
    );

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'belongs_to_collection': instance.belongsToCollection,
      'budget': instance.budget,
      'genres': instance.genres,
      'homepage': instance.homepage,
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'production_companies': instance.productionCompanies,
      'production_countries': instance.productionCountries,
      'release_date': instance.releaseDate,
      'revenue': instance.revenue,
      'runtime': instance.runtime,
      'spoken_languages': instance.spokenLanguages,
      'status': instance.status,
      'tagline': instance.tagline,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'videos': instance.videos,
      'similar': instance.similar,
      'recommendations': instance.recommendations,
      'images': instance.images,
      'keywords': instance.keywords,
      'credits': instance.credits,
      'reviews': instance.reviews,
    };

BaseCollection _$BaseCollectionFromJson(Map<String, dynamic> json) =>
    BaseCollection(
      json['id'] as int,
      json['name'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
    );

Map<String, dynamic> _$BaseCollectionToJson(BaseCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
    };

Genre _$GenreFromJson(Map<String, dynamic> json) => Genre(
      json['id'] as int,
      json['name'] as String,
    );

Map<String, dynamic> _$GenreToJson(Genre instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ProductionCompany _$ProductionCompanyFromJson(Map<String, dynamic> json) =>
    ProductionCompany(
      json['id'] as int,
      json['name'] as String,
      json['origin_country'] as String,
      logoPath: json['logo_path'] as String?,
    );

Map<String, dynamic> _$ProductionCompanyToJson(ProductionCompany instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logo_path': instance.logoPath,
      'name': instance.name,
      'origin_country': instance.originCountry,
    };

ProductionCountry _$ProductionCountryFromJson(Map<String, dynamic> json) =>
    ProductionCountry(
      json['iso_3166_1'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$ProductionCountryToJson(ProductionCountry instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso31661,
      'name': instance.name,
    };

VideoResult _$VideoResultFromJson(Map<String, dynamic> json) => VideoResult(
      (json['results'] as List<dynamic>)
          .map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VideoResultToJson(VideoResult instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      json['iso_639_1'] as String,
      json['iso_3166_1'] as String,
      json['name'] as String,
      json['key'] as String,
      json['site'] as String,
      json['size'] as int,
      json['type'] as String,
      json['official'] as bool,
      json['published_at'] as String,
      json['id'] as String,
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'iso_639_1': instance.iso6391,
      'iso_3166_1': instance.iso31661,
      'name': instance.name,
      'key': instance.key,
      'site': instance.site,
      'size': instance.size,
      'type': instance.type,
      'official': instance.official,
      'published_at': instance.publishedAt,
      'id': instance.id,
    };

ImageResult _$ImageResultFromJson(Map<String, dynamic> json) => ImageResult(
      (json['backdrops'] as List<dynamic>)
          .map((e) => ImageDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['logos'] as List<dynamic>)
          .map((e) => ImageDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['posters'] as List<dynamic>)
          .map((e) => ImageDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ImageResultToJson(ImageResult instance) =>
    <String, dynamic>{
      'backdrops': instance.backdrops,
      'logos': instance.logos,
      'posters': instance.posters,
    };

ImageDetail _$ImageDetailFromJson(Map<String, dynamic> json) => ImageDetail(
      (json['aspect_ratio'] as num).toDouble(),
      json['height'] as int,
      json['file_path'] as String,
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] as int,
      json['width'] as int,
      iso6391: json['iso_639_1'] as String?,
    );

Map<String, dynamic> _$ImageDetailToJson(ImageDetail instance) =>
    <String, dynamic>{
      'aspect_ratio': instance.aspectRatio,
      'height': instance.height,
      'iso_639_1': instance.iso6391,
      'file_path': instance.filePath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'width': instance.width,
    };

ReviewResult _$ReviewResultFromJson(Map<String, dynamic> json) => ReviewResult(
      json['page'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['total_pages'] as int,
      json['total_results'] as int,
    );

Map<String, dynamic> _$ReviewResultToJson(ReviewResult instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      json['author'] as String,
      AuthorDetail.fromJson(json['author_details'] as Map<String, dynamic>),
      json['content'] as String,
      json['created_at'] as String,
      json['id'] as String,
      json['updated_at'] as String,
      json['url'] as String,
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'author': instance.author,
      'author_details': instance.authorDetails,
      'content': instance.content,
      'created_at': instance.createdAt,
      'id': instance.id,
      'updated_at': instance.updatedAt,
      'url': instance.url,
    };

AuthorDetail _$AuthorDetailFromJson(Map<String, dynamic> json) => AuthorDetail(
      json['name'] as String,
      json['username'] as String,
      avatarPath: json['avatar_path'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AuthorDetailToJson(AuthorDetail instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'avatar_path': instance.avatarPath,
      'rating': instance.rating,
    };

KeywordResult _$KeywordResultFromJson(Map<String, dynamic> json) =>
    KeywordResult(
      (json['keywords'] as List<dynamic>)
          .map((e) => Keyword.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KeywordResultToJson(KeywordResult instance) =>
    <String, dynamic>{
      'keywords': instance.keywords,
    };

Keyword _$KeywordFromJson(Map<String, dynamic> json) => Keyword(
      json['id'] as int,
      json['name'] as String,
    );

Map<String, dynamic> _$KeywordToJson(Keyword instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Credits _$CreditsFromJson(Map<String, dynamic> json) => Credits(
      (json['cast'] as List<dynamic>)
          .map((e) => Cast.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['crew'] as List<dynamic>)
          .map((e) => Crew.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreditsToJson(Credits instance) => <String, dynamic>{
      'cast': instance.cast,
      'crew': instance.crew,
    };

BaseCast _$BaseCastFromJson(Map<String, dynamic> json) => BaseCast(
      json['adult'] as bool,
      json['id'] as int,
      json['known_for_department'] as String,
      json['name'] as String,
      json['original_name'] as String,
      (json['popularity'] as num).toDouble(),
      json['credit_id'] as String,
      gender: json['gender'] as int?,
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$BaseCastToJson(BaseCast instance) => <String, dynamic>{
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'credit_id': instance.creditId,
    };

Cast _$CastFromJson(Map<String, dynamic> json) => Cast(
      json['adult'] as bool,
      json['id'] as int,
      json['known_for_department'] as String,
      json['name'] as String,
      json['original_name'] as String,
      (json['popularity'] as num).toDouble(),
      json['cast_id'] as int,
      json['character'] as String,
      json['credit_id'] as String,
      json['order'] as int,
      gender: json['gender'] as int?,
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$CastToJson(Cast instance) => <String, dynamic>{
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'credit_id': instance.creditId,
      'cast_id': instance.castId,
      'character': instance.character,
      'order': instance.order,
    };

Crew _$CrewFromJson(Map<String, dynamic> json) => Crew(
      json['adult'] as bool,
      json['id'] as int,
      json['known_for_department'] as String,
      json['name'] as String,
      json['original_name'] as String,
      (json['popularity'] as num).toDouble(),
      json['credit_id'] as String,
      json['department'] as String,
      json['job'] as String,
      gender: json['gender'] as int?,
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$CrewToJson(Crew instance) => <String, dynamic>{
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'credit_id': instance.creditId,
      'department': instance.department,
      'job': instance.job,
    };
