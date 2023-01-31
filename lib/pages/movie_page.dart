import 'package:card_swiper/card_swiper.dart';
import 'package:cinema_scope/architecture/movie_view_model.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/image_view.dart';
import 'package:cinema_scope/widgets/route_aware_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

class _MoviePageChildState extends RouteAwareState<_MoviePageChild>
    with GenericFunctions, Utilities {
  late final String? sourceUrl = widget.sourceUrl;
  late final String? destUrl = widget.destUrl;
  late final String heroImageTag = widget.heroImageTag;

  late String backdropBaseUrl;

  TrailerDelegate? trailerDelegate;

  late final MovieViewModel mvm;

  @override
  void initState() {
    super.initState();
    mvm = context.read<MovieViewModel>()..getMovieWithDetail(widget.id);
    final cvm = context.read<ConfigViewModel>();
    String base = cvm.apiConfig!.images.baseUrl;
    String size = cvm.apiConfig!.images.backdropSizes[1];
    backdropBaseUrl = '$base$size';
  }

  @override
  void deactivate() {
    logIfDebug('deactivate called for ${widget.title}');
    super.deactivate();
  }

  @override
  void dispose() {
    logIfDebug('dispose called for ${widget.title}');
    super.dispose();
  }

  @override
  void didPush() {
    logIfDebug('didPush called for ${widget.title}');
    super.didPush();
  }

  @override
  void didPushNext() {
    logIfDebug('didPushNext called for ${widget.title}');
    super.didPushNext();
  }

  @override
  void didPop() {
    logIfDebug('didPop called for ${widget.title}');
    super.didPop();
  }

  @override
  void didPopNext() {
    logIfDebug('didPopNext called for ${widget.title}');
    super.didPopNext();
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
                    backdropBaseUrl,
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
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Row(
                      children: [
                        Visibility(
                          visible:
                              widget.year != null && widget.year!.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              widget.year ?? '',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.voteAverage > 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star_sharp,
                                  size: 22.0,
                                  color: Constants.ratingIconColor,
                                ),
                                Text(
                                  ' ${applyCommaAndRound(widget.voteAverage, 1, false, true)}'
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
                          ),
                        ),
                        Selector<MovieViewModel, int?>(
                          builder: (_, runtime, __) {
                            return runtime == null
                                ? const SizedBox.shrink()
                                : Text(
                                    runtimeToString(runtime),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      // fontWeight: FontWeight.bold,
                                      // fontStyle: FontStyle.italic,
                                    ),
                                  );
                          },
                          selector: (_, mvm) => mvm.movie?.runtime,
                        ),
                      ],
                    ),
                  ),
                  Selector<MovieViewModel, String?>(
                    builder: (_, tagline, __) {
                      return tagline == null || tagline.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 8.0, 16.0, 8.0),
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
                    selector: (_, mvm) => mvm.movie?.tagline,
                  ),
                  ExpandableSynopsis(widget.overview),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Selector<MovieViewModel, Movie?>(
              selector: (_, mvm) => mvm.movie,
              builder: (_, movie, __) {
                logIfDebug('builder called with movie:$movie');
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getGenres(movie),
                  ],
                );
              },
            ),
          ),
          const CastCrewSection(),
          const ReviewsSection(),
          const RecommendedMoviesSection(),
          const KeywordsSection(),
        ],
      ),
    );
  }

  Padding getGenres(Movie? movie) {
    final genres = movie?.genres;
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          separatorBuilder: (_, index) => const SizedBox(width: 8),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            final genre = genres?[index];
            if (genre != null) {
              return InkWellOverlay(
                onTap: () {},
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
            } else {
              return const SizedBox.shrink();
            }
          },
          itemCount: genres?.length ?? 0,
        ),
      ),
    );
  }
}

class CastCrewSection extends StatelessWidget {
  final int _maxCount = 10;

  const CastCrewSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MovieViewModel, Tuple2<List<Cast>, List<Crew>>>(
      selector: (_, mvm) => Tuple2(mvm.casts, mvm.crew),
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
                      CastListView(
                        tuple.item1.take(_maxCount).toList(),
                        MediaQuery.of(context).size.width,
                      ),
                    if (tuple.item2.isNotEmpty) getCrewSection(tuple.item2),
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

  Widget getCrewSection(List<Crew> crew) {
    /// We show only directors and co-directors, each sorted alphabetically.
    /// Co-directors will have their job mentioned with their names.
    var directors = (crew.where((element) => element.job == 'Director').toList()
          ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()))) +
        (crew
                .where((element) => element.job.toLowerCase() == 'co-director')
                .toList()
              ..sort((a, b) =>
                  a.name.toLowerCase().compareTo(b.name.toLowerCase())))
            .map((e) => e.copyWith(name: '${e.name} (${e.job})'))
            .toList();

    /// We show all crew from the department 'writing'
    var writers = (crew
        .where((element) => element.department.toLowerCase() == 'writing')
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())));

    if (directors.isEmpty && writers.isEmpty) return const SizedBox.shrink();

    Map<int, Set<Crew>> crewMap = {};
    for (var writer in writers) {
      crewMap.putIfAbsent(writer.id, () => {}).add(writer);
    }

    /// We join the jobs of a crew member and append those with his name.
    /// However, if there is only one job and that is 'Writer', we don't append
    /// it because, the label of this section already tells us that writers are
    /// shown therein.
    var combinedWriters = <Crew>[];
    for (var id in crewMap.keys) {
      var writer = crewMap[id]!.first;
      var jobs = crewMap[id]!.map((e) => e.job).toList();
      var jobSuffix = jobs.length == 1 && jobs.first == 'Writer'
          ? ''
          : ' (${jobs.join(', ')})';
      combinedWriters.add(writer.copyWith(name: '${writer.name}$jobSuffix'));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          getCrewTile(directors, 'Director'),
          getCrewTile(combinedWriters, 'Writer'),
          CompactTextButton('All cast & crew', () {}),
        ],
      ),
    );
  }

  Widget getCrewTile(List<Crew> crew, String label) {
    if (crew.isEmpty) return const SizedBox.shrink();
    var names = crew.map((e) => e.name).toSet().join(', ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print('Crew clicked');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$label${crew.length > 1 ? 's' : ''}',
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
              'Top billed cast' /*.toUpperCase()*/,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                // height: 1.1,
              ),
            ),
            if (showSeeAll) CompactTextButton('All cast', onPressed),
          ],
        ),
      );
}

class CastListView extends StatelessWidget {
  final List<Cast> casts;
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

  late final nameHeight = nameStyle.height! * nameStyle.fontSize! * maxLines;

  late final characterHeight =
      characterStyle.height! * characterStyle.fontSize! * maxLines;

  late final nameContainerHeight =
      nameHeight + nameTopPadding + nameBottomPadding;

  late final characterContainerHeight =
      characterHeight + characterTopPadding + characterBottomPadding;

  late final cardHeight =
      posterHeight + nameContainerHeight + characterContainerHeight;

  /// This 0.8 is being to escape the "A RenderFlex overflowed by 0.800
  /// pixels on the bottom." error. The error is being caused by not
  /// assigning any height to the name and character test widgets.
  /// However, assigning height, especially to name text widget makes it
  /// expand to two lines no matter if name is actually on one line only,
  /// thereby showing an extra blank line between home snd tasks.
  late final viewHeight = cardHeight + listViewVerticalPadding * 2 + 0.8;

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
                          cast.character,
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => MoviePage(
                      //         id: movie.id,
                      //         title: movie.movieTitle,
                      //         year: getYearStringFromDate(movie.releaseDate),
                      //         voteAverage: movie.voteAverage,
                      //         overview: movie.overview,
                      //         sourceUrl: imageUrlToId[movie.id]?[0],
                      //         destUrl: imageUrlToId[movie.id]?[1],
                      //         heroImageTag:
                      //         '${widget.sectionTitle}-image-${movie.id}'),
                      //   ),
                      // );
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

class RecommendedMoviesSection extends StatelessWidget
    with Utilities, GenericFunctions {
  const RecommendedMoviesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MovieViewModel, Tuple2<List<MovieResult>, int>>(
      selector: (_, mvm) {
        return Tuple2(mvm.recommendations, mvm.totalRecomCount);
      },
      builder: (_, tuple, __) {
        var recommendations = tuple.item1;
        if (recommendations.isEmpty) {
          return SliverToBoxAdapter(child: Container());
        } else {
          // final totalCount = recommendations.length;
          // final remainder = totalCount % _itemsPerPage;
          // itemCount = totalCount < _itemsPerPage
          //     ? totalCount
          //     : totalCount ~/ _itemsPerPage * _itemsPerPage +
          //         (remainder > _itemsPerRow ? remainder : 0);
          return SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            sliver: SliverStack(
              insetOnOverlap: false,
              children: [
                /// This serves as the base card on which the content card is
                /// stacked. The fill constructor helps match its height with
                /// the height of the content card.
                const SliverPositioned.fill(
                  child: Card(
                    elevation: 5.0,
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    margin: EdgeInsets.zero,
                    shape: ContinuousRectangleBorder(),
                  ),
                ),
                RecommendedMoviesView(tuple.item1, tuple.item2),
              ],
            ),
          );
        }
      },
    );
  }
}

class RecommendedMoviesView extends StatelessWidget {
  final List<MovieResult> recommendations;
  final int totalRecomCount;
  final int _itemsPerRow = 3;
  final int _rowCount = 2;

  int get _itemsPerPage => _itemsPerRow * _rowCount;

  /// Below variables make sure that if more than one page worth of
  /// recommendations are available, a page is shown only if its has two rows of
  /// movies. That's because in case there are less movies on a page such that
  /// only one row can be shown, the GridView squeezes to one row for that page
  /// and that's not a good user XP.
  /// However, if there are only one page worth of recommendations, they will
  /// be shown no matter if shown on only one row. We are not worried about a
  /// squeezing GridView because the user gets to see only one page.
  late final _totalCount = recommendations.length;
  late final _remainder = _totalCount % _itemsPerPage;
  late final _itemCount = _totalCount < _itemsPerPage
      ? _totalCount
      : _totalCount ~/ _itemsPerPage * _itemsPerPage +
          (_remainder > _itemsPerRow ? _remainder : 0);
  late final _pageCount = recommendations.length ~/ _itemsPerPage +
      (_remainder > _itemsPerRow ? 1 : 0);

  RecommendedMoviesView(
    this.recommendations,
    this.totalRecomCount, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        getSectionTitleRow(_itemCount, totalRecomCount),
        SliverPosterGrid(
          recommendations,
          itemsPerRow: _itemsPerRow,
          itemsPerPage: _itemsPerPage,
          pageCount: _pageCount,
        ),
        // SliverPosterGridSwiper`(recommendations),
      ],
    );
  }

  SliverToBoxAdapter getSectionTitleRow(int itemCount, int totalRecomCount) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recommendations' /*.toUpperCase()*/,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                // height: 1.1,
              ),
            ),
            if (totalRecomCount > itemCount)
              CompactTextButton('See all', () {}),
          ],
        ),
      ),
    );
  }
}

class SliverPosterGrid extends StatelessWidget with Utilities {
  final int itemsPerRow;
  final int itemsPerPage;
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

  final List<MovieResult> _recommendations;
  final int pageCount;

  late final _remainder = _recommendations.length % itemsPerPage;

  late final _pageCount = _recommendations.length ~/ itemsPerPage +
      (_remainder > itemsPerRow ? 1 : 0);

  final _topPadding = 16.0;
  final _bottomPadding = 16.0;
  final _leftPadding = 16.0;

  final _mainAxisSpacing = 5.0;
  final _crossAxisSpacing = 5.0;

  SliverPosterGrid(
    this._recommendations, {
    required this.itemsPerRow,
    required this.itemsPerPage,
    required this.pageCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MovieViewModel, int>(
      selector: (_, mvm) => mvm.recomPageIndex,
      builder: (_, index, __) {
        return MultiSliver(
          children: [
            getGridView(getListForPage(_recommendations, index)),
            if (_pageCount > 1) getPageNavigationView(index, context),
          ],
        );
      },
    );
  }

  SliverToBoxAdapter getPageNavigationView(int index, BuildContext context) {
    final mvm = context.read<MovieViewModel>();
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CompactTextButton('PREV',
                  index > 0 ? () => mvm.recomPageIndex = index - 1 : null),
            ),
            Text(
              '${index + 1} / $_pageCount',
              style: const TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CompactTextButton(
                  'NEXT',
                  index < (_pageCount - 1)
                      ? () => mvm.recomPageIndex = index + 1
                      : null),
            ),
          ],
        ),
      ),
    );
  }

  Widget getGridView(List<MovieResult> titles) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: _leftPadding,
        right: _leftPadding,
        top: _topPadding,
        bottom: _bottomPadding,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: itemsPerRow,
          childAspectRatio: _aspectRatio,
          mainAxisSpacing: _mainAxisSpacing,
          crossAxisSpacing: _crossAxisSpacing,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
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
          childCount: titles.length,
        ),
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
    return list.skip(itemsPerPage * index).take(itemsPerPage).toList();
  }
}

class KeywordsSection extends StatelessWidget with GenericFunctions {
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
                              logIfDebug('${e.name} clicked');
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
            if (showSeeAll) CompactTextButton('See all', onPressed),
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
                      child: CompactTextButton('Write a review', () {}),
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
            if (showSeeAll) CompactTextButton('See all', onPressed),
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
                            Padding(
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
  final String baseUrl;
  final double extent;
  BuildContext? _context;

  late final double iconSize = extent * 0.30;

  final Map<String, ThumbnailType> thumbMap;

  final PageController controller = PageController();

  final double radius = 4.0;

  final int delay = 7000;

  final double fraction = 0.88;

  ImageDelegate(this.baseUrl, this.extent, this.thumbMap);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    logIfDebug('isPinned, extent:$extent');
    _context ??= context;
    return extent == 0
        ? const SizedBox.shrink()
        : Swiper(
            itemBuilder: (_, index) => getView(index),
            autoplay: true,
            itemCount: thumbMap.length,
            indicatorLayout: PageIndicatorLayout.SCALE,
            autoplayDelay: delay,
            // transformer: ScaleAndFadeTransformer(),
            viewportFraction: fraction,
            scale: fraction + 0.04,
            fade: 0.7,
            pagination: const SwiperPagination(),
            // itemWidth: MediaQuery.of(context).size.width,
          );
  }

  Widget getView(int index) {
    var entry = thumbMap.entries.elementAt(index);
    if (entry.value == ThumbnailType.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
          '$baseUrl${entry.key}',
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

  List<Widget> getViews() {
    var views = <Widget>[];
    for (int i = 0; i < thumbMap.length; i++) {
      views.add(getView(i));
      // if (entry.value == ThumbnailType.image) {
      //   views.add(
      //     Image.network('$baseUrl${entry.key}', fit: BoxFit.fill),
      //   );
      // } else {
      //   views.add(
      //     Stack(
      //       fit: StackFit.expand,
      //       children: [
      //         Image.network(getThumbnailUrl(entry.key), fit: BoxFit.fill),
      //         IconButton(
      //           onPressed: () {
      //             _context!.read<MovieViewModel>().isTrailerPinned = true;
      //           },
      //           icon: Icon(
      //             Icons.play_circle_outline_sharp,
      //             color: Colors.white,
      //             size: iconSize,
      //           ),
      //         ),
      //       ],
      //     ),
      //   );
      // }
    }
    return views;
  }

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

  late final child = TrailerViewProvider(
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
