import 'dart:math';

import 'package:async/async.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../models/tv.dart';
import 'configuration_provider.dart';
import 'movie_provider.dart';

class TvProvider extends MediaProvider<Tv> {

  String? certification;

  String? get imdbId => media?.externalIds?.imdbId;

  List<TvCast> get cast => media?.aggregateCredits.cast ?? [];

  List<TvCrew> get crew => media?.aggregateCredits.crew ?? [];

  List<TvCrew>? creators;

  int get totalCastCount => cast.length;

  String? get runtime {
    var runtime = media?.episodeRunTime ?? [];
    return runtime.isEmpty ? null : runtimeToString(runtime.first);
  }

  bool _isTrailerPinned = false;

  bool get isTrailerPinned => _isTrailerPinned;

  List<ImageDetail> thumbnails = <ImageDetail>[];

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
      logIfDebug('providers:${media?.watchProviders?.results.wpResult}');
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

  @override
  String getMediaTitle() {
    return media!.name;
  }

}
