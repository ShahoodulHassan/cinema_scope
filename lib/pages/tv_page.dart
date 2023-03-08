import 'package:cinema_scope/pages/person_page.dart';
import 'package:cinema_scope/pages/tv_credits_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tuple/tuple.dart';

import '../architecture/config_view_model.dart';
import '../architecture/movie_view_model.dart';
import '../architecture/tv_view_model.dart';
import '../constants.dart';
import '../models/configuration.dart';
import '../models/movie.dart';
import '../models/tv.dart';
import '../utilities/common_functions.dart';
import '../utilities/generic_functions.dart';
import '../utilities/utilities.dart';
import '../widgets/compact_text_button.dart';
import '../widgets/expandable_synopsis.dart';
import '../widgets/image_view.dart';
import '../widgets/ink_well_overlay.dart';
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
              ChangeNotifierProvider(create: (_) => TvViewModel()),
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
  late final TvViewModel tvm;

  final animDuration = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    tvm = context.read<TvViewModel>()
      ..getTvWithDetail(
        widget.id,
        context.read<ConfigViewModel>().combinedGenres,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getScaffoldColor(context),
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
          Selector<TvViewModel,
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
          Selector<TvViewModel, String?>(
            selector: (_, tvm) => tvm.initialVideoId,
            builder: (_, id, __) {
              if (id != null && id.isNotEmpty) {
                return SliverPinnedHeader(
                  child: StreamersView<Tv, TvViewModel>(id: widget.id),
                );
              } else {
                return SliverToBoxAdapter(
                  child: StreamersView<Tv, TvViewModel>(id: widget.id),
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
                          fontWeight: FontWeight.bold,
                          height: 1.1,
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
          const ImagesSection<TvViewModel>(),
          const _MediaInfoSection(),
          const RecommendationsSection<Tv, TvViewModel>(),
          // const ReviewsSection(),
          const MoreByDirectorSection<Tv, TvViewModel>(),
          const MoreByLeadActorSection<Tv, TvViewModel>(),
          const MoreByGenresSection<Tv, TvViewModel>(),
          const KeywordsSection<Tv, TvViewModel>(),
        ],
      ),
    );
  }

  Widget buildYearRow() {
    return AnimatedSize(
      duration: animDuration,
      child: Selector<TvViewModel, Tuple2<String?, double?>>(
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
      child: Selector<TvViewModel, Tuple2<int?, int?>>(
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
      child: Selector<TvViewModel, String?>(
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
      child: Selector<TvViewModel, Tuple3<String?, String?, List<Genre>?>>(
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
                          context,
                          const Icon(FontAwesomeIcons.imdb),
                          () => openUrlString(
                            '${Constants.imdbTitleUrl}$imdbId',
                          ),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      if (homepage.isNotEmpty)
                        getIconButton(
                          context,
                          (homepage.contains('netflix')
                              ? Image.asset(
                                  'assets/icons/icons8_netflix_24.png',
                                  color: Theme.of(context).primaryColorDark,
                                )
                              : const Icon(Icons.link)),
                          () => openUrlString(homepage),
                          color: Theme.of(context).colorScheme.primary,
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
    return Selector<TvViewModel, Tuple2<List<TvCast>, List<TvCrew>>>(
      selector: (_, tvm) => Tuple2(tvm.cast, tvm.creators ?? []),
      builder: (_, tuple, __) {
        if (tuple.item1.isEmpty && tuple.item2.isEmpty) {
          return SliverToBoxAdapter(child: Container());
        }
        return BaseSectionSliver(
          title: 'Top billed cast',
          children: [
            if (tuple.item1.isNotEmpty)
              _CastListView<TvCast>(
                tuple.item1.take(_maxCount).toList(),
                MediaQuery.of(context).size.width,
              ),
            if (tuple.item2.isNotEmpty)
              getCrewSection(context, tuple.item2,
                  'Creator${tuple.item2.length > 1 ? 's' : ''}'),
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
        children: [
          getCreatorsTile(context, creators, label),
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
                  fontWeight: FontWeight.bold,
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
    var tvm = context.read<TvViewModel>();
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return TvCreditsPage(
        title: title,
        credits: credits ?? tvm.media!.aggregateCredits,
        id: tvm.media!.id,
        name: tvm.media!.name,
      );
    }));
  }

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

class _CastListView<T extends BaseTvCredit> extends StatelessWidget
    with Utilities, CommonFunctions {
  final List<T> credits;
  final double screenWidth;

  _CastListView(this.credits, this.screenWidth, {Key? key}) : super(key: key);

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

  final episodeMaxLines = 1;

  final textHorizPadding = 8.0;

  // final nameTopPadding = 8.0;
  //
  // final nameBottomPadding = 0.0;
  //
  // final characterTopPadding = 0.0;
  //
  // final characterBottomPadding = 8.0;

  final descriptionVertPadding = 8.0;

  final nameStyle = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  final characterStyle = const TextStyle(
    fontSize: 14.0,
    height: 1.2,
  );

  final episodeStyle = const TextStyle(
    fontSize: 14.0,
    height: 1.8,
    color: Colors.black54,
  );

  final topRadius = 4.0;

  final bottomRadius = 0.0;

  /// This offset is being added to escape the "A RenderFlex overflowed by 0.200
  /// pixels on the bottom." error. Seems like every line has this height offset
  /// of 0.2.
  final lineOffset = 0.2;

  late final nameHeight = nameStyle.height! * nameStyle.fontSize! * maxLines +
      (maxLines * lineOffset);

  late final characterHeight =
      characterStyle.height! * characterStyle.fontSize! * maxLines +
          (maxLines * lineOffset);

  late final episodeHeight =
      episodeStyle.height! * episodeStyle.fontSize! * episodeMaxLines +
          (episodeMaxLines * lineOffset);

  // late final nameContainerHeight =
  //     nameHeight + nameTopPadding + nameBottomPadding;
  //
  // late final characterContainerHeight =
  //     characterHeight + characterTopPadding + characterBottomPadding;

  late final descriptionContainerHeight =
      nameHeight + characterHeight + episodeHeight + descriptionVertPadding * 2;

  late final cardHeight =
      posterHeight + /*nameContainerHeight + characterContainerHeight*/
          descriptionContainerHeight;

  late final viewHeight = cardHeight + listViewVerticalPadding * 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      height: viewHeight,
      child: ListView.separated(
        // primary: false,
        itemBuilder: (_, index) {
          var person = credits[index];
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
                        person.profilePath,
                        imageType: ImageType.profile,
                        aspectRatio: aspectRatio,
                        topRadius: topRadius,
                        bottomRadius: bottomRadius,
                        fit: BoxFit.fitWidth,
                        heroImageTag: '${person.id}',
                      ),
                      Padding(
                        padding: EdgeInsets.all(descriptionVertPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              person.name,
                              maxLines: maxLines,
                              overflow: TextOverflow.ellipsis,
                              style: nameStyle,
                            ),
                            Text(
                              (person is TvCast
                                  ? person.roles
                                      .map((e) => e.character)
                                      .join(', ')
                                  : (person as TvCrew)
                                      .jobs
                                      .map((e) => e.job)
                                      .join(', ')),
                              maxLines: maxLines,
                              overflow: TextOverflow.ellipsis,
                              style: characterStyle,
                            ),
                            Text(
                              '${person.totalEpisodeCount} episode${person.totalEpisodeCount > 1 ? 's' : ''}',
                              maxLines: episodeMaxLines,
                              overflow: TextOverflow.ellipsis,
                              style: episodeStyle,
                            ),
                          ],
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
                      goToPersonPage(context, person);
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
        itemCount: credits.length,
      ),
    );
  }
}

class _MediaInfoSection extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  const _MediaInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TvViewModel, Tv?>(
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
        .read<ConfigViewModel>()
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
