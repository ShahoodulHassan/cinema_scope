import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinema_scope/architecture/movie_view_model.dart';
import 'package:cinema_scope/models/configuration.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/models/similar_titles_params.dart';
import 'package:cinema_scope/pages/credits_page.dart';
import 'package:cinema_scope/pages/image_page.dart';
import 'package:cinema_scope/pages/media_details_page.dart';
import 'package:cinema_scope/pages/person_page.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/home_section.dart';
import 'package:cinema_scope/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../architecture/config_view_model.dart';
import '../architecture/tv_view_model.dart';
import '../constants.dart';
import '../main.dart';
import '../models/movie.dart';
import '../widgets/base_section_sliver.dart';
import '../widgets/compact_text_button.dart';
import '../widgets/expandable_synopsis.dart';
import '../widgets/frosted_app_bar.dart';
import '../widgets/ink_well_overlay.dart';
import '../widgets/recommendations_section.dart';
import '../widgets/trailer_view.dart';

class MoviePage extends MultiProvider {
  MoviePage({
    super.key,
    required int id,
    required String title,
    required String? year,
    required double voteAverage,
    required String? overview,
    required String? sourceUrl,
    required String? destUrl,
    required String? backdrop,
    required String heroImageTag,
  }) : super(
            providers: [
              ChangeNotifierProvider(create: (_) => MovieViewModel()),
              // ChangeNotifierProvider(create: (_) => YoutubeViewModel()),
            ],
            child: _MoviePageChild(
              id,
              title,
              year,
              voteAverage,
              overview,
              sourceUrl,
              destUrl,
              backdrop,
              heroImageTag,
            ));
}

class _MoviePageChild extends StatefulWidget {
  final int id;

  final String title, heroImageTag;
  final String? year, overview, sourceUrl, destUrl, backdrop;
  final double voteAverage;

  const _MoviePageChild(
    this.id,
    this.title,
    this.year,
    this.voteAverage,
    this.overview,
    this.sourceUrl,
    this.destUrl,
    this.backdrop,
    this.heroImageTag, {
    Key? key,
  }) : super(key: key);

  @override
  State<_MoviePageChild> createState() => _MoviePageChildState();
}

class _MoviePageChildState extends State<_MoviePageChild>
    with GenericFunctions, Utilities, CommonFunctions {
  late final String? sourceUrl = widget.sourceUrl;
  late final String? destUrl = widget.destUrl;
  late final String heroImageTag = widget.heroImageTag;
  late final backdrop = widget.backdrop;

  final animDuration = const Duration(milliseconds: 250);

  late String backdropBaseUrl;

  TrailerDelegate? trailerDelegate;

  late final MovieViewModel mvm;

  @override
  void initState() {
    super.initState();
    mvm = context.read<MovieViewModel>()
      ..getMovieWithDetail(
        widget.id,
        context.read<ConfigViewModel>().combinedGenres,
      );
    final cvm = context.read<ConfigViewModel>();
    String base = cvm.apiConfig!.images.secureBaseUrl;
    String size = cvm.apiConfig!.images.backdropSizes[1];
    backdropBaseUrl = '$base$size';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: CustomScrollView(
        slivers: [
          SliverFrostedAppBar(
            title: Text(widget.title),
            pinned: true,
          ),
          MultiSliver(children: [
            Selector<MovieViewModel,
                Tuple3<List<String>, Map<String, ThumbnailType>, String?>>(
              builder: (_, tuple, __) {
                logIfDebug('isPinned, thumbnails:$tuple');
                var height = MediaQuery.sizeOf(context).width * 9 / 16;
                if (tuple.item3 != null && tuple.item1.isNotEmpty) {
                  return SliverPersistentHeader(
                    delegate: TrailerDelegate(
                      mediaType: MediaType.movie,
                      extent: height,
                      initialVideoId: tuple.item3!,
                      youtubeKeys: tuple.item1,
                    ),
                    pinned: true,
                  );
                } else {
                  return SliverPersistentHeader(
                    delegate: ImageDelegate(
                      // backdropBaseUrl,
                      mediaType: MediaType.movie,
                      extent: tuple.item2.isEmpty ? 0 : height,
                      thumbMap: tuple.item2,
                    ),
                    pinned: false,
                  );
                }
              },
              selector: (_, mvm) {
                logIfDebug('isPinned, selector called with:${mvm.youtubeKeys}');
                return Tuple3<List<String>, Map<String, ThumbnailType>,
                    String?>(
                  mvm.youtubeKeys,
                  mvm.thumbMap,
                  mvm.initialVideoId,
                );
              },
            ),
            Selector<MovieViewModel, String?>(
              selector: (_, tvm) => tvm.initialVideoId,
              builder: (_, id, __) {
                if (id != null && id.isNotEmpty) {
                  return SliverPinnedHeader(
                    child: StreamersView<Movie, MovieViewModel>(id: widget.id),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: StreamersView<Movie, MovieViewModel>(id: widget.id),
                  );
                }
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.start,
                        // maxLines: 2,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                    ),
                    buildYearRow(context),
                    // buildExternalLinks(),
                    buildTagline(),
                    ExpandableSynopsis(
                      widget.overview,
                      changeSize: false,
                    ),
                    buildGenresAndLinks(),
                  ],
                ),
              ),
            ),
            const _CastCrewSection(),
            const ImagesSection<MovieViewModel>(),
            const _MediaInfoSection(),
            const RecommendationsSection<Movie, MovieViewModel>(),
            const ReviewsSection(),
            const MoreByDirectorSection<Movie, MovieViewModel>(),
            const MoreByLeadActorSection<Movie, MovieViewModel>(),
            const MoreByGenresSection<Movie, MovieViewModel>(),
            const KeywordsSection<Movie, MovieViewModel>(),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ]),
        ],
      ),
    );
  }

  Widget buildExternalLinks() {
    return Selector<MovieViewModel, Tuple2<String?, String?>>(
      selector: (_, mvm) => Tuple2(mvm.imdbId, mvm.homepage),
      builder: (_, data, __) {
        final imdbId = data.item1;
        final homepage = data.item2;
        return (imdbId.isNotNullNorEmpty || homepage.isNotNullNorEmpty)
            ? Container(
                color: Colors.yellow,
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (imdbId.isNotNullNorEmpty)
                      getIconButton(
                        const Icon(FontAwesomeIcons.imdb),
                        () => openUrlString(
                          '${Constants.imdbTitleUrl}$imdbId',
                        ),
                        color: kPrimary,
                        // iconSize: 20.0,
                      ),
                    if (homepage.isNotNullNorEmpty)
                      getIconButton(
                        (homepage!.contains('netflix')
                            ? Image.asset(
                                'assets/icons/icons8_netflix_24.png',
                                color: kPrimary,
                              )
                            : const Icon(Icons.link)),
                        () => openUrlString(homepage),
                        color: kPrimary,
                        // iconSize: 20.0,
                      ),
                  ],
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget buildYearRow(BuildContext context) {
    return AnimatedSize(
      duration: animDuration,
      child:
          Selector<MovieViewModel, Tuple4<String?, double?, String?, String?>>(
        builder: (_, tuple, __) {
          var year = tuple.item1 ?? '';
          var voteAverage = tuple.item2 ?? 0.0;
          var runtime = tuple.item3 ?? '';
          var certification = tuple.item4 ?? '';
          if (year.isEmpty &&
              voteAverage == 0.0 &&
              runtime.isEmpty &&
              certification.isEmpty) {
            return const SizedBox.shrink();
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Row(
                children: [
                  if (year.isNotEmpty) buildYear(year),
                  if (voteAverage > 0.0) buildRating(voteAverage),
                  if (runtime.isNotEmpty) buildRuntime(runtime),
                  if (certification.isNotEmpty)
                    buildCertification(context, certification),
                ],
              ),
            );
          }
        },
        selector: (_, mvm) => Tuple4<String?, double?, String?, String?>(
          mvm.year,
          mvm.voteAverage,
          mvm.runtime,
          mvm.certification,
        ),
      ),
    );
  }

  Padding buildYear(String year) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Text(
        year,
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }

  Padding buildRating(double voteAverage) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          Icon(
            Icons.star_sharp,
            size: 22.0,
            color: Constants.ratingIconColor,
          ),
          Text(
            ' ${applyCommaAndRound(voteAverage, 1, false, true)}'
            // '   (${applyCommaAndRoundNoZeroes(movie.voteCount * 1.0, 0, true)})'
            '',
            style: const TextStyle(
              // fontWeight: FontWeight.normal,
              fontSize: 16.0,
              // height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Padding buildRuntime(String runtime) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Text(
        runtime,
        style: const TextStyle(
          fontSize: 16.0,
          // fontWeight: FontWeight.bold,
          // fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Padding buildCertification(BuildContext context, String certification) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 0.8,
        ),
        child: Text(
          certification,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            // fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  AnimatedSize buildTagline() {
    return AnimatedSize(
      duration: animDuration,
      child: Selector<MovieViewModel, String?>(
        builder: (_, tagline, __) {
          return tagline == null || tagline.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Text(
                    '"$tagline"',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.literata(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        // fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                );
        },
        selector: (_, mvm) => mvm.tagline,
      ),
    );
  }

  AnimatedSize buildGenresAndLinks() {
    return AnimatedSize(
      duration: animDuration,
      child: Selector<MovieViewModel, Tuple3<String?, String?, List<Genre>?>>(
        selector: (_, mvm) => Tuple3<String?, String?, List<Genre>>(
          mvm.imdbId,
          mvm.homepage,
          mvm.genres,
        ),
        builder: (_, tuple, __) {
          logIfDebug('builder called with movie:$tuple');
          var imdbId = tuple.item1 ?? '';
          var homepage = tuple.item2 ?? '';
          var genres = tuple.item3 ?? [];
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (genres.isNotEmpty) getGenreView<Movie>(genres),
              if (imdbId.isNotEmpty || homepage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (imdbId.isNotEmpty)
                        getIconButton(
                          const Icon(FontAwesomeIcons.imdb),
                          () => openUrlString(
                            '${Constants.imdbTitleUrl}$imdbId',
                          ),
                          color: kPrimary,
                        ),
                      if (homepage.isNotEmpty)
                        getIconButton(
                          (homepage.contains('netflix')
                              ? Image.asset(
                                  'assets/icons/icons8_netflix_24.png',
                                  color: kPrimary,
                                )
                              : const Icon(Icons.link)),
                          () => openUrlString(homepage),
                          color: kPrimary,
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

// /// This method expects a non-empty list of genres
// Widget getGenreView(List<Genre> genres) {
//   // final genres = movie.genres;
//   return Padding(
//     padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//     child: SizedBox(
//       height: 34,
//       child: ListView.separated(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         separatorBuilder: (_, index) => const SizedBox(width: 8),
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (BuildContext context, int index) {
//           final genre = genres[index];
//           return InkWellOverlay(
//             onTap: () {
//               goToMediaListPage(
//                 context,
//                 mediaType: MediaType.movie,
//                 genres: [genre],
//               );
//             },
//             borderRadius: BorderRadius.circular(6.0),
//             child: Chip(
//               backgroundColor:
//                   Theme.of(context).primaryColorLight.withOpacity(0.17),
//               padding: EdgeInsets.zero,
//               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               label: Text(
//                 genre.name,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Theme.of(context).primaryColorDark,
//                 ),
//               ),
//               side: BorderSide(
//                 color: Theme.of(context).primaryColorDark,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(6.0),
//               ),
//             ),
//           );
//         },
//         itemCount: genres.length,
//       ),
//     ),
//   );
// }
}

class MoreByLeadActorSection<M extends Media, T extends MediaViewModel<M>>
    extends StatelessWidget with GenericFunctions, Utilities, CommonFunctions {
  final int _maxCount = 20;

  const MoreByLeadActorSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<T, Tuple2<BasePersonResult, List<CombinedResult>>?>(
      selector: (_, mvm) => mvm.moreByActor,
      builder: (_, moreByActor, __) {
        // logIfDebug('moreByActor:$moreByActor');
        if (moreByActor == null) {
          return SliverToBoxAdapter(child: Container());
        }
        return BaseSectionSliver(
          title: 'More by ${moreByActor.item1.name}',
          children: [
            MediaPosterListView(
              items: moreByActor.item2.take(_maxCount).toList(),
              posterWidth: 140.0,
              radius: 4.0,
            ),
          ],
        );
      },
    );
  }

// goToFilmographyPage(
//     BuildContext context,
//     int id,
//     String name,
//     CombinedCredits combinedCredits,
//     ) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//         builder: (_) => FilmographyPage(
//           id: id,
//           name: name,
//           combinedCredits: combinedCredits,
//         )),
//   );
// }
}

class StreamersView<M extends Media, V extends MediaViewModel<M>>
    extends StatelessWidget with Utilities {
  final double maxIconSize = 64.0;
  final int id;

  const StreamersView({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var type = M.toString() == (Movie).toString() ? 'movie' : 'tv';
    return Selector<V, List<WatchProvider>>(
      selector: (_, mvm) => mvm.streamingProviders ?? [],
      builder: (_, streamers, __) {
        if (streamers.isEmpty) {
          return const SizedBox.shrink();
        } else {
          // final screenWidth = MediaQuery.sizeOf(context).width;
          const width = 45.0;
          const vPadding = 8.0;
          return Material(
            color: lighten2(Theme.of(context).colorScheme.tertiary, 60),
            child: InkWell(
              onTap: () =>
                  launchUrlString('https://www.themoviedb.org/$type/$id/watch'),
              child: Center(
                child: SizedBox(
                  height: width + vPadding * 2,
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: vPadding,
                    ),
                    itemBuilder: (_, index) {
                      var streamer = streamers[index];
                      return NetworkImageView(
                        streamer.logoPath,
                        imageType: ImageType.logo,
                        aspectRatio: Constants.arAvatar,
                        topRadius: 4.0,
                        bottomRadius: 4.0,
                      );
                    },
                    separatorBuilder: (_, index) => const SizedBox(
                      width: 8.0,
                    ),
                    itemCount: streamers.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            ),
          );
          // var streamer = streamers.first;
          // return buildViewsOld(context, type, width, streamer);
        }
      },
    );
  }

  Material buildViewsOld(
      BuildContext context, String type, double width, WatchProvider streamer) {
    return Material(
      color: lighten2(Theme.of(context).colorScheme.tertiary, 60),
      child: InkWell(
        onTap: () =>
            launchUrlString('https://www.themoviedb.org/$type/$id/watch'),
        // highlightColor: Theme.of(context).highlightColor,
        // splashColor: Theme.of(context).splashColor,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: width,
                  child: NetworkImageView(
                    streamer.logoPath,
                    imageType: ImageType.logo,
                    aspectRatio: Constants.arAvatar,
                    topRadius: 4.0,
                    bottomRadius: 4.0,
                  ),
                ),
              ),
              Text(
                'Now streaming on\n${streamer.providerName}',
                style: const TextStyle(
                  height: 1.15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoreByGenresSection<M extends Media, T extends MediaViewModel<M>>
    extends StatelessWidget with GenericFunctions, Utilities, CommonFunctions {
  final int _maxCount = 20;

  const MoreByGenresSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<T, List<CombinedResult>>(
      selector: (_, mvm) => mvm.moreByGenres ?? [],
      builder: (_, list, __) {
        logIfDebug('moreByGenres:$list');
        if (list.isEmpty) {
          return SliverToBoxAdapter(child: Container());
        }
        return BaseSectionSliver(
          title: 'Similar titles',
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'A carefully curated list of similar top rated titles from the same era'
                /*' having most of the similar genres'*/,
                style: TextStyle(
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
            ),
            MediaPosterListView(
              items: list.take(_maxCount).toList(),
              posterWidth: 140.0,
              radius: 4.0,
              listViewBottomPadding: 16.0,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: list.length > _maxCount
                  ? CompactTextButton(
                      'Explore all',
                      onPressed: () {
                        final mvm = context.read<T>();
                        final mediaType =
                            mvm.isMovie ? MediaType.movie : MediaType.tv;
                        goToMediaListPage(
                          context,
                          mediaType: mediaType,
                          similarTitlesParams: SimilarTitlesParams(
                            mediaId: mvm.media!.id,
                            mediaType: mediaType,
                            genrePairs: mvm.genrePairs,
                            dateGte: mvm.dateGte,
                            dateLte: mvm.dateLte,
                            keywordsString: mvm.keywordsString,
                          ),
                          mediaTitle: mvm.getMediaTitle(),
                        );
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

// goToFilmographyPage(
//     BuildContext context,
//     int id,
//     String name,
//     CombinedCredits combinedCredits,
//     ) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//         builder: (_) => FilmographyPage(
//           id: id,
//           name: name,
//           combinedCredits: combinedCredits,
//         )),
//   );
// }
}

class MoreByDirectorSection<M extends Media, T extends MediaViewModel<M>>
    extends StatelessWidget with GenericFunctions, Utilities, CommonFunctions {
  // final int _maxCount = 20;

  const MoreByDirectorSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<T, Tuple2<BasePersonResult, List<CombinedResult>>?>(
      selector: (_, mvm) => mvm.moreByDirector,
      builder: (_, tuple, __) {
        // logIfDebug('moreByDirector:$list');
        if (tuple == null) {
          return SliverToBoxAdapter(child: Container());
        }
        return BaseSectionSliver(
          title: 'More by ${tuple.item1.name}',
          children: [
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Text(
            //     'A carefully curated list of top rated movies of '
            //         'the same era '
            //         'having most of the similar genres',
            //     style: TextStyle(
            //       color: Colors.black87,
            //     ),
            //   ),
            // ),
            MediaPosterListView(
              items: tuple.item2,
              posterWidth: 140.0,
              radius: 4.0,
            ),
          ],
        );
      },
    );
  }
}

class _CastCrewSection extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final int _maxCount = 10;

  const _CastCrewSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MovieViewModel, Tuple2<List<Cast>, List<Crew>>>(
      selector: (_, mvm) => Tuple2(mvm.cast, mvm.crew),
      builder: (_, tuple, __) {
        if (tuple.item1.isEmpty && tuple.item2.isEmpty) {
          return SliverToBoxAdapter(child: Container());
        }
        return BaseSectionSliver(
          title: 'Top billed cast',
          showSeeAll: tuple.item2.isEmpty,
          onPressed: () => goToCreditsPage(context),
          children: [
            if (tuple.item1.isNotEmpty)
              _CastPosterListView(
                items: tuple.item1.take(_maxCount).toList(),
              ),
            if (tuple.item2.isNotEmpty) getCrewSection(context, tuple.item2),
          ],
        );
      },
    );
  }

  Widget getCrewSection(BuildContext context, List<Crew> crew) {
    /// We show only directors and co-directors, each sorted alphabetically.
    /// Co-directors will have their job mentioned with their names.
    var labelDirector = Constants.departMap[Department.directing.name]!;
    var labelWriter = Constants.departMap[Department.writing.name]!;
    var directors = (crew
            .where((element) => element.job == labelDirector)
            .toList()
          ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()))) +
        (crew
                .where((element) => element.job.toLowerCase() == 'co-director')
                .toList()
              ..sort((a, b) =>
                  a.name.toLowerCase().compareTo(b.name.toLowerCase())))
            .map((e) => e.copyWith(jobs: ' (${e.job})'))
            .toList();

    /// We show all crew from the department 'writing'
    var writers = (crew
        .where((element) => element.department == Department.writing.name)
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())));

    // if (directors.isEmpty && writers.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          getCrewTile(context, directors, labelDirector),
          getCrewTile(context, writers, labelWriter),
          CompactTextButton('Full cast & crew', onPressed: () {
            goToCreditsPage(context);
          }),
        ],
      ),
    );
  }

  Widget getCrewTile(BuildContext context, List<Crew> crew, String label) {
    if (crew.isEmpty) return const SizedBox.shrink();

    Map<int, Set<Crew>> crewMap = {};
    for (var c in crew) {
      crewMap.putIfAbsent(c.id, () => {}).add(c);
    }

    /// We join the jobs of a crew member and append those with his name.
    /// However, if there is only one job and that is 'Writer', we don't append
    /// it because, the label of this section already tells us that writers are
    /// shown therein.
    var combinedCrew = <Crew>[];
    for (var id in crewMap.keys) {
      var writer = crewMap[id]!.first;
      var jobs = crewMap[id]!.map((e) => e.job).toList();
      var jobString = jobs.length == 1 && jobs.first == label
          ? ''
          : ' (${jobs.join(', ')})';
      combinedCrew.add(writer.copyWith(jobs: jobString));
    }

    var names = combinedCrew.map((e) => '${e.name}${e.jobs ?? ''}').join(', ');
    label = '$label${combinedCrew.length > 1 ? 's' : ''}';
    // var names = crew.map((e) => e.name).toSet().join(', ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (combinedCrew.length == 1) {
            goToPersonPage(context, combinedCrew.first);
          } else {
            goToCreditsPage(
              context,
              title: label,
              credits: Credits([], crew),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                names,
                // maxLines: 2,
                style: const TextStyle(
                  fontSize: 15.0,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToCreditsPage(
    BuildContext context, {
    Credits? credits,
    String? title,
  }) {
    var mvm = context.read<MovieViewModel>();
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return CreditsPage(
        title: title,
        credits: credits ?? mvm.media!.credits,
        id: mvm.media!.id,
        name: mvm.media!.movieTitle,
      );
    }));
  }

// Widget getSectionTitleRow(bool showSeeAll, Function()? onPressed) => Padding(
//       padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: const [
//           Text(
//             'Top billed cast' /*.toUpperCase()*/,
//             style: TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1.5,
//               // height: 1.1,
//             ),
//           ),
//           // if (showSeeAll) CompactTextButton('All cast', onPressed: onPressed),
//         ],
//       ),
//     );
}

class _CastPosterListView extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final List<Cast> items;
  final double posterWidth;
  final double radius;

  final titleContainerPadding = 8.0;

  late final titleFontSize = 14.0;

  final titleLineHeight = 1.2;

  final aspectRatio = Constants.arProfile / 0.87;

  final maxLines = 2;

  late final yearFontSize = titleFontSize;

  final listViewTopPadding = 16.0;

  final listViewHorizontalPadding = 16.0 - Constants.cardMargin;

  final nameTopPadding = 8.0;

  final nameBottomPadding = 0.0;

  final characterTopPadding = 6.0;

  final characterBottomPadding = 8.0;

  final nameStyle = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  final characterStyle = const TextStyle(
    fontSize: 14.0,
    height: 1.2,
  );

  _CastPosterListView({
    required this.items,
    this.posterWidth = 140.0,
    this.radius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');
    final posterHeight = (posterWidth - Constants.cardMargin * 2) / aspectRatio;

    /// This addition of 0.2 (per line) is required in order to avoid the "A
    /// RenderFlex overflowed by 0.800 pixels on the bottom." error
    late final nameHeight =
        (nameStyle.height! * nameStyle.fontSize! + 0.2) * maxLines;

    late final characterHeight =
        (characterStyle.height! * characterStyle.fontSize! + 0.2) * maxLines;

    late final nameContainerHeight =
        nameHeight + nameTopPadding + nameBottomPadding;

    late final characterContainerHeight =
        characterHeight + characterTopPadding + characterBottomPadding;

    final listViewHeight = posterHeight +
        nameContainerHeight +
        characterContainerHeight +
        listViewTopPadding * 2;

    return SizedBox(
      height: listViewHeight,
      child: ListView.builder(
        itemBuilder: (_, index) {
          // logIfDebug('MyListView itemBuilder called');
          final cast = items[index];
          return buildItemView(
            context,
            cast,
            cardMargin: Constants.cardMargin,
            nameContainerHeight: nameContainerHeight,
            characterContainerHeight: characterContainerHeight,
          );
        },
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          listViewHorizontalPadding,
          listViewTopPadding,
          listViewHorizontalPadding,
          listViewTopPadding,
        ),
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemExtent: posterWidth,
      ),
    );
  }

  Widget buildItemView(
    BuildContext context,
    Cast cast, {
    required double cardMargin,
    required double nameContainerHeight,
    required double characterContainerHeight,
  }) {
    return Stack(
      children: [
        Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 3.0,
          margin: EdgeInsets.symmetric(horizontal: cardMargin),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NetworkImageView(
                cast.profilePath,
                imageType: ImageType.profile,
                aspectRatio: aspectRatio,
                topRadius: radius,
                fit: BoxFit.fitWidth,
                heroImageTag: '${cast.id}',
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  titleContainerPadding,
                  nameTopPadding,
                  titleContainerPadding,
                  nameBottomPadding,
                ),
                // height: nameContainerHeight,
                child: Text(
                  cast.name,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: nameStyle,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  titleContainerPadding,
                  characterTopPadding,
                  titleContainerPadding,
                  characterBottomPadding,
                ),
                // height: characterContainerHeight,
                child: Text(
                  cast.character,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: characterStyle,
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: cardMargin),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(radius),
                onTap: () {
                  goToPersonPage(context, cast);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MediaInfoSection extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  const _MediaInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MovieViewModel, Movie?>(
      builder: (_, movie, __) {
        if (movie == null) {
          return SliverToBoxAdapter(child: Container());
        } else {
          return BaseSectionSliver(
            title: 'Movie details',
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 16.0,
                ),
                child: Column(
                  children: getMovieDetailSections(movie, context),
                ),
              )
            ],
          );
        }
      },
      selector: (_, mvm) => mvm.media,
    );
  }

  List<Widget> getMovieDetailSections(Movie movie, BuildContext context) {
    var releaseDate = getReadableDate(movie.releaseDate);
    var status = movie.status;
    var language = context
        .read<ConfigViewModel>()
        .cfgLanguages
        .firstWhere((element) => element.iso6391 == movie.originalLanguage)
        .englishName;
    var budget = movie.budget == 0
        ? '-'
        : '\$${applyCommaAndRoundNoZeroes(movie.budget.toDouble(), 0, true)}';
    var revenue = movie.revenue == 0
        ? '-'
        : '\$${applyCommaAndRoundNoZeroes(movie.revenue.toDouble(), 0, true)}';
    return [
      getSubSection('Release date', releaseDate.isEmpty ? '-' : releaseDate,
          onTap: movie.releaseDates.results.length <= 1
              ? null
              : () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return MediaSubDetailsPage<ReleaseDatesResult>(
                        list: movie.releaseDates.results
                          ..sort((a, b) {
                            var countries =
                                context.read<ConfigViewModel>().cfgCountries;
                            var countryA = countries.firstWhere(
                                (element) => element.iso31661 == a.iso31661);
                            var countryB = countries.firstWhere(
                                (element) => element.iso31661 == b.iso31661);
                            return countryA.englishName
                                .compareTo(countryB.englishName);
                          }),
                        title: 'Release dates',
                        name: movie.movieTitle);
                  }));
                }),
      getSubSection('Status', status.isEmpty ? '-' : status),
      getSubSection('Original language', language.isEmpty ? '-' : language,
          onTap: movie.spokenLanguages.length <= 1
              ? null
              : () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return MediaSubDetailsPage<LanguageConfig>(
                        list: movie.spokenLanguages,
                        title: 'Spoken languages',
                        name: movie.movieTitle);
                  }));
                }),
      getSubSection('Budget', budget),
      getSubSection('Revenue', revenue),
      if (movie.productionCountries.isNotEmpty)
        getSubSection('Produced in', movie.productionCountries.first.name,
            onTap: movie.productionCountries.length <= 1
                ? null
                : () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return MediaSubDetailsPage<ProductionCountry>(
                          list: movie.productionCountries,
                          title: 'Production countries',
                          name: movie.movieTitle);
                    }));
                  }),
      if (movie.productionCompanies.isNotEmpty)
        getSubSection('Production by', movie.productionCompanies.first.name,
            onTap: movie.productionCompanies.length <= 1
                ? null
                : () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return MediaSubDetailsPage<ProductionCompany>(
                          list: movie.productionCompanies,
                          title: 'Production companies',
                          name: movie.movieTitle);
                    }));
                  }),
    ];
  }

  // Widget getCountriesSection(Movie movie) {
  //
  // }

  Widget getSubSection(String label, String content, {Function()? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _separator,
                    getLabelView(label),
                    getContentView(content),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.0,
                  color: Colors.black38,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getLabelView(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14.0,
        // height: 1.1,
        color: Colors.black54,
      ),
    );
  }

  Widget getContentView(String? text) {
    return Text(
      (text == null || text.isEmpty) ? '-' : text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16.0,
        // fontWeight: FontWeight.bold,
        // height: 1.1,
      ),
    );
  }
}

class KeywordsSection<M extends Media, VM extends MediaViewModel<M>>
    extends StatelessWidget with GenericFunctions, Utilities, CommonFunctions {
  final int _maxCount = 10;

  const KeywordsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isMovie = M.toString() == (Movie).toString();
    return Selector<VM, Tuple2<List<Keyword>, int>>(
      selector: (_, mvm) => Tuple2(
        mvm.keywords.take(_maxCount).toList(),
        mvm.keywords.length,
      ),
      builder: (_, tuple, __) {
        if (tuple.item2 == 0) {
          return SliverToBoxAdapter(child: Container());
        }
        return BaseSectionSliver(
          title: 'Keywords',
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 8.0,
                runSpacing: 10.0,
                children: tuple.item1.map((keyword) {
                  return InkWellOverlay(
                    onTap: () {
                      goToMediaListPage(
                        context,
                        mediaType: isMovie ? MediaType.movie : MediaType.tv,
                        keywords: [keyword],
                        genres: context.read<VM>().media?.genres,
                      );
                    },
                    borderRadius: BorderRadius.circular(6.0),
                    child: getKeywordChip(context, keyword),
                  );
                }).toList(),
              ),
            ),
          ],
        );
        // return SliverPadding(
        //   padding: const EdgeInsets.symmetric(vertical: 12.0),
        //   sliver: SliverStack(
        //     children: [
        //       /// This serves as the base card on which the content card is
        //       /// stacked. The fill constructor helps match its height with
        //       /// the height of the content card.
        //       SliverPositioned.fill(
        //         child: Container(
        //           color: Colors.white,
        //         ),
        //       ),
        //       SliverToBoxAdapter(
        //         child: Column(
        //           children: [
        //             getSectionSeparator(context),
        //             getSectionTitleRow(tuple.item2 > _maxCount, () {}),
        //             Container(
        //               width: MediaQuery.of(context).size.width,
        //               padding: const EdgeInsets.symmetric(
        //                   vertical: 16.0, horizontal: 16.0),
        //               child: Wrap(
        //                 alignment: WrapAlignment.start,
        //                 spacing: 8.0,
        //                 runSpacing: 10.0,
        //                 children: tuple.item1.map((keyword) {
        //                   return InkWellOverlay(
        //                     onTap: () {
        //                       goToMediaListPage(
        //                         context,
        //                         mediaType:
        //                             isMovie ? MediaType.movie : MediaType.tv,
        //                         keywords: [keyword],
        //                         genres: context.read<VM>().media?.genres,
        //                       );
        //                     },
        //                     borderRadius: BorderRadius.circular(6.0),
        //                     child: getKeywordChip(context, keyword),
        //                   );
        //                 }).toList(),
        //               ),
        //             ),
        //             getSectionSeparator(context),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }

  Chip getKeywordChip(BuildContext context, Keyword keyword) {
    return Chip(
      backgroundColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.17),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Text(
        keyword.name.toProperCase(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      side: BorderSide(
        color: Theme.of(context).colorScheme.primary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }

// Widget getSectionTitleRow(bool showSeeAll, Function()? onPressed) => Padding(
//       padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'Keywords' /*.toUpperCase()*/,
//             style: TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1.5,
//               // height: 1.1,
//             ),
//           ),
//           if (showSeeAll) CompactTextButton('See all', onPressed: onPressed),
//         ],
//       ),
//     );
}

class ReviewsSection extends StatelessWidget {
  final int _maxCount = 10;

  const ReviewsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MovieViewModel, Tuple2<List<Review>, int>>(
      selector: (_, mvm) => Tuple2(mvm.reviews, mvm.totalReviewsCount),
      builder: (_, tuple, __) {
        if (tuple.item1.isEmpty) {
          return SliverToBoxAdapter(child: Container());
        }
        return BaseSectionSliver(
          title: 'User reviews',
          children: [
            ReviewsListView(
              tuple.item1.take(_maxCount).toList(),
            ),
          ],
        );
        // return SliverPadding(
        //   padding: const EdgeInsets.symmetric(vertical: 12.0),
        //   sliver: SliverStack(
        //     children: [
        //       /// This serves as the base card on which the content card is
        //       /// stacked. The fill constructor helps match its height with
        //       /// the height of the content card.
        //       SliverPositioned.fill(
        //         child: Container(
        //           color: Colors.white,
        //         ),
        //       ),
        //       SliverToBoxAdapter(
        //         child: Column(
        //           children: [
        //             getSliverSeparator(context),
        //             getSectionTitleRow(tuple.item1.length > _maxCount, () {}),
        //             ReviewsListView(
        //               tuple.item1.take(_maxCount).toList(),
        //               MediaQuery.of(context).size.width,
        //             ),
        //             // Padding(
        //             //   padding: const EdgeInsets.only(bottom: 8.0),
        //             //   child:
        //             //       CompactTextButton('Write a review', onPressed: () {}),
        //             // ),
        //             getSliverSeparator(context),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }

// Widget getSliverSeparator(BuildContext context) => Container(
//       height: 1.0,
//       color: Theme.of(context).primaryColorLight,
//     );

// Widget getSectionTitleRow(bool showSeeAll, Function()? onPressed) => Padding(
//       padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'User reviews' /*.toUpperCase()*/,
//             style: TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1.5,
//               // height: 1.1,
//             ),
//           ),
//           if (showSeeAll) CompactTextButton('See all', onPressed: onPressed),
//         ],
//       ),
//     );
}

class ReviewsListView extends StatelessWidget with GenericFunctions {
  final List<Review> reviews;

  ReviewsListView(this.reviews, {Key? key}) : super(key: key);

  final listViewHorizontalPadding = 16.0;

  final listViewTopPadding = 16.0;

  final listViewBottomPadding = 24.0;

  final aspectRatio = Constants.arAvatar;

  final avatarSize = 50.0;

  final maxLines = 12;

  final textHorizPadding = 16.0;

  final ratingBottomPadding = 10.0;

  final nameTopPadding = 8.0;

  final nameBottomPadding = 0.0;

  final reviewTopPadding = 0.0;

  final reviewBottomPadding = 16.0;

  final authorVerticalPadding = 16.0;

  final nameStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
    decoration: TextDecoration.underline,
  );

  final reviewTextStyle = const TextStyle(
    fontSize: 14.0,
    height: 1.2,
  );

  final dateTextStyle = const TextStyle(
    color: Colors.black54,
    fontSize: 12.0,
    height: 1.2,
  );

  final topRadius = 4.0;

  final bottomRadius = 4.0;

  final ratingIconSize = 14.0;

  late final nameHeight =
      nameStyle.height! * nameStyle.fontSize! * 1 /* (max lines) */;

  // late final nameContainerHeight =
  //     nameHeight + nameTopPadding + nameBottomPadding;

  /// This 0.8 is being to escape the "A RenderFlex overflowed by 0.800
  /// pixels on the bottom." error. The error is being caused by not
  /// assigning any height to the name and character test widgets.
  /// However, assigning height, especially to name text widget makes it
  /// expand to two lines no matter if name is actually on one line only,
  /// thereby showing an extra blank line between home snd tasks.
  /* + 0.8*/

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    final viewWidth = isPortrait ? 260.0 : 360.0;

    final reviewHeight = isPortrait ? 170.0 : 130.0;

    final reviewContainerHeight =
        reviewHeight + reviewTopPadding + reviewBottomPadding;

    final authorContainerHeight = avatarSize + authorVerticalPadding * 2;

    final ratingContainerHeight = ratingIconSize + ratingBottomPadding;

    final cardHeight =
        authorContainerHeight + reviewContainerHeight + ratingContainerHeight;

    final viewHeight = cardHeight + listViewTopPadding + listViewBottomPadding;

    return SizedBox(
      height: viewHeight,
      child: ListView.builder(
        itemBuilder: (_, index) {
          final review = reviews[index];
          final imagePath = review.authorDetails.avatarPath;
          return buildItemView(context, viewWidth, imagePath, review);
        },
        itemExtent: viewWidth,
        padding: EdgeInsets.fromLTRB(
          listViewHorizontalPadding - Constants.cardMargin,
          listViewTopPadding,
          listViewHorizontalPadding - Constants.cardMargin,
          listViewBottomPadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: reviews.length,
      ),
    );
  }

  Card buildItemView(
    BuildContext context,
    double viewWidth,
    String? imagePath,
    Review review,
  ) {
    var scrollbarPadding = 4.0;
    var controller = ScrollController();
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(topRadius),
      ),
      margin: const EdgeInsets.symmetric(horizontal: Constants.cardMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(authorVerticalPadding),
            child: SizedBox(
              // width: avatarSize,
              height: avatarSize,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWellOverlay(
                    onTap: imagePath.isNotNullNorEmpty
                        ? () {
                            logIfDebug('Avatar clicked');
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return ImagePage(
                                images: [
                                  ImageDetail(
                                    Constants.arProfile,
                                    0,
                                    imagePath ?? '',
                                    0,
                                    0,
                                    0,
                                  ),
                                ],
                                initialPage: 0,
                              );
                            }));
                          }
                        : null,
                    borderRadius: BorderRadius.circular(avatarSize),
                    child: NetworkImageView(
                      imagePath,
                      imageType: ImageType.profile,
                      imageQuality: ImageQuality.original,
                      aspectRatio: aspectRatio,
                      topRadius: avatarSize,
                      bottomRadius: avatarSize,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWellOverlay(
                            child: Text(
                              review.author,
                              maxLines: 1,
                              style: nameStyle,
                            ),
                            onTap: () {
                              logIfDebug('${review.author} clicked');
                            },
                          ),
                          Text(
                            getReadableDate(review.createdAt),
                            style: dateTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (review.authorDetails.rating != null)
                  getRatingRow(review.authorDetails.rating!.toInt()),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: reviewTopPadding,
                      bottom: reviewBottomPadding,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(right: scrollbarPadding),
                      child: Scrollbar(
                        controller: controller,
                        thumbVisibility: true,
                        thickness: 4.0,
                        child: SingleChildScrollView(
                          controller: controller,
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: textHorizPadding,
                            right: textHorizPadding - scrollbarPadding,
                          ),
                          child: Text(
                            review.content,
                            // maxLines: maxLines,
                            // overflow: TextOverflow.ellipsis,
                            style: reviewTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getRatingRow(int rating) {
    var icons = List<FaIcon>.filled(
      rating,
      FaIcon(
        FontAwesomeIcons.solidStar,
        size: ratingIconSize,
        color: Constants.ratingIconColor,
      ),
      growable: true,
    );
    while (icons.length < 10) {
      icons.add(FaIcon(
        FontAwesomeIcons.star,
        size: ratingIconSize,
      ));
    }
    // if (rating < 10) {
    //   icons.insertAll(
    //     rating,
    //     List<FaIcon>.filled(
    //       10 - rating,
    //       FaIcon(
    //         FontAwesomeIcons.star,
    //         size: ratingIconSize,
    //       ),
    //     ),
    //   );
    // }
    return Padding(
      padding: EdgeInsets.only(
        left: textHorizPadding,
        right: textHorizPadding,
        bottom: ratingBottomPadding,
      ),
      child: Row(
        children: icons.map((e) {
          if (icons.indexOf(e) == icons.length - 1) {
            return e;
          } else {
            return Padding(
              padding: const EdgeInsets.only(
                right: 1.5,
              ),
              child: e,
            );
          }
        }).toList(),
      ),
    );
  }
}

@Deprecated('Old version')
class ReviewsListViewOld extends StatelessWidget with GenericFunctions {
  final List<Review> reviews;
  final double screenWidth;

  ReviewsListViewOld(this.reviews, this.screenWidth, {Key? key})
      : super(key: key);

  final separatorWidth = 10.0;

  final listViewHorizontalPadding = 16.0;

  final listViewTopPadding = 16.0;

  final listViewBottomPadding = 24.0;

  final cardCount = 1.25;

  late final deductibleWidth = listViewHorizontalPadding +
      separatorWidth * (cardCount > 1 ? cardCount.toInt() : 0);

  late final sectionWidth = (screenWidth - deductibleWidth) / cardCount;

  final aspectRatio = Constants.arAvatar;

  late final posterHeight = sectionWidth / aspectRatio;

  final avatarSize = 50.0;

  final maxLines = 12;

  final textHorizPadding = 16.0;

  final ratingBottomPadding = 8.0;

  final nameTopPadding = 8.0;

  final nameBottomPadding = 0.0;

  final reviewTopPadding = 0.0;

  final reviewBottomPadding = 16.0;

  final authorVerticalPadding = 16.0;

  final nameStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
    decoration: TextDecoration.underline,
  );

  final reviewTextStyle = const TextStyle(
    fontSize: 14.0,
    height: 1.2,
  );

  final dateTextStyle = const TextStyle(
    color: Colors.black54,
    fontSize: 12.0,
    height: 1.2,
  );

  final topRadius = 4.0;

  late final bottomRadius = topRadius;

  final ratingIconSize = 18.0;

  late final nameHeight = nameStyle.height! * nameStyle.fontSize! * maxLines;

  late final reviewHeight =
      reviewTextStyle.height! * reviewTextStyle.fontSize! * maxLines;

  late final nameContainerHeight =
      nameHeight + nameTopPadding + nameBottomPadding;

  late final reviewContainerHeight =
      reviewHeight + reviewTopPadding + reviewBottomPadding;

  late final authorContainerHeight = avatarSize + authorVerticalPadding * 2;

  late final ratingContainerHeight = ratingIconSize + ratingBottomPadding;

  late final cardHeight = authorContainerHeight +
      /*posterHeight + nameContainerHeight + */ reviewContainerHeight +
      ratingContainerHeight;

  /// This 0.8 is being to escape the "A RenderFlex overflowed by 0.800
  /// pixels on the bottom." error. The error is being caused by not
  /// assigning any height to the name and character test widgets.
  /// However, assigning height, especially to name text widget makes it
  /// expand to two lines no matter if name is actually on one line only,
  /// thereby showing an extra blank line between home snd tasks.
  /* + 0.8*/

  @override
  Widget build(BuildContext context) {
    final viewHeight = cardHeight + listViewTopPadding + listViewBottomPadding;
    return SizedBox(
      height: viewHeight,
      child: ListView.separated(
        itemBuilder: (_, index) {
          final review = reviews[index];
          final imagePath = review.authorDetails.avatarPath;
          return buildItemView(imagePath, context, review);
        },
        separatorBuilder: (_, index) => SizedBox(width: separatorWidth),
        padding: EdgeInsets.fromLTRB(
          listViewHorizontalPadding,
          listViewTopPadding,
          listViewHorizontalPadding,
          listViewBottomPadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: reviews.length,
      ),
    );
  }

  Card buildItemView(String? imagePath, BuildContext context, Review review) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(topRadius),
      ),
      margin: EdgeInsets.zero,
      child: SizedBox(
        width: sectionWidth - 40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(authorVerticalPadding),
              child: SizedBox(
                // width: avatarSize,
                height: avatarSize,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWellOverlay(
                      onTap: imagePath.isNotNullNorEmpty
                          ? () {
                              logIfDebug('Avatar clicked');
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return ImagePage(
                                  images: [
                                    ImageDetail(
                                      Constants.arProfile,
                                      0,
                                      imagePath ?? '',
                                      0,
                                      0,
                                      0,
                                    ),
                                  ],
                                  initialPage: 0,
                                );
                              }));
                            }
                          : null,
                      borderRadius: BorderRadius.circular(avatarSize),
                      child: NetworkImageView(
                        imagePath,
                        imageType: ImageType.profile,
                        imageQuality: ImageQuality.original,
                        aspectRatio: aspectRatio,
                        topRadius: avatarSize,
                        bottomRadius: avatarSize,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWellOverlay(
                              child: Text(
                                review.author,
                                maxLines: 1,
                                style: nameStyle,
                              ),
                              onTap: () {
                                logIfDebug('${review.author} clicked');
                              },
                            ),
                            Text(
                              getReadableDate(review.createdAt),
                              style: dateTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (review.authorDetails.rating != null)
                    getRatingRow(review.authorDetails.rating!.toInt()),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: reviewTopPadding,
                        bottom: reviewBottomPadding,
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Scrollbar(
                              thumbVisibility: true,
                              thickness: 4.0,
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                padding: EdgeInsets.only(
                                  left: textHorizPadding,
                                  right: textHorizPadding - 4.0,
                                ),
                                child: Text(
                                  review.content,
                                  // maxLines: maxLines,
                                  // overflow: TextOverflow.ellipsis,
                                  style: reviewTextStyle,
                                ),
                              ),
                            ),
                          ),
                          // Container(
                          //   color: Colors.white60,
                          //   height: 24.0,
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRatingRow(int rating) {
    var icons = List<Icon>.filled(
      rating,
      Icon(
        Icons.star_sharp,
        size: ratingIconSize,
        color: Constants.ratingIconColor,
      ),
      growable: true,
    );
    if (rating < 10) {
      icons.insertAll(
        rating,
        List<Icon>.filled(
          10 - rating,
          Icon(
            Icons.star_outline_sharp,
            size: ratingIconSize,
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(
        left: textHorizPadding,
        right: textHorizPadding,
        bottom: ratingBottomPadding,
      ),
      child: Row(
        children: icons,
      ),
    );
  }
}

/// This widget showcases the implementation of a GridView in a PageView
/// The implementation was successful but the page scrolling was annoyingly
/// jerky, so I had to drop it in favour of a manually controlled PageView
/// implemented above.
class SliverPosterGridSwiper extends StatelessWidget with Utilities {
  final int _itemsPerRow = 3;
  final int _rowCount = 2;
  late final int _itemsPerPage = _itemsPerRow * _rowCount;
  final double _topRadius = 12.0;
  final double _bottomRadius = 12.0;
  final double _aspectRatio = Constants.arPoster;

  late final BorderRadius _borderRadius = (_topRadius > 0 || _bottomRadius > 0)
      ? BorderRadius.only(
          topRight: Radius.circular(_topRadius),
          topLeft: Radius.circular(_topRadius),
          bottomRight: Radius.circular(_bottomRadius),
          bottomLeft: Radius.circular(_bottomRadius),
        )
      : BorderRadius.zero;

  final List<MovieResult> _similarTitles;
  late final _remainder = similarTitles.length % _itemsPerPage;

  List<MovieResult> get similarTitles =>
      _similarTitles.take(_itemsPerPage * 3).toList();
  final _topPadding = 16.0;
  final _bottomPadding = 16.0;
  final _leftPadding = 16.0;

  final _mainAxisSpacing = 10.0;
  final _crossAxisSpacing = 5.0;

  final _indicatorHeight = 30.0;

  SliverPosterGridSwiper(
    this._similarTitles, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var availableWidth = MediaQuery.of(context).size.width -
        (_leftPadding * 2) -
        ((_itemsPerRow - 1) * _crossAxisSpacing);

    var rowHeight = availableWidth / _itemsPerRow / _aspectRatio;

    var height = rowHeight * _rowCount +
        _topPadding +
        _bottomPadding +
        ((_rowCount - 1) * _mainAxisSpacing) +
        _indicatorHeight;

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          top: _topPadding,
          bottom: _bottomPadding,
        ),
        height: height,
        child: Swiper(
          itemBuilder: (_, index) =>
              getGridView(getListForPage(similarTitles, index)),
          autoplay: false,
          loop: false,
          itemCount:
              similarTitles.length ~/ _itemsPerPage + (_remainder == 0 ? 0 : 1),
          indicatorLayout: PageIndicatorLayout.SCALE,
          physics: const ClampingScrollPhysics(),
          outer: true,
          // fade: 0.7,
          pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          // itemWidth: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  Widget getGridView(List<MovieResult> titles) {
    return GridView.builder(
      padding: EdgeInsets.only(
        left: _leftPadding,
        right: _leftPadding,
      ),
      itemBuilder: (context, index) {
        final movie = titles[index];
        final destUrl = movie.backdropPath == null
            ? null
            : context.read<ConfigViewModel>().getImageUrl(
                ImageType.backdrop, ImageQuality.high, movie.backdropPath!);
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: _borderRadius,
          ),
          elevation: 6.0,
          // Margins had to be tweaked a bit in order to
          // remove the whitespace around the image.
          margin: const EdgeInsets.fromLTRB(1.5, 2.5, 1.8, 2.5),
          child:
              // Column(
              //   children: [
              getImageView(titles, index, context, movie, destUrl),
          // Text(getYearStringFromDate(movie.releaseDate), style: textStyle,),
          //   ],
          // ),
        );
      },
      physics: const NeverScrollableScrollPhysics(),
      itemCount: titles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _itemsPerRow,
        childAspectRatio: _aspectRatio,
        mainAxisSpacing: _mainAxisSpacing,
        crossAxisSpacing: _crossAxisSpacing,
        // mainAxisExtent: height,
      ),
    );
  }

  Widget getImageView(List<MovieResult> similarTitles, int index,
      BuildContext context, MovieResult movie, String? destUrl) {
    return Stack(
      children: [
        NetworkImageView(
          similarTitles[index].posterPath,
          imageType: ImageType.poster,
          topRadius: _topRadius,
          bottomRadius: _bottomRadius,
          aspectRatio: _aspectRatio,
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: _borderRadius,
              onTap: () {
                goToMoviePage(context, movie, destUrl);
              },
            ),
          ),
        ),
      ],
    );
  }

  void goToMoviePage(BuildContext context, MovieResult movie, String? destUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoviePage(
            id: movie.id,
            title: movie.movieTitle,
            year: getYearStringFromDate(movie.releaseDate),
            voteAverage: movie.voteAverage,
            overview: movie.overview,
            sourceUrl: null,
            destUrl: destUrl,
            backdrop: movie.backdropPath,
            heroImageTag: ''),
      ),
    ).then((value) {});
  }

  List<MovieResult> getListForPage(List<MovieResult> list, int index) {
    return list.skip(_itemsPerPage * index).take(_itemsPerPage).toList();
  }
}

class ImageDelegate extends SliverPersistentHeaderDelegate
    with GenericFunctions {
  // final String baseUrl;
  final double extent;
  final MediaType mediaType;
  BuildContext? _context;

  late final double iconSize = extent * 0.30;

  final Map<String, ThumbnailType> thumbMap;

  final PageController controller = PageController();

  final double radius = 0.0;

  final int delay = 7000;

  final double fraction = 1.0 /*0.88*/;

  ImageDelegate({
    required this.extent,
    required this.mediaType,
    required this.thumbMap,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    logIfDebug('isPinned, extent:$extent');
    _context ??= context;
    return extent == 0
        ? const SizedBox.shrink()
        : Swiper(
            itemBuilder: (_, index) => getView(context, index),
            autoplay: true,
            itemCount: thumbMap.length,
            indicatorLayout: PageIndicatorLayout.SCALE,
            autoplayDelay: delay,
            loop: thumbMap.length > 1,

            /// precaches the next page
            allowImplicitScrolling: true,
            // transformer: ScaleAndFadeTransformer(),
            // viewportFraction: fraction,
            // scale: fraction + 0.04,
            fade: 0.7,
            pagination: const SwiperPagination(),
            // itemWidth: MediaQuery.of(context).size.width,
          );
  }

  Widget getView(BuildContext context, int index) {
    var entry = thumbMap.entries.elementAt(index);
    if (entry.value == ThumbnailType.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: NetworkImageView(
          context.read<ConfigViewModel>().getImageUrl(
                ImageType.backdrop,
                ImageQuality.high,
                entry.key,
              ),
          imageType: ImageType.backdrop,
          aspectRatio: Constants.arBackdrop,
          fit: BoxFit.fill,
        ),
        // child: Image.network(
        //   context.read<ConfigViewModel>().getImageUrl(
        //         ImageType.backdrop,
        //         ImageQuality.high,
        //         entry.key,
        //       ),
        //   fit: BoxFit.fill,
        //   errorBuilder: (_, __, ___) {
        //     return Icon(
        //       Icons.error_outline_sharp,
        //       size: extent * 0.30,
        //     );
        //   },
        // ),
      );
    } else {
      var imageUrl = getThumbnailUrl(entry.key);
      var width = MediaQuery.of(context).size.width;
      return Stack(
        // fit: StackFit.expand,
        children: [
          ImageNetwork(
            image: imageUrl,
            imageCache: CachedNetworkImageProvider(imageUrl),
            height: width / Constants.arBackdrop,
            width: width,
            onLoading: Image.asset(
              Constants.placeholderPath,
              fit: BoxFit.contain,
            ),
            onError: const Center(
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
              ),
            ),
            fitWeb: BoxFitWeb.fill,
          ),
          Center(
            child: IconButton(
              onPressed: () {
                if (mediaType == MediaType.movie) {
                  _context!.read<MovieViewModel>().initialVideoId = entry.key;
                } else if (mediaType == MediaType.tv) {
                  _context!.read<TvViewModel>().initialVideoId = entry.key;
                }
              },
              icon: Icon(
                Icons.play_circle_outline_sharp,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ),
        ],
      );
    }
  }

  // List<Widget> getViews() {
  //   var views = <Widget>[];
  //   for (int i = 0; i < thumbMap.length; i++) {
  //     views.add(getView(i));
  //     // if (entry.value == ThumbnailType.image) {
  //     //   views.add(
  //     //     Image.network('$baseUrl${entry.key}', fit: BoxFit.fill),
  //     //   );
  //     // } else {
  //     //   views.add(
  //     //     Stack(
  //     //       fit: StackFit.expand,
  //     //       children: [
  //     //         Image.network(getThumbnailUrl(entry.key), fit: BoxFit.fill),
  //     //         IconButton(
  //     //           onPressed: () {
  //     //             _context!.read<MovieViewModel>().isTrailerPinned = true;
  //     //           },
  //     //           icon: Icon(
  //     //             Icons.play_circle_outline_sharp,
  //     //             color: Colors.white,
  //     //             size: iconSize,
  //     //           ),
  //     //         ),
  //     //       ],
  //     //     ),
  //     //   );
  //     // }
  //   }
  //   return views;
  // }

  String getThumbnailUrl(String key) {
    return 'https://img.youtube.com/vi/$key/mqdefault.jpg';
  }

  @override
  double get maxExtent => extent * fraction;

  @override
  double get minExtent => extent * fraction;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class TrailerDelegate extends SliverPersistentHeaderDelegate
    with GenericFunctions {
  final double extent;
  final MediaType mediaType;
  final String initialVideoId;
  final List<String> youtubeKeys;

  TrailerDelegate({
    required this.extent,
    required this.mediaType,
    required this.initialVideoId,
    required this.youtubeKeys,
  });

  late final child = TrailerView(
    mediaType: mediaType,
    youtubeKeys: youtubeKeys,
    initialVideoId: initialVideoId,
  );

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    logIfDebug('isPinned, build called');
    return child;
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
