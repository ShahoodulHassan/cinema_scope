import 'package:cinema_scope/pages/person_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tuple/tuple.dart';

import '../architecture/config_view_model.dart';
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
                    ExpandableSynopsis(widget.overview),
                    buildGenresAndLinks(),
                  ],
                ),
              ),
            ),
          ),
          const ImagesSection<TvViewModel>(),
          const _MediaInfoSection(),
          const RecommendationsSection<Tv, TvViewModel>(),
          // const ReviewsSection(),
          const MoreByDirectorSection<Tv, TvViewModel>(),
          const MoreByLeadActorSection<Tv, TvViewModel>(),
          const MoreByGenresSection<Tv, TvViewModel>(),
          const KeywordsSection(),
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
          tvm.years,
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
                // goToMovieListPage(
                //   context,
                //   genres: [genre],
                // );
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

class KeywordsSection extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final int _maxCount = 10;

  const KeywordsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TvViewModel, Tuple2<List<Keyword>, int>>(
      selector: (_, tvm) => Tuple2(
        tvm.keywords.take(_maxCount).toList(),
        tvm.keywords.length,
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
                              // goToMovieListPage(
                              //   context,
                              //   keywords: [e],
                              //   genres: context
                              //       .read<MovieViewModel>()
                              //       .movie
                              //       ?.genres,
                              // );
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