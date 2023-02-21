import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/tv.dart';
import '../utilities/common_functions.dart';
import '../utilities/generic_functions.dart';
import '../utilities/utilities.dart';
import 'filmography_view_model.dart';

class TvCreditsViewModel extends ChangeNotifier
    with GenericFunctions, Utilities, CommonFunctions {
  final AggregateCredits credits;

  TvCreditsViewModel(this.credits);

  // final Map<int, Map<String, List<String>>> _mediaToDeptJobsMap = {};
  //
  // final Map<int, String> _mediaToDeptJobsStringMap = {};

  final Map<String, List<String>> _mediaDeptToJobsMap = {};

  Map<String, FilterState> availableDepartments = {};

  List<BaseTvCredit> _results = [];
  final List<BaseTvCredit> _allResults = [];

  List<BaseTvCredit> get results => _results;

  List<TvCast>? cast;

  List<TvCrew>? crew;

  // List<TvCast> get cast => results.whereType<TvCast>().toList();
  //
  // List<TvCrew> get crew => results.whereType<TvCrew>().toList();

  initialize() async {
    await _processCredits();
    _prepareAllFilters();
  }

  _processCredits() async {
    for (var cast in credits.cast) {
      _mediaDeptToJobsMap.putIfAbsent(
          '${cast.id}${Department.acting.name}', () => []).addAll(
          cast.roles.map((role) {
            var count = role.episodeCount;
            return '${role.character} ($count episode${count > 1 ? 's' : ''})';
          }));
      _allResults.add(cast);
      this.cast == null ? this.cast = [cast] : this.cast!.add(cast);
    }

    for (var crew in credits.crew) {
      _mediaDeptToJobsMap.putIfAbsent(
          '${crew.id}${crew.department}', () => []).addAll(
          crew.jobs.map((job) {
            var count = job.episodeCount;
            return '${job.job} ($count episode${count > 1 ? 's' : ''})';
          }));
      _allResults.add(crew);
      this.crew == null ? this.crew = [crew] : this.crew!.add(crew);
    }
    // _results = _allResults;
    await _prepareAllFilters();
    notifyListeners();
  }

  // _processCombinedCredits() async {
  //   for (var cast in credits.cast) {
  //     _allResults.add(cast);
  //   }
  //   for (var crew in credits.crew) {
  //     var deptJobsMap = _mediaToDeptJobsMap[crew.id];
  //     if (deptJobsMap == null) {
  //       _mediaToDeptJobsMap[crew.id] = {
  //         crew.department: crew.jobs.map((e) => e.job).toList()
  //       };
  //       _allResults.add(crew);
  //     } else {
  //       var jobsList = deptJobsMap[crew.department];
  //       if (jobsList == null) {
  //         deptJobsMap[crew.department] = crew.jobs.map((e) => e.job).toList();
  //       } else {
  //         jobsList.addAll(crew.jobs.map((e) => e.job).toList());
  //         deptJobsMap[crew.department] = jobsList;
  //       }
  //       _mediaToDeptJobsMap[crew.id] = deptJobsMap;
  //     }
  //   }
  //   for (var key in _mediaToDeptJobsMap.keys) {
  //     _mediaToDeptJobsStringMap[key] = _attachDeptWithJobs(key);
  //   }
  //   _results = _allResults;
  //   await _prepareAllFilters();
  //   // await _prepareAvailableFilters(notify: false);
  //   notifyListeners();
  // }

  String getDeptJobString(int id, String dept) {
    return _mediaDeptToJobsMap['$id$dept']?.join(', ') ?? '';
    // return _mediaToDeptJobsStringMap[id] ?? '';
  }

  // String _attachDeptWithJobs(int id) {
  //   var deptJobsMap = _mediaToDeptJobsMap[id];
  //   if (deptJobsMap != null) {
  //     return deptJobsMap.entries
  //         .map((e) {
  //       var jobs = _getJobsStringByDept(e.key, e.value);
  //       return '${departmentToRole(e.key)}${jobs.isEmpty ? '' : ' ($jobs)'}';
  //     })
  //         .toList()
  //         .join(', ');
  //   } else {
  //     return '';
  //   }
  // }

  // String _getJobsStringByDept(String department, List<String> jobs) {
  //   if (jobs.isEmpty) return '';
  //   if (jobs.length == 1 && jobs.first == departmentToRole(department)) {
  //     return '';
  //   } else {
  //     return jobs.join(', ');
  //   }
  // }

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
      crew = List.from(_allResults.whereType<TvCrew>().where((element)
      => element.department == item.key));
      // _results = List.from(_allResults.where((element) =>
      // element is TvCast || (element as TvCrew).department == item.key));
    } else {
      crew = List.from(_allResults.whereType<TvCrew>());
    }

    notifyListeners();
  }
}
