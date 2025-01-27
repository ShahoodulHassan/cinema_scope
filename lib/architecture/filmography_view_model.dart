import 'package:cinema_scope/constants.dart';
import 'package:cinema_scope/models/person.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';

import '../models/movie.dart';
import '../models/search.dart';

enum FilterType { department, mediaType, genre }

enum FilterState { unselected, selected, forceSelected }

class FilmographyViewModel extends ChangeNotifier
    with GenericFunctions, Utilities, CommonFunctions {
  late final CombinedCredits combinedCredits;
  late final List<MediaGenre> _combinedGenres;

  List<CombinedResult> _results = [];

  List<CombinedResult> get results => _results;

  final Map<String, Set<int>> _deptToMediaMap = {};

  final Map<int, Map<String, List<String>>> _mediaToDeptJobsMap = {};

  final Map<int, String> _mediaToDeptJobsStringMap = {};

  // final Map<int, String> _mediaToGenreNamesStringMap = {};

  final List<CombinedResult> _allResults = [];

  final Map<String, Set<MediaGenre>> _allGenresMap = {};

  final Set<String> _allDepartments = {};

  final Set<String> _allMediaTypes = {};

  Map<String, FilterState> availableGenreNames = {};
  Map<String, FilterState> availableDepartments = {};
  Map<String, FilterState> availableMediaTypes = {};

  initialize(CombinedCredits combinedCredits, List<MediaGenre> combinedGenres) {
    this.combinedCredits = combinedCredits;
    _combinedGenres = combinedGenres;
    _processCombinedCredits();
  }

  _processCombinedCredits() async {
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
    // for (var result in _allResults) {
    //   _mediaToGenreNamesStringMap[result.id] = getGenreNamesFromIds(
    //     result.genreIds,
    //     result.mediaType == MediaType.tv.name ? MediaType.tv : MediaType.movie,
    //   );
    // }
    _results = _allResults.map((result) {
      result.deptJobsString = getDeptJobString(result.id);
      result.genreNamesString = getGenreNamesFromIds(
        _combinedGenres,
        result.genreIds,
        result.mediaType == MediaType.tv.name ? MediaType.tv : MediaType.movie,
      );
      return result;
    }).toList();
    await _prepareAllFilters();
    await _prepareAvailableFilters(notify: false);
    notifyListeners();
  }

  _prepareAvailableFilters({
    bool notify = true,
    Tuple2<FilterType, MapEntry<String, FilterState>>? oldFilter,
  }) async {
    if (_results.isNotEmpty) {
      var depts = <String, FilterState>{};
      var types = <String, FilterState>{};
      var genres = <String, FilterState>{};
      for (var result in _results) {
        for (var genreId in result.genreIds) {
          logIfDebug(
              'id:${result.id}, title:${result.mediaTitle}, mediaType:${result.mediaType}, checking genreId:$genreId');
          // var mediaGenre = combinedGenres.singleWhere((element) =>
          //     element.mediaType.name == result.mediaType &&
          //     element.id == genreId);
          MediaGenre? mediaGenre;
          for (var genre in _combinedGenres) {
            var matched =
                genre.mediaType.name == result.mediaType && genre.id == genreId;
            if (matched) {
              mediaGenre = genre;
            }
          }
          if (mediaGenre != null) {
            genres[mediaGenre.name] =
                availableGenreNames[mediaGenre.name] ?? FilterState.unselected;
          }
        }

        if (result.mediaType != null) {
          types[result.mediaType!] =
              availableMediaTypes[result.mediaType] ?? FilterState.unselected;
        }

        var deptMap = _mediaToDeptJobsMap[result.id];
        if (deptMap != null) {
          for (var dept in deptMap.keys) {
            depts[dept] = availableDepartments[dept] ?? FilterState.unselected;
          }
        }
      }

      logIfDebug('_prepareAvailableFilters=>oldItem:$oldFilter, types:$types');

      if (depts.length == 1) {
        var key = depts.entries.first.key;
        if (oldFilter != null &&
            oldFilter.item1 == FilterType.department &&
            oldFilter.item2.key == key &&
            oldFilter.item2.value == FilterState.selected) {
          /// If the filter whose state is being changed is the only filter in the
          /// list and its old state was selected (which may mean, it is now being
          /// unselected), we keep it at its old value, i.e., selected.
          depts[key] = FilterState.selected;
        } else {
          /// If there is only one entry in a map and it's unselected, we set
          /// it to forceSelected in order to show it as selected.
          /// This force selection is reset to unselected in [filterResults]
          if (depts[key] == FilterState.unselected) {
            depts[key] = FilterState.forceSelected;
          }
        }
      }
      if (types.length == 1) {
        var key = types.entries.first.key;
        if (oldFilter != null &&
            oldFilter.item1 == FilterType.mediaType &&
            oldFilter.item2.key == key &&
            oldFilter.item2.value == FilterState.selected) {
          /// Same comments as in above block
          types[key] = FilterState.selected;
        } else {
          /// Same comments as in above block
          if (types[key] == FilterState.unselected) {
            types[key] = FilterState.forceSelected;
          }
        }
        logIfDebug(
            '_prepareAvailableFilters=>oldItem:$oldFilter, types:$types');
      }
      if (genres.length == 1) {
        var key = genres.entries.first.key;
        if (oldFilter != null &&
            oldFilter.item1 == FilterType.genre &&
            oldFilter.item2.key == key &&
            oldFilter.item2.value == FilterState.selected) {
          /// Same comments as in above block
          genres[key] = FilterState.selected;
        } else {
          /// Same comments as in above block
          if (genres[key] == FilterState.unselected) {
            genres[key] = FilterState.forceSelected;
          }
        }
      } else if (genres.length > 1) {
        /// Genres are sorted alphabetically
        genres = Map<String, FilterState>.fromEntries(genres.entries.toList()
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
      // logIfDebug('title:${credit.mediaTitle}, mediaType:${credit.mediaType}');
      for (var genreId in credit.genreIds) {
        logIfDebug(
            'id:${credit.id}, title:${credit.mediaTitle}, mediaType:${credit.mediaType}, checking genreId:$genreId');
        // var mediaGenre = combinedGenres.singleWhere((element) {
        //   var matched = element.mediaType.name == credit.mediaType &&
        //     element.id == genreId;
        //   // if (matched) {
        //   //   logIfDebug('mediaType:${element.mediaType}, '
        //   //       'genreId:$genreId vs id:${element.id}');
        //   // }
        //   return matched;
        // });
        MediaGenre? mediaGenre;
        for (var genre in _combinedGenres) {
          var matched =
              genre.mediaType.name == credit.mediaType && genre.id == genreId;
          if (matched) {
            logIfDebug('mediaType:${genre.mediaType}, '
                'genreId:$genreId vs id:${genre.id}');
            mediaGenre = genre;
          }
        }
        if (mediaGenre != null) {
          _allGenresMap.putIfAbsent(mediaGenre.name, () => {}).add(mediaGenre);
        }
      }

      if (credit.mediaType != null) _allMediaTypes.add(credit.mediaType!);
    }

    logIfDebug('_prepareAllFilters=>depts:$_allDepartments'
        'types:$_allMediaTypes'
        'allGenres:$_allGenresMap');
  }

  toggleDepartments(MapEntry<String, FilterState> item, bool isSelected) async {
    availableDepartments = Map<String, FilterState>.from(availableDepartments)
      ..[item.key] = isSelected ? FilterState.selected : FilterState.unselected;
    filterResults(Tuple2<FilterType, MapEntry<String, FilterState>>(
        FilterType.department, item));
  }

  toggleMediaTypes(MapEntry<String, FilterState> item, bool isSelected) async {
    availableMediaTypes = Map<String, FilterState>.from(availableMediaTypes)
      ..[item.key] = isSelected ? FilterState.selected : FilterState.unselected;
    filterResults(Tuple2<FilterType, MapEntry<String, FilterState>>(
        FilterType.mediaType, item));
  }

  toggleGenres(MapEntry<String, FilterState> item, bool isSelected) async {
    availableGenreNames = Map<String, FilterState>.from(availableGenreNames)
      ..[item.key] = isSelected ? FilterState.selected : FilterState.unselected;
    filterResults(Tuple2<FilterType, MapEntry<String, FilterState>>(
        FilterType.genre, item));
  }

  filterResults(
      Tuple2<FilterType, MapEntry<String, FilterState>> oldFilter) async {
    /// Here, we reset the value to unselected if it was forceSelected
    /// earlier.
    if (availableDepartments.length == 1) {
      var key = availableDepartments.entries.first.key;
      var value = availableDepartments[key];
      if (value == FilterState.forceSelected) {
        availableDepartments[key] = FilterState.unselected;
      }
    }
    if (availableMediaTypes.length == 1) {
      var key = availableMediaTypes.entries.first.key;
      var value = availableMediaTypes[key];
      if (value == FilterState.forceSelected) {
        availableMediaTypes[key] = FilterState.unselected;
      }
    }
    if (availableGenreNames.length == 1) {
      var key = availableGenreNames.entries.first.key;
      var value = availableGenreNames[key];
      if (value == FilterState.forceSelected) {
        availableGenreNames[key] = FilterState.unselected;
      }
    }

    logIfDebug('filterResults=>Available:$availableDepartments');

    var selectedDepts = availableDepartments.entries
        .where((element) => element.value != FilterState.unselected)
        .toList()
        .map((e) => e.key);
    var selectedTypes = availableMediaTypes.entries
        .where((element) => element.value != FilterState.unselected)
        .toList()
        .map((e) => e.key);
    var selectedGenreNames = availableGenreNames.entries
        .where((element) => element.value != FilterState.unselected)
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

    _prepareAvailableFilters(oldFilter: oldFilter);

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
