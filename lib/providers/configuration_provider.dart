import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cinema_scope/providers/search_provider.dart';
import 'package:cinema_scope/constants.dart';
import 'package:flutter/foundation.dart';

import '../models/configuration.dart';
import '../models/movie.dart';
import '../utilities/utilities.dart';

class ConfigurationProvider extends ApiProvider {
  final int interval = kDebugMode ? 2 : 15;

  /// In prod, it is 15 days

  AppLifecycleState _appState = AppLifecycleState.detached;

  ApiConfiguration? get apiConfig => getPrefApiConfiguration();

  List<CountryConfig> get cfgCountries => getPrefCountryConfig();

  List<LanguageConfig> get cfgLanguages => getPrefLanguageConfig();

  List<String> get cfgTranslations => getPrefTranslationConfig();

  List<MediaGenre> get combinedGenres => getPrefCombinedGenres();

  bool get isConfigComplete =>
      apiConfig != null &&
      cfgCountries.isNotEmpty &&
      cfgLanguages.isNotEmpty &&
      cfgTranslations.isNotEmpty &&
      combinedGenres.isNotEmpty;

  AppLifecycleState get appState => _appState;

  set appState(AppLifecycleState value) {
    _appState = value;
    notifyListeners();
  }

  String getImageUrl(
    ImageType imageType,
    ImageQuality imageQuality,
    String imagePath,
  ) {
    return '${imageConfig.secureBaseUrl}'
        '${_getImageSize(imageType, imageQuality)}'
        '$imagePath';
  }

  ImageConfig get imageConfig => apiConfig!.images;

  String _getImageSize(ImageType imageType, ImageQuality imageQuality) {
    List<String> sizes;
    switch (imageType) {
      case ImageType.poster:
        sizes = imageConfig.posterSizes;
        break;
      case ImageType.backdrop:
        sizes = imageConfig.backdropSizes;
        break;
      case ImageType.profile:
        sizes = imageConfig.profileSizes;
        break;
      case ImageType.still:
        sizes = imageConfig.stillSizes;
        break;
      case ImageType.logo:
        sizes = imageConfig.logoSizes;
        break;
    }
    return sizes[max(sizes.length - imageQuality.quality, 0)];
  }

  ConfigurationProvider() : super();

  _fetchConfigurations() async {
    logIfDebug('fetchConfigurations called');
    setPrefApiConfiguration(await api.getApiConfiguration());
    setPrefCountryConfig(await api.getCountryConfiguration());
    setPrefLanguageConfig(await api.getLanguageConfiguration());
    setPrefTranslationConfig(await api.getTranslationConfiguration());
    setPrefCombinedGenres(await getCombinedGenres());
    setPrefConfigStoreDate(DateTime.now());
    notifyListeners();
  }

  checkConfigurations() async {
    if (isNewConfigRequired) {
      logIfDebug('new configurations required');
      _fetchConfigurations();
    } else {
      logIfDebug('new configurations not required');
    }
  }

  Future<List<MediaGenre>> getCombinedGenres() async {
    var movieGenres = await api.getGenres(MediaType.movie.name);
    var tvGenres = await api.getGenres(MediaType.tv.name);
    List<MediaGenre> combinedGenres = movieGenres.genres
            .map((e) =>
                MediaGenre.fromGenre(genre: e, mediaType: MediaType.movie))
            .toList() +
        tvGenres.genres
            .map((e) => MediaGenre.fromGenre(genre: e, mediaType: MediaType.tv))
            .toList();
    return combinedGenres;
  }

  String getGenreName(MediaType mediaType, int id) {
    return combinedGenres
        .singleWhere(
            (element) => element.mediaType == mediaType && element.id == id)
        .name;
  }

  /// Without casting the decoded data to List, we don't get a List<MediaGenre>
  List<MediaGenre> getPrefCombinedGenres() {
    var json = PrefUtil.getValue<String>(Constants.pkCombinedGenres, '');
    return json.isEmpty
        ? []
        : (jsonDecode(json) as List)
            .map((json) => MediaGenre.fromJson(json))
            .toList();
  }

  void setPrefCombinedGenres(List<MediaGenre> genres) {
    PrefUtil.setValue(Constants.pkCombinedGenres, jsonEncode(genres));
  }

  ApiConfiguration? getPrefApiConfiguration() {
    var json = PrefUtil.getValue(Constants.pkApiConfig, '');
    return json.isEmpty
        ? null
        : ApiConfiguration.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  void setPrefApiConfiguration(ApiConfiguration apiConfig) {
    PrefUtil.setValue(Constants.pkApiConfig, jsonEncode(apiConfig.toJson()));
  }

  List<CountryConfig> getPrefCountryConfig() {
    var json = PrefUtil.getValue(Constants.pkCountryConfig, '');
    return json.isEmpty
        ? []
        : (jsonDecode(json) as List)
            .map((e) => CountryConfig.fromJson(e))
            .toList();
  }

  void setPrefCountryConfig(List<CountryConfig> config) {
    PrefUtil.setValue(Constants.pkCountryConfig, jsonEncode(config));
  }

  List<LanguageConfig> getPrefLanguageConfig() {
    var json = PrefUtil.getValue(Constants.pkLanguageConfig, '');
    return json.isEmpty
        ? []
        : (jsonDecode(json) as List)
            .map((e) => LanguageConfig.fromJson(e))
            .toList();
  }

  void setPrefLanguageConfig(List<LanguageConfig> config) {
    PrefUtil.setValue(Constants.pkLanguageConfig, jsonEncode(config));
  }

  List<String> getPrefTranslationConfig() {
    var json = PrefUtil.getValue(Constants.pkTranslationConfig, '');
    return json.isEmpty
        ? []
        : (jsonDecode(json) as List).map((e) => e as String).toList();
  }

  void setPrefTranslationConfig(List<String> config) {
    PrefUtil.setValue(Constants.pkTranslationConfig, jsonEncode(config));
  }

  /// New configurations need to be fetched if no date was stored (new install)
  /// or the last fetch date is more than 30 days old
  bool get isNewConfigRequired {
    var lastDate = getPrefConfigStoreDate();
    return lastDate == null ||
        DateTime.now().difference(lastDate).inDays > interval;
  }

  DateTime? getPrefConfigStoreDate() {
    var dateStr = PrefUtil.getValue<String>(Constants.pkConfigStoreDate, '');
    return DateTime.tryParse(dateStr);
  }

  void setPrefConfigStoreDate(DateTime date) {
    PrefUtil.setValue(Constants.pkConfigStoreDate, date.toString());
  }
}

enum ImageQuality {
  original(1),
  high(2),
  medium(3),
  low(4);

  final int quality;

  const ImageQuality(this.quality);
}

enum ImageType {
  poster,
  backdrop,
  profile,
  still,
  logo,
}

enum ReleaseType {
  premiere(1, 'Premiere'),
  theatricalLimited(2, 'Theatrical (limited)'),
  theatrical(3, 'Theatrical'),
  digital(4, 'Digital'),
  physical(5, 'Physical'),
  tv(6, 'TV');

  final int id;
  final String name;

  const ReleaseType(this.id, this.name);
}

enum TvStatus {
  returningSeries(0, 'Returning Series'),
  planned(1, 'Planned'),
  inProduction(2, 'In Production'),
  ended(3, 'Ended'),
  canceled(4, 'Canceled'),
  pilot(5, 'Pilot');

  final int id;
  final String name;

  const TvStatus(this.id, this.name);
}

enum TvType {
  documentary(0, 'Documentary'),
  news(1, 'News'),
  miniSeries(2, 'Miniseries'),
  reality(3, 'Reality'),
  scripted(4, 'Scripted'),
  talkShow(5, 'Talk Show'),
  video(6, 'Video');

  final int id;
  final String name;

  const TvType(this.id, this.name);
}
