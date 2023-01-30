import 'dart:math';
import 'dart:ui';

import 'package:cinema_scope/architecture/search_view_model.dart';

import '../models/configuration.dart';

class ConfigViewModel extends ApiViewModel {
  AppLifecycleState _appState = AppLifecycleState.detached;

  ApiConfiguration? apiConfig;

  List<CountryConfig>? cfgCountries;

  List<LanguageConfig>? cfgLanguages;

  List<String>? cfgTranslations;

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
    String youtubeKey,
  ) {
    return '${imageConfig.baseUrl}'
        '${_getImageSize(imageType, imageQuality)}'
        '$youtubeKey';
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
    notifyListeners();
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
