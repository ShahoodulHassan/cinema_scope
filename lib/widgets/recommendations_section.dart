import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../architecture/config_view_model.dart';
import '../architecture/movie_view_model.dart';
import '../constants.dart';
import '../models/movie.dart';
import '../models/search.dart';
import '../models/tv.dart';
import '../utilities/common_functions.dart';
import '../utilities/generic_functions.dart';
import '../utilities/utilities.dart';
import 'base_section_sliver.dart';
import 'compact_text_button.dart';
import 'image_view.dart';

class RecommendationsSection<M extends Media, T extends MediaViewModel<M>>
    extends StatelessWidget with Utilities, CommonFunctions, GenericFunctions {
  const RecommendationsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<T, RecommendationData?>(
      selector: (_, mvm) => mvm.recommendationData,
      builder: (_, data, __) {
        if (data == null || data.totalResults == 0) {
          return SliverToBoxAdapter(child: Container());
        } else {
          final bool isMovie = M.toString() == (Movie).toString();
          const int itemsPerRow = 3;
          const int rowCount = 2;
          int itemsPerPage = itemsPerRow * rowCount;

          final totalCount = data.recommendations.length;
          final remainder = totalCount % itemsPerPage;
          final itemCount = totalCount < itemsPerPage
              ? totalCount
              : totalCount ~/ itemsPerPage * itemsPerPage +
                  (remainder > itemsPerRow ? remainder : 0);
          return BaseSectionSliver(
            title: 'Recommendations',
            showSeeAll: data.totalResults > itemCount,
            onPressed: () {
              var mediaType = isMovie ? MediaType.movie : MediaType.tv;
              goToMediaListPage(
                context,
                mediaType: mediaType,
                mediaId: data.mediaId,
              );
            },
            children: [
              _PosterGrid<M, T>(
                data.recommendations,
                itemsPerRow,
                itemsPerPage,
                remainder,
              ),
            ],
          );
          // return SliverPadding(
          //   padding: const EdgeInsets.symmetric(vertical: 12.0),
          //   sliver: SliverStack(
          //     insetOnOverlap: false,
          //     children: [
          //       /// This serves as the base card on which the content card is
          //       /// stacked. The fill constructor helps match its height with
          //       /// the height of the content card.
          //       const SliverPositioned.fill(
          //         child: Card(
          //           elevation: 5.0,
          //           color: Colors.white,
          //           surfaceTintColor: Colors.white,
          //           margin: EdgeInsets.zero,
          //           shape: ContinuousRectangleBorder(),
          //         ),
          //       ),
          //       _RecommendationsView<M, T>(
          //         data.mediaId,
          //         data.recommendations,
          //         data.totalResults,
          //       ),
          //     ],
          //   ),
          // );
        }
      },
    );
  }
}

class _PosterGrid<M extends Media, T extends MediaViewModel<M>>
    extends StatelessWidget with Utilities, CommonFunctions {
  final List<CombinedResult> _recommendations;
  final int _itemsPerRow;
  final int _itemsPerPage;
  final int _remainder;

  /// Below variable makes sure that if more than one page worth of
  /// recommendations are available, a page is shown only if its has two rows of
  /// movies. That's because in case there are less movies on a page such that
  /// only one row can be shown, the GridView squeezes to one row for that page
  /// and that's not a good user XP.
  /// However, if there are only one page worth of recommendations, they will
  /// be shown no matter if shown on only one row. We are not worried about a
  /// squeezing GridView because the user gets to see only one page.
  late final int _pageCount = _recommendations.length ~/ _itemsPerPage +
      (_remainder > _itemsPerRow ? 1 : 0);

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

  final _topPadding = 16.0;
  final _bottomPadding = 16.0;
  final _leftPadding = 16.0;

  final _mainAxisSpacing = 5.0;
  final _crossAxisSpacing = 5.0;

  _PosterGrid(
      this._recommendations,
      this._itemsPerRow,
      this._itemsPerPage,
      this._remainder, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<T, int>(
      selector: (_, mvm) => mvm.recomPageIndex,
      builder: (_, index, __) {
        return Column(
          children: [
            getGridView(getListForPage(_recommendations, index)),
            if (_pageCount > 1) getPageNavigationView(index, context),
          ],
        );
      },
    );
  }

  Widget getPageNavigationView(int index, BuildContext context) {
    final mvm = context.read<T>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CompactTextButton(
              'PREV',
              onPressed:
              (index > 0 ? () => mvm.recomPageIndex = index - 1 : null),
            ),
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
            child: CompactTextButton('NEXT',
                onPressed: (index < (_pageCount - 1)
                    ? () => mvm.recomPageIndex = index + 1
                    : null)),
          ),
        ],
      ),
    );
  }

  Widget getGridView(List<CombinedResult> titles) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _itemsPerRow,
        childAspectRatio: _aspectRatio,
        mainAxisSpacing: _mainAxisSpacing,
        crossAxisSpacing: _crossAxisSpacing,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(
        left: _leftPadding,
        right: _leftPadding,
        top: _topPadding,
        bottom: _bottomPadding,
      ),
      itemCount: titles.length,
      itemBuilder: (context, index) {
        final media = titles[index];
        final destUrl = media.backdropPath == null
            ? null
            : context.read<ConfigViewModel>().getImageUrl(
          ImageType.backdrop,
          ImageQuality.high,
          media.backdropPath!,
        );
        return Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
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
          getImageView(titles, index, context, media, destUrl),
          // Text(getYearStringFromDate(media.releaseDate), style: textStyle,),
          //   ],
          // ),
        );
      },
      // delegate: SliverChildBuilderDelegate(
      //       (context, index) {
      //     final media = titles[index];
      //     final destUrl = media.backdropPath == null
      //         ? null
      //         : context.read<ConfigViewModel>().getImageUrl(
      //         ImageType.backdrop, ImageQuality.high, media.backdropPath!);
      //     return Card(
      //       color: Colors.white,
      //       surfaceTintColor: Colors.white,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: _borderRadius,
      //       ),
      //       elevation: 6.0,
      //       // Margins had to be tweaked a bit in order to
      //       // remove the whitespace around the image.
      //       margin: const EdgeInsets.fromLTRB(1.5, 2.5, 1.8, 2.5),
      //       child:
      //       // Column(
      //       //   children: [
      //       getImageView(titles, index, context, media, destUrl),
      //       // Text(getYearStringFromDate(media.releaseDate), style: textStyle,),
      //       //   ],
      //       // ),
      //     );
      //   },
      //   childCount: titles.length,
      // ),
    );
  }

  Widget getImageView(List<CombinedResult> similarTitles, int index,
      BuildContext context, CombinedResult media, String? destUrl) {
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
                if (M.toString() == (Movie).toString()) {
                  goToMoviePage(
                    context,
                    id: media.id,
                    title: media.mediaTitle,
                    releaseDate: media.releaseDate,
                    overview: media.overview,
                    voteAverage: media.voteAverage,
                    destUrl: destUrl,
                  );
                } else if (M.toString() == (Tv).toString()) {
                  goToTvPage(
                    context,
                    id: media.id,
                    title: media.mediaTitle,
                    releaseDate: media.releaseDate,
                    overview: media.overview,
                    voteAverage: media.voteAverage,
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  List<CombinedResult> getListForPage(List<CombinedResult> list, int index) {
    return list.skip(_itemsPerPage * index).take(_itemsPerPage).toList();
  }
}

class _RecommendationsView<M extends Media, T extends MediaViewModel<M>>
    extends StatelessWidget with Utilities, CommonFunctions {
  final int mediaId;
  final List<CombinedResult> recommendations;
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
  late final _pageCount =
      _totalCount ~/ _itemsPerPage + (_remainder > _itemsPerRow ? 1 : 0);

  final bool isMovie = M.toString() == (Movie).toString();

  _RecommendationsView(
    this.mediaId,
    this.recommendations,
    this.totalRecomCount, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        getSectionTitleRow(context, _itemCount, totalRecomCount),
        _SliverPosterGrid<M, T>(
          recommendations,
          itemsPerRow: _itemsPerRow,
          itemsPerPage: _itemsPerPage,
          pageCount: _pageCount,
        ),
        // SliverPosterGridSwiper`(recommendations),
      ],
    );
  }

  SliverToBoxAdapter getSectionTitleRow(
    BuildContext context,
    int itemCount,
    int totalRecomCount,
  ) {
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
              CompactTextButton('See all', onPressed: () {
                var mediaType = isMovie ? MediaType.movie : MediaType.tv;
                goToMediaListPage(
                  context,
                  mediaType: mediaType,
                  mediaId: mediaId,
                );
                // goToMovieListPage(context, mediaId: movieId);
              }),
          ],
        ),
      ),
    );
  }
}

class _SliverPosterGrid<M extends Media, T extends MediaViewModel<M>>
    extends StatelessWidget with Utilities, CommonFunctions {
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

  final List<CombinedResult> _recommendations;
  final int pageCount;

  late final _remainder = _recommendations.length % itemsPerPage;

  late final _pageCount = _recommendations.length ~/ itemsPerPage +
      (_remainder > itemsPerRow ? 1 : 0);

  final _topPadding = 16.0;
  final _bottomPadding = 16.0;
  final _leftPadding = 16.0;

  final _mainAxisSpacing = 5.0;
  final _crossAxisSpacing = 5.0;

  _SliverPosterGrid(
    this._recommendations, {
    required this.itemsPerRow,
    required this.itemsPerPage,
    required this.pageCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<T, int>(
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
    final mvm = context.read<T>();
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CompactTextButton('PREV',
                  onPressed: (index > 0
                      ? () => mvm.recomPageIndex = index - 1
                      : null)),
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
              child: CompactTextButton('NEXT',
                  onPressed: (index < (_pageCount - 1)
                      ? () => mvm.recomPageIndex = index + 1
                      : null)),
            ),
          ],
        ),
      ),
    );
  }

  Widget getGridView(List<CombinedResult> titles) {
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
            final media = titles[index];
            final destUrl = media.backdropPath == null
                ? null
                : context.read<ConfigViewModel>().getImageUrl(
                    ImageType.backdrop, ImageQuality.high, media.backdropPath!);
            return Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
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
                  getImageView(titles, index, context, media, destUrl),
              // Text(getYearStringFromDate(media.releaseDate), style: textStyle,),
              //   ],
              // ),
            );
          },
          childCount: titles.length,
        ),
      ),
    );
  }

  Widget getImageView(List<CombinedResult> similarTitles, int index,
      BuildContext context, CombinedResult media, String? destUrl) {
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
                if (M.toString() == (Movie).toString()) {
                  goToMoviePage(
                    context,
                    id: media.id,
                    title: media.mediaTitle,
                    releaseDate: media.releaseDate,
                    overview: media.overview,
                    voteAverage: media.voteAverage,
                    destUrl: destUrl,
                  );
                } else if (M.toString() == (Tv).toString()) {
                  goToTvPage(
                    context,
                    id: media.id,
                    title: media.mediaTitle,
                    releaseDate: media.releaseDate,
                    overview: media.overview,
                    voteAverage: media.voteAverage,
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  List<CombinedResult> getListForPage(List<CombinedResult> list, int index) {
    return list.skip(itemsPerPage * index).take(itemsPerPage).toList();
  }
}
