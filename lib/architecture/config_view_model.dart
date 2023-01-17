import 'package:cinema_scope/architecture/search_view_model.dart';

import '../models/configuration.dart';

class ConfigViewModel extends ApiViewModel {
  ApiConfiguration? apiConfig;

  List<CountryConfig>? cfgCountries;

  List<LanguageConfig>? cfgLanguages;

  List<String>? cfgTranslations;

  bool get isConfigFetched =>
      apiConfig != null &&
      cfgCountries != null &&
      cfgLanguages != null &&
      cfgTranslations != null;

  ConfigViewModel() : super();

  getConfigurations() async {
    apiConfig = await api.getApiConfiguration();
    cfgCountries = await api.getCountryConfiguration();
    cfgLanguages = await api.getLanguageConfiguration();
    cfgTranslations = await api.getTranslationConfiguration();
    notifyListeners();
  }

}
