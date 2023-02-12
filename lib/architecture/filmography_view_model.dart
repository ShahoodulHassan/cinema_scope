import 'package:cinema_scope/constants.dart';
import 'package:cinema_scope/models/person.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/widgets.dart';

import '../models/movie.dart';
import '../models/search.dart';

class FilmographyViewModel extends ChangeNotifier
    with GenericFunctions, Utilities, CommonFunctions {
  late final CombinedCredits combinedCredits;
  late final List<MediaGenre> combinedGenres;

  List<CombinedResult> _results = [];

  List<CombinedResult> get results => _results;

  final Map<String, Set<int>> _deptToMediaMap = {};

  final Map<int, Map<String, List<String>>> _mediaToDeptJobsMap = {};

  final Map<int, String> _mediaToDeptJobsStringMap = {};

  final List<CombinedResult> _allResults = [];

  final Map<String, Set<MediaGenre>> _allGenresMap = {};

  final Set<String> _allDepartments = {};

  final Set<String> _allMediaTypes = {};

  /// A nullable bool provides the luxury to assign up to three values,
  /// true / false / null to a key.
  /// We assume a key as selected if the value is true or null, where null means
  /// that the selection was by force, not by tapping on the filter chip.
  /// Selection by force is required when there is only one entry in the map
  /// and the value of the key is false.
  Map<String, bool?> availableGenreNames = {};
  Map<String, bool?> availableDepartments = {};
  Map<String, bool?> availableMediaTypes = {};

  initialize(CombinedCredits combinedCredits, List<MediaGenre> combinedGenres) {
    this.combinedCredits = combinedCredits;
    this.combinedGenres = combinedGenres;
    _processCombinedCredits();
  }

  _processCombinedCredits() async {
    // List<CombinedResult> newResults = [];
    for (var cast in combinedCredits.cast) {
      var deptMap = _mediaToDeptJobsMap[cast.id];
      if (deptMap == null) {
        _mediaToDeptJobsMap[cast.id] = {
          Department.acting.name: [cast.character]
        };
        _allResults.add(cast);
      }
      _deptToMediaMap
          .putIfAbsent(Department.acting.name, () => {})
          .add(cast.id);
    }
    for (var crew in combinedCredits.crew) {
      var deptMap = _mediaToDeptJobsMap[crew.id];
      if (deptMap == null) {
        _mediaToDeptJobsMap[crew.id] = {
          crew.department: [crew.job]
        };
        _allResults.add(crew);
      } else {
        var jobsList = deptMap[crew.department];
        if (jobsList == null) {
          deptMap[crew.department] = [crew.job];
          _mediaToDeptJobsMap[crew.id] = deptMap;
        } else {
          jobsList.add(crew.job);
          deptMap[crew.department] = jobsList;
          _mediaToDeptJobsMap[crew.id] = deptMap;
        }
      }
      _deptToMediaMap.putIfAbsent(crew.department, () => {}).add(crew.id);
    }
    for (var key in _mediaToDeptJobsMap.keys) {
      _mediaToDeptJobsStringMap[key] = _attachDeptWithJobs(key);
    }
    _results = _allResults;
    await _prepareAllFilters();
    await _prepareAvailableFilters(notify: false);
    notifyListeners();
  }

  _prepareAvailableFilters({bool notify = true}) async {
    if (_results.isNotEmpty) {
      var depts = <String, bool?>{};
      var types = <String, bool?>{};
      var genres = <String, bool?>{};
      for (var result in _results) {
        for (var genreId in result.genreIds) {
          var mediaGenre = combinedGenres.singleWhere((element) =>
              element.mediaType.name == result.mediaType &&
              element.id == genreId);
          genres[mediaGenre.name] =
              availableGenreNames[mediaGenre.name] ?? false;
        }

        if (result.mediaType != null) {
          types[result.mediaType!] =
              availableMediaTypes[result.mediaType] ?? false;
        }

        var deptMap = _mediaToDeptJobsMap[result.id];
        if (deptMap != null) {
          for (var dept in deptMap.keys) {
            depts[dept] = availableDepartments[dept] ?? false;
          }
        }

      }

      /// If there is only one entry in a map and its value is false, we set
      /// the value to null in order to set it as selected. This is called
      /// [force selection] and is the exact reason why a nullable bool was
      /// used in the map.
      /// This force selection is reset to false in [filterResults]
      if (depts.length == 1) {
        var key = depts.entries.first.key;
        if (depts[key] == false) depts[key] = null;
      }
      if (types.length == 1) {
        var key = types.entries.first.key;
        if (types[key] == false) types[key] = null;
      }
      if (genres.length == 1) {
        var key = genres.entries.first.key;
        if (genres[key] == false) genres[key] = null;
      } else if (genres.length > 1) {
        /// Genres are sorted alphabetically
        genres = Map<String, bool?>.fromEntries(genres.entries.toList()
          ..sort((e1, e2) => e1.key.compareTo(e2.key)));
      }

      availableDepartments = depts;
      availableMediaTypes = types;
      availableGenreNames = genres;
      logIfDebug('_prepareAvailableFilters=>depts:$availableDepartments'
          'types:$availableMediaTypes'
          'allGenres:$_allGenresMap'
          'genreNames:$availableGenreNames');
      if (notify) notifyListeners();
    }
  }

  _prepareAllFilters() async {
    if (combinedCredits.cast.isNotEmpty) {
      _allDepartments.add(Department.acting.name);
    }
    for (var crew in combinedCredits.crew) {
      _allDepartments.add(crew.department);
    }

    for (var credit in _allResults) {
      for (var genreId in credit.genreIds) {
        var mediaGenre = combinedGenres.singleWhere((element) =>
            element.mediaType.name == credit.mediaType &&
            element.id == genreId);
        _allGenresMap.putIfAbsent(mediaGenre.name, () => {}).add(mediaGenre);
      }

      if (credit.mediaType != null) _allMediaTypes.add(credit.mediaType!);
    }

    logIfDebug('_prepareAllFilters=>depts:$_allDepartments'
        'types:$_allMediaTypes'
        'allGenres:$_allGenresMap');

  }

  toggleDepartments(String name, bool isSelected) async {
    availableDepartments = Map<String, bool?>.from(availableDepartments)
      ..[name] = isSelected;
    filterResults();
  }

  toggleMediaTypes(String name, bool selected) async {
    availableMediaTypes = Map<String, bool?>.from(availableMediaTypes)
      ..[name] = selected;
    filterResults();
  }

  toggleGenres(String name, bool selected) async {
    availableGenreNames = Map<String, bool?>.from(availableGenreNames)
      ..[name] = selected;
    filterResults();
  }

  filterResults() async {
    /// Here, we reset the value to false if it was force selected (set to null)
    /// earlier.
    if (availableDepartments.length == 1) {
      var key = availableDepartments.entries.first.key;
      var value = availableDepartments[key];
      if (value == null) availableDepartments[key] = false;
    }
    if (availableMediaTypes.length == 1) {
      var key = availableMediaTypes.entries.first.key;
      var value = availableMediaTypes[key];
      if (value == null) availableMediaTypes[key] = false;
    }
    if (availableGenreNames.length == 1) {
      var key = availableGenreNames.entries.first.key;
      var value = availableGenreNames[key];
      if (value == null) availableGenreNames[key] = false;
    }

    logIfDebug('filterResults=>Available:$availableDepartments');

    var selectedDepts = availableDepartments.entries
        .where((element) => element.value == null || element.value!)
        .toList()
        .map((e) => e.key);
    var selectedTypes = availableMediaTypes.entries
        .where((element) => element.value == null || element.value!)
        .toList()
        .map((e) => e.key);
    var selectedGenreNames = availableGenreNames.entries
        .where((element) => element.value == null || element.value!)
        .toList()
        .map((e) => e.key);
    logIfDebug('filterResults=>Selected:$selectedDepts');
    var selectedMediaGenres = <MediaGenre>{};
    for (var entry in _allGenresMap.entries) {
      if (selectedGenreNames.contains(entry.key)) {
        selectedMediaGenres.addAll(entry.value);
      }
    }
    var selectedGenreIds = <int>{};
    var selectedMovieGenreIds = <int>{};
    var selectedTvGenreIds = <int>{};
    for (var genre in selectedMediaGenres) {
      selectedGenreIds.add(genre.id);
      if (genre.mediaType == MediaType.movie) {
        selectedMovieGenreIds.add(genre.id);
      } else {
        selectedTvGenreIds.add(genre.id);
      }
    }

    if (selectedDepts.isEmpty &&
        selectedTypes.isEmpty &&
        selectedGenreNames.isEmpty) {
      _results = [..._allResults];
    } else {
      var filtered = _allResults.where((element) {
        // var dept = element is CombinedOfCrew
        //     ? element.department
        //     : Department.acting.name;

        var mediaDepts = _mediaToDeptJobsMap[element.id]?.keys;
        // var hasDept = mediaDepts?.any((element) => selectedDepts.contains(element)) ?? false;
        var hasDept = mediaDepts?.toSet().containsAll(selectedDepts) ?? false;

        var hasGenres = selectedGenreIds.isNotEmpty &&
            element.genreIds.toSet().containsAll(selectedGenreIds);

        // var hasGenres = false;
        // if (element.mediaType == MediaType.movie.name) {
        //   hasGenres = selectedMovieGenreIds.isNotEmpty &&
        //       element.genreIds.toSet().containsAll(selectedMovieGenreIds);
        // } else {
        //   hasGenres = selectedTvGenreIds.isNotEmpty &&
        //       element.genreIds.toSet().containsAll(selectedTvGenreIds);
        // }

        // selectedMediaGenres.where((mediaGenre) => element.mediaType == mediaGenre.mediaType.name && )
        return (selectedDepts.isEmpty || hasDept) &&
            (selectedTypes.isEmpty ||
                selectedTypes.contains(element.mediaType)) &&
            (selectedGenreNames.isEmpty || hasGenres);
      });
      _results = [...filtered];
    }

    _prepareAvailableFilters();

    // if (selectedDepts.isEmpty) {
    //   _results = [..._allResults];
    // } else {
    //   var filtered = _allResults.where((element) {
    //     var dept = element is CombinedOfCrew
    //         ? element.department
    //         : Department.acting.name;
    //     return selectedDepts.contains(dept);
    //   });
    //   _results = [...filtered];
    // }
    notifyListeners();
  }

  String getDeptJobString(int id) => _mediaToDeptJobsStringMap[id] ?? '';

  String _attachDeptWithJobs(int id) {
    var deptMap = _mediaToDeptJobsMap[id];
    if (deptMap != null) {
      return deptMap.entries
          .map((e) {
            var jobs = _getJobsStringByDept(e.key, e.value);
            return '${departmentToRole(e.key)}${jobs.isEmpty ? '' : ' ($jobs)'}';
          })
          .toList()
          .join(', ');
    } else {
      return '';
    }
  }

  String _getJobsStringByDept(String department, List<String> jobs) {
    if (jobs.isEmpty) return '';
    if (jobs.length == 1 && jobs.first == departmentToRole(department)) {
      return '';
    } else {
      return jobs.join(', ');
    }
  }
}
