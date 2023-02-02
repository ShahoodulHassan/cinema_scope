import 'dart:math';
import 'dart:ui';

import 'package:cinema_scope/architecture/search_view_model.dart';
import 'package:cinema_scope/constants.dart';

import '../models/configuration.dart';
import '../models/movie.dart';

class ConfigViewModel extends ApiViewModel {
  AppLifecycleState _appState = AppLifecycleState.detached;

  ApiConfiguration? apiConfig;

  List<CountryConfig>? cfgCountries;

  List<LanguageConfig>? cfgLanguages;

  List<String>? cfgTranslations;

  List<MediaGenre>? combinedGenres;

  bool get isConfigFetched =>
      apiConfig != null &&
      cfgCountries != null &&
      cfgLanguages != null &&
      cfgTranslations != null;

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
    }
    return sizes[max(sizes.length - imageQuality.quality, 0)];
  }

  ConfigViewModel() : super();

  getConfigurations() async {
    apiConfig = await api.getApiConfiguration();
    cfgCountries = await api.getCountryConfiguration();
    cfgLanguages = await api.getLanguageConfiguration();
    cfgTranslations = await api.getTranslationConfiguration();
    combinedGenres = await getAllGenres();
    notifyListeners();
  }

  Future<List<MediaGenre>> getAllGenres() async {
    var movieGenres = await api.getGenres(MediaType.movie.name);
    var tvGenres = await api.getGenres(MediaType.tv.name);
    List<MediaGenre> combinedGenres = movieGenres.genres
        .map((e) => MediaGenre.fromGenre(genre: e, mediaType: MediaType.movie))
        .toList() + tvGenres.genres
        .map((e) => MediaGenre.fromGenre(genre: e, mediaType: MediaType.tv))
        .toList();
    logIfDebug('genres:$combinedGenres');
    return combinedGenres;
  }

  String getGenreName(MediaType mediaType, int id) {
    return combinedGenres!
        .singleWhere(
            (element) => element.mediaType == mediaType && element.id == id)
        .name;
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
  // logo,
}
