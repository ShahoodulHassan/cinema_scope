import 'package:async/async.dart';
import 'package:cinema_scope/architecture/search_view_model.dart';
import 'package:cinema_scope/models/movie.dart';
import 'package:cinema_scope/utilities/utilities.dart';

import '../constants.dart';
import '../models/person.dart';
import '../models/search.dart';

abstract class MediaViewModel extends ApiViewModel with Utilities {
  List<ImageDetail>? images;

}

class PersonViewModel extends MediaViewModel {
  // Person? person;

  PersonWithKnownFor personWithKnownFor = PersonWithKnownFor();

  Person? get person => personWithKnownFor.person;

  String? jobs;

  List<CombinedResult> get knownFor => personWithKnownFor.knownFor ?? [];

  Map<int, CombinedResult>? _knownForMediaResults;

  Map<int, CombinedResult> get knownForMediaResults =>
      _knownForMediaResults ?? {};

  CancelableOperation? _operation;

  fetchPersonWithDetail(int id, String name, List<CombinedResult>? knownFor) {
    personWithKnownFor.knownFor = knownFor;
    _operation = CancelableOperation<List<dynamic>>.fromFuture(
      Future.wait([
        api.getPersonWithDetail(id),
        if (knownFor == null) api.searchPersons(name),
      ]),
    ).then((values) {
      for (var value in values) {
        if (value is Person) {
          personWithKnownFor.person = value;
        } else if (value is PersonSearchResult) {
          for (var result in value.results) {
            if (result.id == id) {
              personWithKnownFor.knownFor = result.knownFor;
              break;
            }
          }
        }
      }
      notifyListeners();
      _compileImages();
      _compileKnownFor();
      _compilePersonJobs();
    });
  }

  _compileImages() async {
    if (person != null) {
      List<ImageDetail> allImages = [];
      var profileImages = person?.images?.profiles ?? [];
      var taggedImages = person?.taggedImages?.results ?? [];
      allImages.addAll(taggedImages);
      allImages.addAll(profileImages);
      images = allImages;
      notifyListeners();
    }
  }

  _compileKnownFor() async {
    var person = personWithKnownFor.person;
    if (person != null) {
      _knownForMediaResults = {};
      for (var item in knownFor) {
        for (var mediaOfCast in person.combinedCredits.cast) {
          if (item.id == mediaOfCast.id) {
            _knownForMediaResults![item.id] = mediaOfCast;
            break;
          }
        }
        if (!_knownForMediaResults!.containsKey(item.id)) {
          for (var mediaOfCrew in person.combinedCredits.crew) {
            if (item.id == mediaOfCrew.id) {
              _knownForMediaResults![item.id] = mediaOfCrew;
              break;
            }
          }
        }
      }
      var popMap = <int, CombinedResult>{};
      if (person.knownForDepartment == Department.acting.name) {
        for (var mediaOfCast in person.combinedCredits.cast) {
          // logIfDebug('getJob=>id:${mediaOfCast.id}, title:${mediaOfCast.title}, type:${MediaType.mediaOfCast.name}');
          bool isEligible = false;
          if (mediaOfCast.mediaType == MediaType.movie.name) {
            isEligible = !mediaOfCast.character.toLowerCase().contains('voice');
          } else {
            isEligible =
                !mediaOfCast.character.toLowerCase().contains('voice') &&
                    !mediaOfCast.character.toLowerCase().contains('self');
          }
          if (isEligible) popMap.putIfAbsent(mediaOfCast.id, () => mediaOfCast);
        }
      } else {
        for (var mediaOfCrew in person.combinedCredits.crew) {
          if (person.knownForDepartment == mediaOfCrew.department) {
            popMap.putIfAbsent(mediaOfCrew.id, () => mediaOfCrew);
          }
        }
      }

      /// Second sorting is on the basis of cast order, if any
      // var sortedMap = Map.fromEntries(popMap.entries.toList()..sort((e1, e2) {
      //   var value1 = e1.value;
      //   var value2 = e2.value;
      //   if (value1 is CombinedOfCast || value2 is CombinedOfCast) {
      //     /// 11 means that is not in the billed cast
      //     var order1 = value1 is CombinedOfCast ? value1.order ?? 11 : 11;
      //     var order2 = value2 is CombinedOfCast ? value2.order ?? 11 : 11;
      //     return order1.compareTo(order2);
      //   } else {
      //     return 0;
      //   }
      // }));

      /// Sorting is primarily on the basis of vote count and average but if the
      /// media type is TV, we multiply above with the episode count and then
      /// compare, because a popularity of 100 with 1 episode should be
      /// considered as less than a popularity of 40 with 3 episodes.
      /// However, that still doesn't provide results as provided by the
      /// website.
      var sortedMap = Map.fromEntries(popMap.entries.toList()
        ..sort((e1, e2) {
          var value1 = e1.value;
          var value2 = e2.value;
          var currentYear = DateTime.now().year;
          var year1 = (getYearFromDate(value1.mediaReleaseDate)) ?? currentYear;
          var year2 = (getYearFromDate(value2.mediaReleaseDate)) ?? currentYear;
          var yearCount1 = currentYear - year1 + 1;
          var yearCount2 = currentYear - year2 + 1;
          // logIfDebug('id:${value1.id}, year:$year1, years:$yearCount1');
          var pop1 = value1.voteCount * value1.voteAverage /* / yearCount1*/;
          var pop2 = value2.voteCount * value2.voteAverage /* / yearCount2*/;
          var epCount1 = (value1 is CombinedOfCast)
              ? value1.episodeCount ?? 1
              : ((value1 is CombinedOfCrew) ? value1.episodeCount ?? 1 : 1);
          var epCount2 = (value2 is CombinedOfCast)
              ? value2.episodeCount ?? 1
              : ((value2 is CombinedOfCrew) ? value2.episodeCount ?? 1 : 1);
          return ((pop2) * epCount2).compareTo((pop1) * epCount1);
        }));



      for (var media in sortedMap.values) {
        if (_knownForMediaResults!.length < 10) {
          if (!_knownForMediaResults!.containsKey(media.id)) {
            _knownForMediaResults![media.id] = media;
          }
        } else {
          break;
        }
      }

      logIfDebug('knownForMediaResults:$knownForMediaResults');
      if (knownForMediaResults.isNotEmpty) notifyListeners();
    }
  }

  _compilePersonJobs() async {
    var person = personWithKnownFor.person;
    if (person != null) {
      var knownForDept = person.knownForDepartment;
      var actor = Constants.departMap[Department.acting.name]!;
      Set<String> departs = {};
      if (knownForDept.isNotEmpty) {
        departs.add(Constants.departMap[knownForDept] ?? knownForDept);
      }
      if (person.combinedCredits.cast.isNotEmpty && !departs.contains(actor)) {
        departs.add(actor);
      }
      for (var element in person.combinedCredits.crew) {
        departs.add(
          Constants.departMap[element.department] ?? element.department,
        );
      }
      jobs = departs.join(", ");
      logIfDebug('jobs:$jobs');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _operation?.cancel();
    super.dispose();
  }
}
