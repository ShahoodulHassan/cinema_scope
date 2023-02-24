import 'package:card_swiper/card_swiper.dart';
import 'package:cinema_scope/architecture/movie_view_model.dart';
import 'package:cinema_scope/models/configuration.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/pages/credits_page.dart';
import 'package:cinema_scope/pages/media_details_page.dart';
import 'package:cinema_scope/pages/person_page.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tuple/tuple.dart';

import '../architecture/config_view_model.dart';
import '../constants.dart';
import '../models/movie.dart';
import '../widgets/compact_text_button.dart';
import '../widgets/expandable_synopsis.dart';
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
              heroImageTag,
            ));
}

class _MoviePageChild extends StatefulWidget {
  final int id;

  final String title, heroImageTag;
  final String? year, overview, sourceUrl, destUrl;
  final double voteAverage;

  const _MoviePageChild(
    this.id,
    this.title,
    this.year,
    this.voteAverage,
    this.overview,
    this.sourceUrl,
    this.destUrl,
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
      backgroundColor: lighten2(Theme.of(context).primaryColorLight, 78),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // floating: true,
            pinned: true,
            // snap: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title),
              ],
            ),
          ),
          Selector<MovieViewModel,
              Tuple3<List<String>, Map<String, ThumbnailType>, String?>>(
            builder: (_, tuple, __) {
              logIfDebug('isPinned, thumbnails:$tuple');
              var height = MediaQuery.of(context).size.width * 9 / 16;
              if (tuple.item3 != null && tuple.item1.isNotEmpty) {
                return SliverPersistentHeader(
                  delegate: TrailerDelegate(
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
                    tuple.item2.isEmpty ? 0 : height,
                    tuple.item2,
                  ),
                  pinned: false,
                );
              }
            },
            selector: (_, mvm) {
              logIfDebug('isPinned, selector called with:${mvm.youtubeKeys}');
              return Tuple3<List<String>, Map<String, ThumbnailType>, String?>(
                mvm.youtubeKeys,
                mvm.thumbMap,
                mvm.initialVideoId,
              );
            },
          ),
          SliverToBoxAdapter(
            child: AnimatedSize(
              duration: animDuration,
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
                    buildTagline(),
                    ExpandableSynopsis(widget.overview),
                    buildGenresAndLinks(),
                  ],
                ),
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
          const KeywordsSection(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
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
          border: Border.all(color: Theme.of(context).primaryColorDark),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 0.8,
        ),
        child: Text(
          certification,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
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
              if (genres.isNotEmpty) getGenreView(genres),
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
                        ),
                      if (homepage.isNotEmpty)
                        getIconButton(
                            (homepage.contains('netflix')
                                ? Image.asset(
                                    'assets/icons/icons8_netflix_24.png',
                                    color: Theme.of(context).primaryColorDark,
                                  )
                                : const Icon(Icons.link)),
                            () => openUrlString(homepage)),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget getIconButton(Widget icon, Function() onPressed) => IconButton(
        onPressed: onPressed,
        icon: icon,
        iconSize: 24.0,
        color: Theme.of(context).primaryColorDark,
        // padding: EdgeInsets.zero,
        // visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
      );

  /// This method expects a non-empty list of genres
  Widget getGenreView(List<Genre> genres) {
    // final genres = movie.genres;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          separatorBuilder: (_, index) => const SizedBox(width: 8),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            final genre = genres[index];
            return InkWellOverlay(
              onTap: () {
                goToMovieListPage(
                  context,
                  mediaType: MediaType.movie,
                  genres: [genre],
                );
              },
              borderRadius: BorderRadius.circular(6.0),
              child: Chip(
                backgroundColor:
                    Theme.of(context).primaryColorLight.withOpacity(0.17),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Text(
                  genre.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                side: BorderSide(
                  color: Theme.of(context).primaryColorDark,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            );
          },
          itemCount: genres.length,
        ),
      ),
    );
  }
}

class _MoreByLeadSection extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final int _maxCount = 20;

  const _MoreByLeadSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MovieViewModel, List<CombinedResult>>(
      selector: (_, mvm) => mvm.moreByLead ?? [],
      builder: (_, moreByLead, __) {
        logIfDebug('moreByLead:$moreByLead');
        if (moreByLead.isEmpty) {
          return SliverToBoxAdapter(child: Container());
        }
        return BaseSectionSliver(
          title: 'More by lead actors',
          children: [
            PosterCardListView(
              items: moreByLead.take(_maxCount).toList(),
              screenWidth: MediaQuery.of(context).size.width,
              aspectRatio: Constants.arPoster,
              onTap: (item) {
                goToMoviePage(
                  context,
                  id: item.id,
                  title: item.mediaTitle,
                  overview: item.overview,
                  releaseDate: item.mediaReleaseDate /*getReleaseDate(item)*/,
                  voteAverage: item.voteAverage,
                );
              },
            ),
            // Container(
            //   alignment: Alignment.center,
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   child: CompactTextButton('All filmography', onPressed: () {
            //     var pvm = context.read<PersonViewModel>();
            //     var person = pvm.personWithKnownFor.person;
            //     goToFilmographyPage(
            //         context, person!.id, person.name, person.combinedCredits);
            //   }),
            // ),
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
            PosterCardListView(
              items: moreByActor.item2.take(_maxCount).toList(),
              screenWidth: MediaQuery.of(context).size.width,
              aspectRatio: Constants.arPoster,
              onTap: (item) {
                if (item.mediaType == MediaType.movie.name) {
                  goToMoviePage(
                    context,
                    id: item.id,
                    title: item.mediaTitle,
                    overview: item.overview,
                    releaseDate: item.mediaReleaseDate /*getReleaseDate(item)*/,
                    voteAverage: item.voteAverage,
                  );
                } else if (item.mediaType == MediaType.tv.name) {
                  goToTvPage(
                    context,
                    id: item.id,
                    title: item.mediaTitle,
                    overview: item.overview,
                    releaseDate: item.mediaReleaseDate /*getReleaseDate(item)*/,
                    voteAverage: item.voteAverage,
                  );
                }
              },
            ),
            // Container(
            //   alignment: Alignment.center,
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   child: CompactTextButton('All filmography', onPressed: () {
            //     var pvm = context.read<PersonViewModel>();
            //     var person = pvm.personWithKnownFor.person;
            //     goToFilmographyPage(
            //         context, person!.id, person.name, person.combinedCredits);
            //   }),
            // ),
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
          title: 'More from similar genres',
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'A carefully curated list of top rated titles of '
                'the same era '
                'having most of the similar genres',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            PosterCardListView(
              items: list.take(_maxCount).toList(),
              screenWidth: MediaQuery.of(context).size.width,
              aspectRatio: Constants.arPoster,
              onTap: (item) {
                item.mediaType == MediaType.movie.name
                    ? goToMoviePage(
                        context,
                        id: item.id,
                        title: item.mediaTitle,
                        overview: item.overview,
                        releaseDate:
                            item.mediaReleaseDate /*getReleaseDate(item)*/,
                        voteAverage: item.voteAverage,
                      )
                    : goToTvPage(
                        context,
                        id: item.id,
                        title: item.mediaTitle,
                        overview: item.overview,
                        releaseDate:
                            item.mediaReleaseDate /*getReleaseDate(item)*/,
                        voteAverage: item.voteAverage,
                      );
              },
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CompactTextButton('Explore all', onPressed: () {
                // var pvm = context.read<PersonViewModel>();
                // var person = pvm.personWithKnownFor.person;
                // goToFilmographyPage(
                //     context, person!.id, person.name, person.combinedCredits);
              }),
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
  final int _maxCount = 20;

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
            PosterCardListView(
              items: tuple.item2 /*.take(_maxCount).toList()*/,
              screenWidth: MediaQuery.of(context).size.width,
              aspectRatio: Constants.arPoster,
              onTap: (item) {
                if (item.mediaType == MediaType.movie.name) {
                  goToMoviePage(
                    context,
                    id: item.id,
                    title: item.mediaTitle,
                    overview: item.overview,
                    releaseDate: item.mediaReleaseDate /*getReleaseDate(item)*/,
                    voteAverage: item.voteAverage,
                  );
                } else if (item.mediaType == MediaType.tv.name) {
                  goToTvPage(
                    context,
                    id: item.id,
                    title: item.mediaTitle,
                    releaseDate: item.mediaReleaseDate,
                    voteAverage: item.voteAverage,
                    overview: item.overview,
                  );
                }
              },
            ),
            // Container(
            //   alignment: Alignment.center,
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   child: CompactTextButton('Explore all', onPressed: () {
            //     // var pvm = context.read<PersonViewModel>();
            //     // var person = pvm.personWithKnownFor.person;
            //     // goToFilmographyPage(
            //     //     context, person!.id, person.name, person.combinedCredits);
            //   }),
            // ),
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
        return SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          sliver: SliverStack(
            children: [
              /// This serves as the base card on which the content card is
              /// stacked. The fill constructor helps match its height with
              /// the height of the content card.
              SliverPositioned.fill(
                child: Container(
                  color: Colors.white,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    getSliverSeparator(context),
                    if (tuple.item1.isNotEmpty)
                      getSectionTitleRow(tuple.item1.length > _maxCount, () {}),
                    if (tuple.item1.isNotEmpty)
                      CastListView<Cast>(
                        tuple.item1.take(_maxCount).toList(),
                        MediaQuery.of(context).size.width,
                      ),
                    // if (tuple.item2.isNotEmpty)
                    //   CastListView<Crew>(
                    //     tuple.item2,
                    //     MediaQuery.of(context).size.width,
                    //   ),
                    if (tuple.item2.isNotEmpty)
                      getCrewSection(context, tuple.item2),
                    getSliverSeparator(context),
                  ],
                ),
              ),
            ],
          ),
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

    if (directors.isEmpty && writers.isEmpty) return const SizedBox.shrink();

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

  Widget getSliverSeparator(BuildContext context) => Container(
        height: 1.0,
        color: Theme.of(context).primaryColorLight,
      );

  Widget getSectionTitleRow(bool showSeeAll, Function()? onPressed) => Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Top billed cast' /*.toUpperCase()*/,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                // height: 1.1,
              ),
            ),
            // if (showSeeAll) CompactTextButton('All cast', onPressed: onPressed),
          ],
        ),
      );
}

class CastListView<T extends BaseCredit> extends StatelessWidget
    with Utilities, CommonFunctions {
  final List<T> casts;
  final double screenWidth;

  CastListView(this.casts, this.screenWidth, {Key? key}) : super(key: key);

  final separatorWidth = 10.0;

  final listViewHorizontalPadding = 16.0;

  final listViewVerticalPadding = 16.0;

  final cardCount = 2.5;

  late final deductibleWidth =
      listViewHorizontalPadding + separatorWidth * cardCount.toInt();

  late final posterWidth = (screenWidth - deductibleWidth) / cardCount;

  final aspectRatio = Constants.arProfile / 0.87;

  late final posterHeight = posterWidth / aspectRatio;

  final maxLines = 2;

  final textHorizPadding = 8.0;

  final nameTopPadding = 8.0;

  final nameBottomPadding = 0.0;

  final characterTopPadding = 0.0;

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

  final topRadius = 4.0;

  final bottomRadius = 0.0;

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

  late final cardHeight =
      posterHeight + nameContainerHeight + characterContainerHeight;

  late final viewHeight = cardHeight + listViewVerticalPadding * 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      height: viewHeight,
      child: ListView.separated(
        // primary: false,
        itemBuilder: (_, index) {
          var cast = casts[index];
          return Stack(
            children: [
              Card(
                surfaceTintColor: Colors.white,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(topRadius),
                ),
                margin: EdgeInsets.zero,
                child: SizedBox(
                  width: posterWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NetworkImageView(
                        cast.profilePath,
                        imageType: ImageType.profile,
                        aspectRatio: aspectRatio,
                        topRadius: topRadius,
                        bottomRadius: bottomRadius,
                        fit: BoxFit.fitWidth,
                        heroImageTag: '${cast.id}',
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          textHorizPadding,
                          nameTopPadding,
                          textHorizPadding,
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
                          textHorizPadding,
                          characterTopPadding,
                          textHorizPadding,
                          characterBottomPadding,
                        ),
                        // height: characterContainerHeight,
                        child: Text(
                          cast is Cast ? cast.character : (cast as Crew).job,
                          maxLines: maxLines,
                          overflow: TextOverflow.ellipsis,
                          style: characterStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(topRadius),
                    onTap: () {
                      goToPersonPage(context, cast);
                    },
                  ),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (_, index) => SizedBox(width: separatorWidth),
        padding: EdgeInsets.symmetric(
          horizontal: listViewHorizontalPadding,
          vertical: listViewVerticalPadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: casts.length,
      ),
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

/// Deprecated in favour of [ImagesSection]
@Deprecated('Deprecated in favour of ImagesSection')
class _ImagesSection extends StatelessWidget with GenericFunctions {
  const _ImagesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MovieViewModel, List<ImageDetail>>(
      selector: (_, mvm) => mvm.images ?? [],
      builder: (_, images, __) {
        // logIfDebug('tagged:$taggedImages');
        if (images.isEmpty) {
          return SliverToBoxAdapter(child: Container());
        } else {
          return BaseSectionSliver(
            title: 'Images',
            children: [
              ImageCardListView(
                images,
                screenWidth: MediaQuery.of(context).size.width,
              ),
              // Container(
              //   alignment: Alignment.center,
              //   padding: const EdgeInsets.only(bottom: 8.0),
              //   child: CompactTextButton('All images', onPressed: () {}),
              // ),
            ],
          );
        }
      },
    );
  }
}

class KeywordsSection extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final int _maxCount = 10;

  const KeywordsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MovieViewModel, Tuple2<List<Keyword>, int>>(
      selector: (_, mvm) => Tuple2(
        mvm.keywords.take(_maxCount).toList(),
        mvm.keywords.length,
      ),
      builder: (_, tuple, __) {
        if (tuple.item2 == 0) {
          return SliverToBoxAdapter(child: Container());
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          sliver: SliverStack(
            children: [
              /// This serves as the base card on which the content card is
              /// stacked. The fill constructor helps match its height with
              /// the height of the content card.
              SliverPositioned.fill(
                child: Container(
                  color: Colors.white,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    getSliverSeparator(context),
                    getSectionTitleRow(tuple.item2 > _maxCount, () {}),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 8.0,
                        runSpacing: 10.0,
                        children: tuple.item1.map((e) {
                          return InkWellOverlay(
                            onTap: () {
                              goToMovieListPage(
                                context,
                                mediaType: MediaType.movie,
                                keywords: [e],
                                genres: context
                                    .read<MovieViewModel>()
                                    .media
                                    ?.genres,
                              );
                            },
                            borderRadius: BorderRadius.circular(6.0),
                            child: Chip(
                              backgroundColor: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(0.17),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              label: Text(
                                e.name.toProperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              side: BorderSide(
                                color: Theme.of(context).primaryColorDark,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    getSliverSeparator(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getSliverSeparator(BuildContext context) => Container(
        height: 1.0,
        color: Theme.of(context).primaryColorLight,
      );

  Widget getSectionTitleRow(bool showSeeAll, Function()? onPressed) => Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Keywords' /*.toUpperCase()*/,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                // height: 1.1,
              ),
            ),
            if (showSeeAll) CompactTextButton('See all', onPressed: onPressed),
          ],
        ),
      );
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
        return SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          sliver: SliverStack(
            children: [
              /// This serves as the base card on which the content card is
              /// stacked. The fill constructor helps match its height with
              /// the height of the content card.
              SliverPositioned.fill(
                child: Container(
                  color: Colors.white,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    getSliverSeparator(context),
                    getSectionTitleRow(tuple.item1.length > _maxCount, () {}),
                    ReviewsListView(
                      tuple.item1.take(_maxCount).toList(),
                      MediaQuery.of(context).size.width,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child:
                          CompactTextButton('Write a review', onPressed: () {}),
                    ),
                    getSliverSeparator(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getSliverSeparator(BuildContext context) => Container(
        height: 1.0,
        color: Theme.of(context).primaryColorLight,
      );

  Widget getSectionTitleRow(bool showSeeAll, Function()? onPressed) => Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'User reviews' /*.toUpperCase()*/,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                // height: 1.1,
              ),
            ),
            if (showSeeAll) CompactTextButton('See all', onPressed: onPressed),
          ],
        ),
      );
}

class ReviewsListView extends StatelessWidget with GenericFunctions {
  final List<Review> reviews;
  final double screenWidth;

  ReviewsListView(this.reviews, this.screenWidth, {Key? key}) : super(key: key);

  final separatorWidth = 10.0;

  final listViewHorizontalPadding = 16.0;

  final listViewVerticalPadding = 16.0;

  final cardCount = 1.25;

  late final deductibleWidth = listViewHorizontalPadding +
      separatorWidth * (cardCount > 1 ? cardCount.toInt() : 0);

  late final sectionWidth = (screenWidth - deductibleWidth) / cardCount;

  final aspectRatio = Constants.arAvatar;

  late final posterHeight = sectionWidth / aspectRatio;

  final avatarSize = 50.0;

  final maxLines = 12;

  final textHorizPadding = 16.0;

  final ratingVertPadding = 8.0;

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
    fontSize: 16.0,
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

  late final ratingContainerHeight = ratingIconSize + ratingVertPadding * 2;

  late final cardHeight = authorContainerHeight +
      /*posterHeight + nameContainerHeight + */ reviewContainerHeight +
      ratingContainerHeight;

  /// This 0.8 is being to escape the "A RenderFlex overflowed by 0.800
  /// pixels on the bottom." error. The error is being caused by not
  /// assigning any height to the name and character test widgets.
  /// However, assigning height, especially to name text widget makes it
  /// expand to two lines no matter if name is actually on one line only,
  /// thereby showing an extra blank line between home snd tasks.
  late final viewHeight = cardHeight + listViewVerticalPadding * 2 /* + 0.8*/;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      height: viewHeight,
      child: ListView.separated(
        itemBuilder: (_, index) {
          var review = reviews[index];
          return Card(
            surfaceTintColor: Colors.white,
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(topRadius),
            ),
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () {
                logIfDebug('Card clicked');
              },
              child: SizedBox(
                width: sectionWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(authorVerticalPadding),
                      child: SizedBox(
                        // width: avatarSize,
                        height: avatarSize,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWellOverlay(
                              onTap: () {
                                logIfDebug('Avatar clicked');
                              },
                              borderRadius: BorderRadius.circular(avatarSize),
                              child: NetworkImageView(
                                review.authorDetails.avatarPath,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (review.authorDetails.rating != null)
                          getRatingRow(review.authorDetails.rating!.toInt()),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                            textHorizPadding,
                            reviewTopPadding,
                            textHorizPadding,
                            reviewBottomPadding,
                          ),
                          height: reviewContainerHeight,
                          child: Text(
                            review.content,
                            maxLines: maxLines,
                            overflow: TextOverflow.ellipsis,
                            style: reviewTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, index) => SizedBox(width: separatorWidth),
        padding: EdgeInsets.symmetric(
          horizontal: listViewHorizontalPadding,
          vertical: listViewVerticalPadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: reviews.length,
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
              )));
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: textHorizPadding,
        vertical: ratingVertPadding,
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
  BuildContext? _context;

  late final double iconSize = extent * 0.30;

  final Map<String, ThumbnailType> thumbMap;

  final PageController controller = PageController();

  final double radius = 0.0;

  final int delay = 7000;

  final double fraction = 1.0 /*0.88*/;

  ImageDelegate(/*this.baseUrl, */this.extent, this.thumbMap);

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
        child: Image.network(
          context.read<ConfigViewModel>().getImageUrl(
                ImageType.backdrop,
                ImageQuality.high,
                entry.key,
              ),
          fit: BoxFit.fill,
          errorBuilder: (_, __, ___) {
            return Icon(
              Icons.error_outline_sharp,
              size: extent * 0.30,
            );
          },
        ),
      );
    } else {
      return Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image.network(
              getThumbnailUrl(entry.key),
              fit: BoxFit.fill,
            ),
          ),
          IconButton(
            onPressed: () {
              // _context!.read<YoutubeViewModel>().currentKey = entry.key;
              // _context!.read<YoutubeViewModel>().reset();
              // _context!.read<MovieViewModel>().isTrailerPinned = true;
              _context!.read<MovieViewModel>().initialVideoId = entry.key;
            },
            icon: Icon(
              Icons.play_circle_outline_sharp,
              color: Colors.white,
              size: iconSize,
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
  final String initialVideoId;
  final List<String> youtubeKeys;

  TrailerDelegate({
    required this.extent,
    required this.initialVideoId,
    required this.youtubeKeys,
  });

  late final child = TrailerView(
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
