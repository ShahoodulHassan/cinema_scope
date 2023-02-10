import 'package:cinema_scope/constants.dart';
import 'package:cinema_scope/models/person.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/widgets.dart';

import '../models/search.dart';

class FilmographyViewModel extends ChangeNotifier
    with Utilities, CommonFunctions {
  late final CombinedCredits combinedCredits;

  List<CombinedResult> _results = [];

  List<CombinedResult> get results => _results;

  Map<int, Map<String, List<String>>> mediaDepartJobsMap = {};

  initialize(CombinedCredits combinedCredits) {
    this.combinedCredits = combinedCredits;

    /// A bit hacky but I don't know of another way of knowing when the first
    /// list is loaded in the build(), so that notifyListeners() is called only
    /// after that.
    Future.delayed(const Duration(milliseconds: 500), () => compileResults());
  }

  compileResults() async {
    List<CombinedResult> newResults = [];
    // newResults.addAll(combinedCredits.cast);
    for (var cast in combinedCredits.cast) {
      var mapList = mediaDepartJobsMap[cast.id];
      if (mapList == null) {
        mediaDepartJobsMap[cast.id] = {
          Department.acting.name: [cast.character]
        };
        newResults.add(cast);
      }
    }
    for (var crew in combinedCredits.crew) {
      var deptMap = mediaDepartJobsMap[crew.id];
      if (deptMap == null) {
        mediaDepartJobsMap[crew.id] = {
          crew.department: [crew.job]
        };
        newResults.add(crew);
      } else {
        var jobsList = deptMap[crew.department];
        if (jobsList == null) {
          deptMap[crew.department] = [crew.job];
          mediaDepartJobsMap[crew.id] = deptMap;
        } else {
          jobsList.add(crew.job);
          deptMap[crew.department] = jobsList;
          mediaDepartJobsMap[crew.id] = deptMap;
        }
      }
    }
    // newResults.addAll(combinedCredits.crew);
    _results = newResults;
    notifyListeners();
  }

  String getRolesWithJobs(int id) {
    var deptMap = mediaDepartJobsMap[id];
    if (deptMap != null) {
      return deptMap.entries
          .map((e) {
            var jobs = getJobs(e.key, e.value);
            return '${departmentToRole(e.key)}${jobs.isEmpty ? '' : ' ($jobs)'}';
          })
          .toList()
          .join(', ');
    } else {
      return '';
    }
  }

  String getJobs(String department, List<String> jobs) {
    if (jobs.isEmpty) return '';
    if (jobs.length == 1 && jobs.first == departmentToRole(department)) {
      return '';
    } else {
      return jobs.join(', ');
    }
  }
}
