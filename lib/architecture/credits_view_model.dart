import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../utilities/common_functions.dart';
import '../utilities/generic_functions.dart';
import '../utilities/utilities.dart';
import 'filmography_view_model.dart';

class CreditsViewModel extends ChangeNotifier
    with GenericFunctions, Utilities, CommonFunctions {
  final Credits credits;

  CreditsViewModel(this.credits);

  final Map<int, Map<String, List<String>>> _mediaToDeptJobsMap = {};

  final Map<int, String> _mediaToDeptJobsStringMap = {};

  Map<String, FilterState> availableDepartments = {};

  List<BaseCredit> _results = [];
  final List<BaseCredit> _allResults = [];

  List<BaseCredit> get results => _results;

  List<Cast> get cast => results.whereType<Cast>().toList();

  List<Crew> get crew => results.whereType<Crew>().toList();

  initialize() async {
    await _processCombinedCredits();
    _prepareAllFilters();
  }

  _processCombinedCredits() async {
    for (var cast in credits.cast) {
      // var deptMap = _mediaToDeptJobsMap[cast.id];
      // if (deptMap == null) {
      //   _mediaToDeptJobsMap[cast.id] = {
      //     Department.acting.name: [cast.character]
      //   };
      _allResults.add(cast);
      // }
      // _deptToMediaMap
      //     .putIfAbsent(Department.acting.name, () => {})
      //     .add(cast.id);
    }
    for (var crew in credits.crew) {
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
      // _deptToMediaMap.putIfAbsent(crew.department, () => {}).add(crew.id);
    }
    for (var key in _mediaToDeptJobsMap.keys) {
      _mediaToDeptJobsStringMap[key] = _attachDeptWithJobs(key);
    }
    _results = _allResults;
    await _prepareAllFilters();
    // await _prepareAvailableFilters(notify: false);
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

  _prepareAllFilters() async {
    var depts = credits.crew.map((e) => e.department).toSet();
    Set<String> sorted = {};
    if (depts.contains(Department.directing.name)) {
      sorted.add(Department.directing.name);
    }
    if (depts.contains(Department.writing.name)) {
      sorted.add(Department.writing.name);
    }
    if (depts.contains(Department.production.name)) {
      sorted.add(Department.production.name);
    }
    sorted.addAll(depts.where((element) => !sorted.contains(element)).toList()
      ..sort((a, b) => a.compareTo(b)));

    for (var crew in sorted) {
      availableDepartments[crew] = FilterState.unselected;
    }
  }

  toggleDepartments(MapEntry<String, FilterState> item, bool isSelected) {
    availableDepartments =
        Map<String, FilterState>.from(availableDepartments).map(
      (key, value) {
        if (item.key == key) {
          return MapEntry<String, FilterState>(key,
              (isSelected ? FilterState.selected : FilterState.unselected));
        }
        return MapEntry<String, FilterState>(key, FilterState.unselected);
      },
    );
    _filterResults(item, isSelected);
  }

  _filterResults(MapEntry<String, FilterState> item, bool isSelected) async {
    if (isSelected) {
      _results = List.from(_allResults.where((element) =>
          element is Cast ||
          (_mediaToDeptJobsMap[element.id]?.keys.contains(item.key) ?? false)));
    } else {
      _results = List.from(_allResults);
    }

    notifyListeners();
  }
}
