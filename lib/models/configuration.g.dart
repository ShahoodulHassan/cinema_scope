// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiConfiguration _$ApiConfigurationFromJson(Map<String, dynamic> json) =>
    ApiConfiguration(
      ImageConfig.fromJson(json['images'] as Map<String, dynamic>),
      (json['change_keys'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ApiConfigurationToJson(ApiConfiguration instance) =>
    <String, dynamic>{
      'images': instance.images,
      'change_keys': instance.changeKeys,
    };

ImageConfig _$ImageConfigFromJson(Map<String, dynamic> json) => ImageConfig(
      json['base_url'] as String,
      json['secure_base_url'] as String,
      (json['backdrop_sizes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['logo_sizes'] as List<dynamic>).map((e) => e as String).toList(),
      (json['poster_sizes'] as List<dynamic>).map((e) => e as String).toList(),
      (json['profile_sizes'] as List<dynamic>).map((e) => e as String).toList(),
      (json['still_sizes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ImageConfigToJson(ImageConfig instance) =>
    <String, dynamic>{
      'base_url': instance.baseUrl,
      'secure_base_url': instance.secureBaseUrl,
      'backdrop_sizes': instance.backdropSizes,
      'logo_sizes': instance.logoSizes,
      'poster_sizes': instance.posterSizes,
      'profile_sizes': instance.profileSizes,
      'still_sizes': instance.stillSizes,
    };

LanguageConfig _$LanguageConfigFromJson(Map<String, dynamic> json) =>
    LanguageConfig(
      json['english_name'] as String,
      json['iso_639_1'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$LanguageConfigToJson(LanguageConfig instance) =>
    <String, dynamic>{
      'english_name': instance.englishName,
      'iso_639_1': instance.iso6391,
      'name': instance.name,
    };

CountryConfig _$CountryConfigFromJson(Map<String, dynamic> json) =>
    CountryConfig(
      json['iso_3166_1'] as String,
      json['english_name'] as String,
    );

Map<String, dynamic> _$CountryConfigToJson(CountryConfig instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso31661,
      'english_name': instance.englishName,
    };

GenreResult _$GenreResultFromJson(Map<String, dynamic> json) => GenreResult(
      (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GenreResultToJson(GenreResult instance) =>
    <String, dynamic>{
      'genres': instance.genres,
    };
