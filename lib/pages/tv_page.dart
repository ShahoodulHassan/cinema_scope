import 'package:cinema_scope/pages/person_page.dart';
import 'package:cinema_scope/pages/tv_credits_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tuple/tuple.dart';

import '../providers/configuration_provider.dart';
import '../providers/movie_provider.dart';
import '../providers/tv_provider.dart';
import '../constants.dart';
import '../main.dart';
import '../models/configuration.dart';
import '../models/movie.dart';
import '../models/tv.dart';
import '../utilities/common_functions.dart';
import '../utilities/generic_functions.dart';
import '../utilities/utilities.dart';
import '../widgets/base_section_sliver.dart';
import '../widgets/compact_text_button.dart';
import '../widgets/expandable_synopsis.dart';
import '../widgets/frosted_app_bar.dart';
import '../widgets/image_view.dart';
import '../widgets/recommendations_section.dart';
import 'media_details_page.dart';
import 'movie_page.dart';

class TvPage extends MultiProvider {
  TvPage({
    super.key,
    required int id,
    required String title,
    required String? year,
    required double voteAverage,
    required String? overview,
    required String heroImageTag,
  }) : super(
            providers: [
              ChangeNotifierProvider(create: (_) => TvProvider()),
              // ChangeNotifierProvider(create: (_) => YoutubeViewModel()),
            ],
            child: _TvPageChild(
              id,
              title,
              year,
              voteAverage,
              overview,
              heroImageTag,
            ));
}

class _TvPageChild extends StatefulWidget {
  final int id;

  final String title, heroImageTag;
  final String? year, overview;
  final double voteAverage;

  const _TvPageChild(
    this.id,
    this.title,
    this.year,
    this.voteAverage,
    this.overview,
    this.heroImageTag, {
    Key? key,
  }) : super(key: key);

  @override
  State<_TvPageChild> createState() => _TvPageChildState();
}

class _TvPageChildState extends State<_TvPageChild>
    with GenericFunctions, Utilities, CommonFunctions {
  late final TvProvider tvm;

  final animDuration = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    tvm = context.read<TvProvider>()
      ..getTvWithDetail(
        widget.id,
        context.read<ConfigurationProvider>().combinedGenres,
      );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.sizeOf(context).width > 750
        ? buildLandscapeView()
        : buildPortraitView();
  }

  Widget buildLandscapeView() {
    return Row(
      children: [
        SizedBox(
          width: 390.0,
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverFrostedAppBar(
                  title: Text(
                    widget.title,
                    style:
                        Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                              fontSize: 18.0,
                            ),
                  ),
                  actions: [
                    IconButton(
                      tooltip: 'Search',
                      onPressed: () => openSearchPage(context),
                      icon: const Icon(Icons.search_rounded),
                    ),
                  ],
                  leading: BackButton(
                    style: IconButton.styleFrom(
                      iconSize: 22.0,
                    ),
                  ),
                  toolbarHeight: 40.0,
                  pinned: true,
                ),
                Selector<TvProvider,
                    Tuple3<List<String>, Map<String, ThumbnailType>, String?>>(
                  builder: (_, tuple, __) {
                    logIfDebug('isPinned, thumbnails:$tuple');
                    var height = 390.0 * 9 / 16;
                    if (tuple.item3 != null && tuple.item1.isNotEmpty) {
                      return SliverPersistentHeader(
                        delegate: TrailerDelegate(
                          mediaType: MediaType.tv,
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
                          mediaType: MediaType.tv,
                          extent: tuple.item2.isEmpty ? 0 : height,
                          thumbMap: tuple.item2,
                        ),
                        pinned: false,
                      );
                    }
                  },
                  selector: (_, mvm) {
                    logIfDebug(
                        'isPinned, selector called with:${mvm.youtubeKeys}');
                    return Tuple3<List<String>, Map<String, ThumbnailType>,
                        String?>(
                      mvm.youtubeKeys,
                      mvm.thumbMap,
                      mvm.initialVideoId,
                    );
                  },
                ),
                Selector<TvProvider, String?>(
                  selector: (_, tvm) => tvm.initialVideoId,
                  builder: (_, id, __) {
                    return SliverToBoxAdapter(
                      child: StreamersView<Tv, TvProvider>(id: widget.id),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildGenresAndLinks(),
                      ],
                    ),
                  ),
                ),
                const _MediaInfoSection(),
                const KeywordsSection<Tv, TvProvider>(),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          ),
        ),
        Expanded(
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                const SliverFrostedAppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 0.0,
                  pinned: true,
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
                              fontWeight: FontWeightExt.semibold,
                              height: 1.2,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        buildYearRow(),
                        buildEpisodesRow(context),
                        buildTagline(),
                        ExpandableSynopsis(
                          widget.overview,
                          changeSize: false,
                        ),
                      ],
                    ),
                  ),
                ),
                const _CastCrewSection(),
                const SimilarTitlesSection<Tv, TvProvider>(),
                const RecommendationsSection<Tv, TvProvider>(),
                const MoreByDirectorSection<Tv, TvProvider>(),
                const MoreByLeadActorSection<Tv, TvProvider>(),
                const ImagesSection<TvProvider>(),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPortraitView() {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: CustomScrollView(
        slivers: [
          SliverFrostedAppBar.withSubtitle(
            title: Text(widget.title),
            pinned: true,
            actions: [
              IconButton(
                tooltip: 'Search',
                onPressed: () => openSearchPage(context),
                icon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
          Selector<TvProvider,
              Tuple3<List<String>, Map<String, ThumbnailType>, String?>>(
            builder: (_, tuple, __) {
              logIfDebug('isPinned, thumbnails:$tuple');
              var height = MediaQuery.of(context).size.width * 9 / 16;
              if (tuple.item3 != null && tuple.item1.isNotEmpty) {
                return SliverPersistentHeader(
                  delegate: TrailerDelegate(
                    mediaType: MediaType.tv,
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
                    mediaType: MediaType.tv,
                    extent: tuple.item2.isEmpty ? 0 : height,
                    thumbMap: tuple.item2,
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
          Selector<TvProvider, String?>(
            selector: (_, tvm) => tvm.initialVideoId,
            builder: (_, id, __) {
              if (id != null && id.isNotEmpty) {
                return SliverPinnedHeader(
                  child: StreamersView<Tv, TvProvider>(id: widget.id),
                );
              } else {
                return SliverToBoxAdapter(
                  child: StreamersView<Tv, TvProvider>(id: widget.id),
                );
              }
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
                          fontWeight: FontWeightExt.semibold,
                          height: 1.2,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    buildYearRow(),
                    buildEpisodesRow(context),
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
          ),
          const _CastCrewSection(),
          const SimilarTitlesSection<Tv, TvProvider>(),
          const RecommendationsSection<Tv, TvProvider>(),
          const MoreByDirectorSection<Tv, TvProvider>(),
          const MoreByLeadActorSection<Tv, TvProvider>(),
          const ImagesSection<TvProvider>(),
          const _MediaInfoSection(),
          // const ReviewsSection(),
          const KeywordsSection<Tv, TvProvider>(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget buildYearRow() {
    return AnimatedSize(
      duration: animDuration,
      child: Selector<TvProvider, Tuple2<String?, double?>>(
        builder: (_, tuple, __) {
          var year = tuple.item1 ?? '';
          var voteAverage = tuple.item2 ?? 0.0;
          if (year.isEmpty && voteAverage == 0.0) {
            return const SizedBox.shrink();
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: Row(
                children: [
                  if (year.isNotEmpty) buildYear(year),
                  if (voteAverage > 0.0) buildRating(voteAverage),
                ],
              ),
            );
          }
        },
        selector: (_, tvm) => Tuple2<String?, double?>(
          tvm.year,
          tvm.voteAverage,
        ),
      ),
    );
  }

  Widget buildEpisodesRow(BuildContext context) {
    return AnimatedSize(
      duration: animDuration,
      child: Selector<TvProvider, Tuple2<int?, int?>>(
        builder: (_, tuple, __) {
          var seasonCount = tuple.item1 ?? 0;
          var epiCount = tuple.item2 ?? 0;
          var seasons = '$seasonCount season${seasonCount > 1 ? 's' : ''}';
          var episodes = '$epiCount episode${epiCount > 1 ? 's' : ''}';
          if (seasonCount == 0 && epiCount == 0) {
            return const SizedBox.shrink();
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: Row(
                children: [
                  buildYear('$seasons, $episodes'),
                  // if (voteAverage > 0.0) buildRating(voteAverage),
                ],
              ),
            );
          }
        },
        selector: (_, tvm) => Tuple2<int?, int?>(
          tvm.media?.numberOfSeasons,
          tvm.media?.numberOfEpisodes,
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
            fontWeight: FontWeightExt.semibold,
            // fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  AnimatedSize buildTagline() {
    return AnimatedSize(
      duration: animDuration,
      child: Selector<TvProvider, String?>(
        builder: (_, tagline, __) {
          return tagline == null || tagline.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
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
        selector: (_, tvm) => tvm.tagline,
      ),
    );
  }

  AnimatedSize buildGenresAndLinks() {
    return AnimatedSize(
      duration: animDuration,
      child: Selector<TvProvider, Tuple3<String?, String?, List<Genre>?>>(
        selector: (_, tvm) => Tuple3<String?, String?, List<Genre>>(
          tvm.imdbId,
          tvm.homepage,
          tvm.genres,
        ),
        builder: (_, tuple, __) {
          logIfDebug('builder called with tv:$tuple');
          var imdbId = tuple.item1 ?? '';
          var homepage = tuple.item2 ?? '';
          var genres = tuple.item3 ?? [];
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (genres.isNotEmpty) getGenreView<Tv>(genres),
              if (imdbId.isNotEmpty || homepage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (imdbId.isNotEmpty)
                        getIconButton(
                          const Icon(FontAwesomeIcons.imdb),
                          () => openImdbParentalGuide(
                            '${Constants.imdbTitleUrl}$imdbId',
                            prefersDeepLink: true,
                          ),
                          color: kPrimary,
                        ),
                      if (homepage.isNotEmpty)
                        getIconButton(
                          (homepage.contains('netflix')
                              ? Image.asset(
                                  'assets/icons/icons8_netflix_24.png',
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : const Icon(Icons.link)),
                          () => openImdbParentalGuide(
                            homepage,
                            prefersDeepLink: true,
                          ),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      if (imdbId.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4.0),
                            onTap: () => openImdbParentalGuide(
                              '${Constants.imdbTitleUrl}$imdbId/parentalguide',
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 4.0,
                              ),
                              child: Text(
                                'iMDb PG',
                                style: TextStyle(
                                  color: kPrimary,
                                  fontWeight: FontWeightExt.semibold,
                                  height: 1.2,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ),
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

// Widget getIconButton(Widget icon, Function() onPressed) => IconButton(
//       onPressed: onPressed,
//       icon: icon,
//       iconSize: 24.0,
//       color: Theme.of(context).primaryColorDark,
//       // padding: EdgeInsets.zero,
//       // visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
//     );

// /// This method expects a non-empty list of genres
// Widget getGenreView(List<Genre> genres) {
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
//                 mediaType: MediaType.tv,
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

class _CastCrewSection extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final int _maxCount = 10;

  const _CastCrewSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TvProvider, Tuple3<List<TvCast>, int, List<TvCrew>>>(
      selector: (_, tvm) =>
          Tuple3(tvm.cast, tvm.crew.length, tvm.creators ?? []),
      builder: (_, tuple, __) {
        final crewCount = tuple.item2;
        if (tuple.item1.isEmpty && crewCount == 0) {
          return SliverToBoxAdapter(child: Container());
        }
        return BaseSectionSliver(
          title: 'Top billed cast',
          showSeeAll: crewCount == 0,
          onPressed: () => goToCreditsPage(context),
          children: [
            if (tuple.item1.isNotEmpty)
              _TvCastPosterListView(
                items: tuple.item1.take(_maxCount).toList(),
              ),
            if (crewCount > 0)
              getCrewSection(context, tuple.item3,
                  'Creator${tuple.item3.length > 1 ? 's' : ''}'),
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
        //             if (tuple.item1.isNotEmpty)
        //               getSectionTitleRow(tuple.item1.length > _maxCount, () {}),
        //             if (tuple.item1.isNotEmpty)
        //               _CastListView<TvCast>(
        //                 tuple.item1.take(_maxCount).toList(),
        //                 MediaQuery.of(context).size.width,
        //               ),
        //             // if (tuple.item2.isNotEmpty)
        //             //   CastListView<Crew>(
        //             //     tuple.item2,
        //             //     MediaQuery.of(context).size.width,
        //             //   ),
        //             if (tuple.item2.isNotEmpty)
        //               getCrewSection(context, tuple.item2,
        //                   'Creator${tuple.item2.length > 1 ? 's' : ''}'),
        //             // getCrewSection(context, tuple.item2),
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

  Widget getCrewSection(
      BuildContext context, List<TvCrew> creators, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (creators.isNotEmpty) getCreatorsTile(context, creators, label),
          CompactTextButton('Full cast & crew', onPressed: () {
            goToCreditsPage(context);
          }),
        ],
      ),
    );
  }

  Widget getCreatorsTile(
      BuildContext context, List<TvCrew> creators, String label) {
    if (creators.isEmpty) return const SizedBox.shrink();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (creators.length == 1) {
            goToPersonPage(context, creators.first);
          } else {
            goToCreditsPage(
              context,
              title: label,
              credits: AggregateCredits([], creators),
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
                  fontWeight: FontWeightExt.semibold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                creators.map((e) => e.name).join(', '),
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
    AggregateCredits? credits,
    String? title,
  }) {
    var tvm = context.read<TvProvider>();
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return TvCreditsPage(
        title: title,
        credits: credits ?? tvm.media!.aggregateCredits,
        id: tvm.media!.id,
        name: tvm.media!.name,
      );
    }));
  }
}

class _TvCastPosterListView extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final List<TvCast> items;
  final double posterWidth;
  final double radius;

  final titleContainerPadding = 8.0;

  late final titleFontSize = 14.0;

  final titleLineHeight = 1.2;

  final aspectRatio = Constants.arProfile / 0.87;

  final maxLines = 2;

  final episodeMaxLines = 1;

  late final yearFontSize = titleFontSize;

  final listViewTopPadding = 16.0;

  final listViewHorizontalPadding = 16.0 - Constants.cardMargin;

  final nameTopPadding = 8.0;

  final characterVerticalPadding = 6.0;

  final episodeBottomPadding = 8.0;

  final nameStyle = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeightExt.semibold,
    height: 1.2,
  );

  final characterStyle = const TextStyle(
    fontSize: 14.0,
    height: 1.2,
  );

  final episodeStyle = const TextStyle(
    fontSize: 14.0,
    height: 1.2,
    color: Colors.black54,
  );

  /// This addition of 0.2 (per line) is required in order to avoid the "A
  /// RenderFlex overflowed by 0.800 pixels on the bottom." error
  late final nameHeight =
      (nameStyle.height! * nameStyle.fontSize! + 0.2) * maxLines;

  late final characterHeight =
      (characterStyle.height! * characterStyle.fontSize! + 0.2) * maxLines;

  late final episodeHeight =
      (episodeStyle.height! * episodeStyle.fontSize! + 0.2) * episodeMaxLines;

  late final nameContainerHeight = nameHeight + nameTopPadding;

  late final characterContainerHeight =
      characterHeight + characterVerticalPadding * 2;

  late final episodeContainerHeight = episodeHeight + episodeBottomPadding;

  _TvCastPosterListView({
    required this.items,
    this.posterWidth = 140.0,
    this.radius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');
    final posterHeight = (posterWidth - Constants.cardMargin * 2) / aspectRatio;

    final listViewHeight = posterHeight +
        nameContainerHeight +
        characterContainerHeight +
        episodeContainerHeight +
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
    TvCast cast, {
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
                  0.0,
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
                  characterVerticalPadding,
                  titleContainerPadding,
                  characterVerticalPadding,
                ),
                // height: characterContainerHeight,
                child: Text(
                  cast.roles.map((e) => e.character).join(', '),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: characterStyle,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  titleContainerPadding,
                  0.0,
                  titleContainerPadding,
                  episodeBottomPadding,
                ),
                // height: episodeContainerHeight,
                child: Text(
                  '${cast.totalEpisodeCount} episode${cast.totalEpisodeCount > 1 ? 's' : ''}',
                  maxLines: episodeMaxLines,
                  overflow: TextOverflow.ellipsis,
                  style: episodeStyle,
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
    return Selector<TvProvider, Tv?>(
      builder: (_, tv, __) {
        if (tv == null) {
          return SliverToBoxAdapter(child: Container());
        } else {
          return BaseSectionSliver(
            title: 'TV Series details',
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 16.0,
                ),
                child: Column(
                  children: getMediaDetailSections(tv, context),
                ),
              )
            ],
          );
        }
      },
      selector: (_, tvm) => tvm.media,
    );
  }

  List<Widget> getMediaDetailSections(Tv tv, BuildContext context) {
    var releaseDate = getReadableDate(tv.firstAirDate);
    var nextEpisode = tv.nextEpisodeToAir;
    var status = tv.status;
    var language = context
        .read<ConfigurationProvider>()
        .cfgLanguages
        .firstWhere((element) => element.iso6391 == tv.originalLanguage)
        .englishName;
    return [
      getSubSection('Release date', releaseDate.isEmpty ? '-' : releaseDate),
      getSubSection('Status', status.isEmpty ? '-' : status),
      if (nextEpisode != null)
        getSubSection('Next episode', getEpisodeText(nextEpisode)),
      getSubSection('Original language', language.isEmpty ? '-' : language,
          onTap: tv.spokenLanguages.length <= 1
              ? null
              : () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return MediaSubDetailsPage<LanguageConfig>(
                        list: tv.spokenLanguages,
                        title: 'Spoken languages',
                        name: tv.name);
                  }));
                }),
      if (tv.productionCountries.isNotEmpty)
        getSubSection('Produced in', tv.productionCountries.first.name,
            onTap: tv.productionCountries.length <= 1
                ? null
                : () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return MediaSubDetailsPage<ProductionCountry>(
                          list: tv.productionCountries,
                          title: 'Production countries',
                          name: tv.name);
                    }));
                  }),
      if (tv.productionCompanies.isNotEmpty)
        getSubSection('Production by', tv.productionCompanies.first.name,
            onTap: tv.productionCompanies.length <= 1
                ? null
                : () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return MediaSubDetailsPage<ProductionCompany>(
                          list: tv.productionCompanies,
                          title: 'Production companies',
                          name: tv.name);
                    }));
                  }),
    ];
  }

  String getEpisodeText(TvEpisode nextEpisode) {
    var s = nextEpisode.seasonNumber;
    var e = nextEpisode.episodeNumber;
    var line1 = '${s <= 9 ? 'S0$s' : 'S$s'} ${e <= 9 ? 'E0$e' : 'E$e'}';
    var line2 = getReadableDate(nextEpisode.airDate);
    return '$line1${line2.isEmpty ? '' : '  |  $line2'}';
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

// class KeywordsSection extends StatelessWidget
//     with GenericFunctions, Utilities, CommonFunctions {
//   final int _maxCount = 10;
//
//   const KeywordsSection({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Selector<TvViewModel, Tuple2<List<Keyword>, int>>(
//       selector: (_, tvm) => Tuple2(
//         tvm.keywords.take(_maxCount).toList(),
//         tvm.keywords.length,
//       ),
//       builder: (_, tuple, __) {
//         if (tuple.item2 == 0) {
//           return SliverToBoxAdapter(child: Container());
//         }
//         return SliverPadding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0),
//           sliver: SliverStack(
//             children: [
//               /// This serves as the base card on which the content card is
//               /// stacked. The fill constructor helps match its height with
//               /// the height of the content card.
//               SliverPositioned.fill(
//                 child: Container(
//                   color: Colors.white,
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     getSliverSeparator(context),
//                     getSectionTitleRow(tuple.item2 > _maxCount, () {}),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 16.0, horizontal: 16.0),
//                       child: Wrap(
//                         alignment: WrapAlignment.start,
//                         spacing: 8.0,
//                         runSpacing: 10.0,
//                         children: tuple.item1.map((e) {
//                           return InkWellOverlay(
//                             onTap: () {
//                               goToMediaListPage(
//                                 context,
//                                 mediaType: MediaType.tv,
//                                 keywords: [e],
//                                 genres:
//                                     context.read<TvViewModel>().media?.genres,
//                               );
//                             },
//                             borderRadius: BorderRadius.circular(6.0),
//                             child: buildKeywordChip(context, e),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     getSliverSeparator(context),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget getSliverSeparator(BuildContext context) => Container(
//         height: 1.0,
//         color: Theme.of(context).primaryColorLight,
//       );
//
//   Widget getSectionTitleRow(bool showSeeAll, Function()? onPressed) => Padding(
//         padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Keywords' /*.toUpperCase()*/,
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1.5,
//                 // height: 1.1,
//               ),
//             ),
//             if (showSeeAll) CompactTextButton('See all', onPressed: onPressed),
//           ],
//         ),
//       );
// }
