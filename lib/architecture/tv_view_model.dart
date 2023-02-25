import 'dart:math';

import 'package:async/async.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/tv.dart';
import 'config_view_model.dart';
import 'movie_view_model.dart';

class TvViewModel extends MediaViewModel<Tv> {
  // Tv? tv;

  String? year;

  // double? get voteAverage => tv?.voteAverage;

  String? certification;

  String? get imdbId => media?.externalIds?.imdbId;

  // String? get homepage => tv?.homepage;

  List<TvCast> get cast => media?.aggregateCredits.cast ?? [];

  List<TvCrew> get crew => media?.aggregateCredits.crew ?? [];

  List<TvCrew>? creators;

  int get totalCastCount => cast.length;

  List<Keyword> get keywords => media?.keywords.results ?? [];

  String? get runtime {
    var runtime = media?.episodeRunTime ?? [];
    return runtime.isEmpty ? null : runtimeToString(runtime.first);
  }

  bool _isTrailerPinned = false;

  bool get isTrailerPinned => _isTrailerPinned;

  List<ImageDetail> thumbnails = <ImageDetail>[];

  // Map<String, ThumbnailType> thumbMap = {};

  set isTrailerPinned(bool value) {
    _isTrailerPinned = value;
    notifyListeners();
  }

  String? _initialVideoId;

  set initialVideoId(String? id) {
    _initialVideoId = id;
    notifyListeners();
  }

  String? get initialVideoId => _initialVideoId;

  getTvWithDetail(int id, List<MediaGenre> allGenres,
      {String? leadActors}) async {
    this.allGenres = allGenres;
    operation = CancelableOperation<Tv>.fromFuture(
      api.getTvWithDetail(id),
    ).then((result) async {
      media = result;
      // year = getYearStringFromDate(media!.firstAirDate);
      await _compileYears();
      await _compileCreators();
      // await _compileCertification();
      notifyListeners();
      _fetchMoreData();
    });
  }

  _compileCreators() async {
    if (media != null && media!.createdBy.isNotEmpty) {
      var creators = <TvCrew>[];
      for (var creator in media!.createdBy) {
        var persons = crew.where((crew) {
          return creator.id == crew.id &&
              crew.department == Department.writing.name;
        });
        if (persons.isNotEmpty) creators.add(persons.first);
      }
      this.creators = creators;
      notifyListeners();
    }
  }

  void _fetchMoreData() async {
    // _fetchMoreByLead();
    _fetchMoreByLeadActor();
    fetchMoreByGenres();
    _fetchMoreByDirector();
    compileThumbnails();
    compileImages();
  }

  _fetchMoreByDirector() async {
    if (media != null) {
      List<TvCrew> crews = [];

      var creators = crew.where((crew) {
        var list = media!.createdBy.where((creator) {
          return crew.id == creator.id &&
              crew.department == Department.writing.name;
        });
        return list.isNotEmpty;
      });

      // var creators = media!.createdBy.map((creator) {
      //   var list = crew.where((crew) =>
      //   crew.id == creator.id && crew.department == Department.writing.name);
      //   if (list.isNotEmpty) return list.first;
      // }).toList()..removeWhere((element) => element == null);
      crews.addAll(creators);

      if (crews.isEmpty) {
        var directors = crew.where((element) {
          var list = element.jobs.where(
                  (job) => job.job == Constants.departMap[Department.directing.name]);
          return list.isNotEmpty;
        });
        crews.addAll(directors);
      }

      if (crews.isNotEmpty) {
        var crew = crews[Random().nextInt(crews.length)];
        fetchMoreByDirector<TvCrew>(crew, crew.department);
      }
    }
  }

  _fetchMoreByLeadActor() async {
    var actors = cast.take(3).toList();
    if (actors.isNotEmpty) {
      var actor = actors[Random().nextInt(actors.length)];
      fetchMoreByLeadActor<TvCast>(actor, actor.order);
    }
  }

  _compileYears() async {
    var years = '';
    var y1 = getYearStringFromDate(media?.firstAirDate);
    var status = media?.status;
    var continued =
        status != TvStatus.canceled.name && status != TvStatus.ended.name;
    if (continued) {
      if (y1.isNotEmpty) years = '$y1-';
    } else {
      var y2 = getYearStringFromDate(media?.lastAirDate);
      if (y1.isNotEmpty && y2.isNotEmpty) years = '$y1-$y2';
    }
    year = years;
  }

// _compileThumbnails() async {
//   logIfDebug('isPinned, compileThumbnails called with tv:$media');
//   if (media != null) {
//     Map<String, ThumbnailType> thumbs = {};
//     for (var key in youtubeKeys) {
//       thumbs[key] = ThumbnailType.video;
//     }
//     for (var imagePath in media!.images.backdrops.take(2)) {
//       thumbs[imagePath.filePath] = ThumbnailType.image;
//     }
//     logIfDebug('isPinned, thumb:$thumbs');
//     if (thumbs.isNotEmpty) thumbMap = thumbs;
//     logIfDebug('isPinned, thumbMap:$thumbMap');
//     notifyListeners();
//   }
// }
//
// _compileImages() async {
//   if (media != null) {
//     var imageResult = media!.images;
//     List<ImageDetail> images = [];
//     images.addAll(imageResult.posters
//         .map((e) => e.copyWith.imageType(ImageType.poster.name)));
//     images.addAll(imageResult.backdrops
//         .map((e) => e.copyWith.imageType(ImageType.backdrop.name)));
//     images.addAll(imageResult.logos
//         .map((e) => e.copyWith.imageType(ImageType.logo.name)));
//     this.images = images;
//     notifyListeners();
//   }
// }
}
