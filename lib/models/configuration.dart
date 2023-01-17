


import 'package:json_annotation/json_annotation.dart';

part 'configuration.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ApiConfiguration {
  ImageConfig images;
  List<String> changeKeys;

  ApiConfiguration(this.images, this.changeKeys);

  factory ApiConfiguration.fromJson(Map<String, dynamic> json) =>
      _$ApiConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$ApiConfigurationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ImageConfig {
  String baseUrl;
  String secureBaseUrl;
  List<String> backdropSizes;
  List<String> logoSizes;
  List<String> posterSizes;
  List<String> profileSizes;
  List<String> stillSizes;

  ImageConfig(this.baseUrl, this.secureBaseUrl, this.backdropSizes, this.logoSizes,
      this.posterSizes, this.profileSizes, this.stillSizes);

  factory ImageConfig.fromJson(Map<String, dynamic> json) => _$ImageConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ImageConfigToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LanguageConfig {
  String englishName;

  @JsonKey(name: 'iso_639_1')
  String iso6391;

  String name;

  LanguageConfig(this.englishName, this.iso6391, this.name);

  factory LanguageConfig.fromJson(Map<String, dynamic> json) =>
      _$LanguageConfigFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageConfigToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CountryConfig {
  @JsonKey(name: 'iso_3166_1')
  String iso31661;

  String englishName;

  CountryConfig(this.iso31661, this.englishName);

  factory CountryConfig.fromJson(Map<String, dynamic> json) =>
      _$CountryConfigFromJson(json);

  Map<String, dynamic> toJson() => _$CountryConfigToJson(this);
}