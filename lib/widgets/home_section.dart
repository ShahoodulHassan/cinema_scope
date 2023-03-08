import 'dart:math';

import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../architecture/config_view_model.dart';
import '../architecture/home_view_model.dart';
import '../constants.dart';
import '../models/movie.dart';
import '../models/search.dart';
import '../utilities/generic_functions.dart';
import '../utilities/utilities.dart';

enum SectionTitle {
  nowPlaying('NOW PLAYING'),
  trending('TRENDING'),
  latest('LATEST'),
  popular('POPULAR'),
  topRated('TOP RATED'),
  upcoming('COMING SOON'),
  streaming('STREAMING'),
  freeToWatch('FREE TO WATCH');

  final String name;

  const SectionTitle(this.name);
}

class BaseHomeSection extends StatelessWidget with Utilities, CommonFunctions {
  final String title;
  final List<Widget> children;

  final bool showSeeAll;
  final Function()? onPressed;
  final String buttonText;

  const BaseHomeSection({
    required this.title,
    required this.children,
    this.showSeeAll = false,
    this.buttonText = 'See all',
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36.0),
      child: Stack(
        children: [
          /// This serves as the base card on which the content card is
          /// stacked. The fill constructor helps match its height with
          /// the height of the content card.
          const Positioned.fill(
            child: Card(
              elevation: 5.0,
              color: Colors.white,
              surfaceTintColor: Colors.white,
              margin: EdgeInsets.zero,
              shape: ContinuousRectangleBorder(),
            ),
          ),
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                getSectionSeparator(context),
                getSectionTitleRow(),
                ...children,
                getSectionSeparator(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget getSeparator(BuildContext context) => Container(
  //       height: 1.0,
  //       color: Theme.of(context).primaryColorLight,
  //     );

  Widget getSectionTitleRow() => Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            // height: 1.1,
          ),
        ),
        // if (showSeeAll) CompactTextButton(buttonText, onPressed: onPressed),
      ],
    ),
  );
}

class HomeSection extends StatefulWidget {
  final SectionTitle sectionTitle;
  final bool isBigWidget;
  final MediaType? mediaType;
  final TimeWindow? timeWindow;
  final List<String> params;
  final List<String>? paramTitles;

  const HomeSection(
    this.sectionTitle, {
    this.mediaType,
    this.timeWindow,
    this.params = const <String>[],
    this.paramTitles,
    Key? key,
    this.isBigWidget = false,
  }) : super(key: key);

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection>
    with GenericFunctions, Utilities, CommonFunctions {
  late final HomeViewModel hvm;

  @override
  void initState() {
    super.initState();
    hvm = context.read<HomeViewModel>();
    getResult(
      widget.sectionTitle,
    );
  }

  void getResult(
    SectionTitle sectionTitle, {
    String? param,
  }) {
    var values = sectionTitle == SectionTitle.trending
        ? TimeWindow.values
        : MediaType.values;
    var value = param == null
        ? null
        : values.singleWhere((element) => element.name == param);
    switch (sectionTitle) {
      case SectionTitle.nowPlaying:
        hvm.getNowPlaying(value as MediaType?);
        break;
      case SectionTitle.trending:
        hvm.getTrending(timeWindow: value as TimeWindow?);
        break;
      case SectionTitle.latest:
        hvm.getLatestMovies(value as MediaType?);
        break;
      case SectionTitle.popular:
        hvm.getPopularMovies(value as MediaType?);
        break;
      case SectionTitle.topRated:
        hvm.getTopRatedMovies(value as MediaType?);
        break;
      case SectionTitle.upcoming:
        hvm.getDiscoverUpcoming(value as MediaType?);
        break;
      case SectionTitle.streaming:
        hvm.getStreamingMedia(value as MediaType?);
        break;
      case SectionTitle.freeToWatch:
        hvm.getFreeMedia(value as MediaType?);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<HomeViewModel, CombinedResults?>(
      selector: (_, hvm) => hvm.getResultBySectionTitle(widget.sectionTitle),
      builder: (_, result, __) {
        if (result == null) {
          return const SizedBox.shrink();
        } else {
          return BaseHomeSection(
            title: widget.sectionTitle.name,
            children: [
              if (widget.params.isNotEmpty)
                Selector<HomeViewModel, String?>(
                  selector: (_, hvm) =>
                      hvm.sectionParamMap[widget.sectionTitle],
                  builder: (_, param, __) {
                    if (param == null) {
                      return const SizedBox.shrink();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                        child: ToggleButtons(
                          constraints: const BoxConstraints(
                              minWidth: 0.0, minHeight: 0.0),
                          borderRadius: BorderRadius.circular(16.0),
                          borderColor: Theme.of(context).colorScheme.primary,
                          // selectedColor: Theme.of(context).primaryColorDark,
                          // fillColor: Theme.of(context).primaryColorLight.withOpacity(0.2),
                          // highlightColor: Theme.of(context).primaryColor.withOpacity(0.5),
                          selectedBorderColor:
                          Theme.of(context).colorScheme.primary,
                          borderWidth: 0.5,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          isSelected: widget.params.map((e) {
                            return e == param;
                          }).toList(),
                          onPressed: (index) {
                            getResult(
                              widget.sectionTitle,
                              param: widget.params[index],
                            );
                          },
                          children: [
                            ...(widget.paramTitles ?? widget.params).map((e) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 5.0),
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }
                  },
                ),
              HomeListView(
                sectionTitle: widget.sectionTitle,
                results: result.results,
              ),
            ],
          );
        }
      },
    );
  }
}

class HomeListView extends StatefulWidget {
  final SectionTitle sectionTitle;
  final List<CombinedResult> results;
  final bool isBigWidget;

  const HomeListView({
    required this.sectionTitle,
    required this.results,
    this.isBigWidget = false,
    Key? key,
  }) : super(key: key);

  @override
  State<HomeListView> createState() => _HomeListViewState();
}

class _HomeListViewState extends State<HomeListView>
    with GenericFunctions, Utilities, CommonFunctions {
  final smallFactor = 2.20;
  final bigFactor = 1.0;
  final titleContainerPadding = 8.0;
  late final titleFontSize = widget.isBigWidget ? 18.0 : 16.0;
  final titleLineHeight = 1.2;
  late final titleLines = widget.isBigWidget ? 1 : 2;
  late final yearFontSize = titleFontSize - 4.0;
  final listViewVerticalPadding = 16.0;
  final listViewBottomPadding = 24.0;
  final listViewHorizontalPadding = 16.0;
  late final ratingIconSize = widget.isBigWidget ? 24.0 : 20.0;
  late final ratingFontSize = widget.isBigWidget ? 18.0 : 16.0;
  final separatorWidth = 10.0;
  final borderWidth = 0.7;

  late final sizeFactorInt = sizeFactor.toInt();
  late final totalBorderWidth =
      (sizeFactorInt * 2 + (sizeFactor > sizeFactorInt ? 1 : 0)) * borderWidth;

  late final sizeFactor = widget.isBigWidget ? bigFactor : smallFactor;
  late final screenWidth = MediaQuery.of(context).size.width;
  late final deductibleWidth = listViewHorizontalPadding +
      separatorWidth * sizeFactorInt +
      totalBorderWidth;
  late final posterWidth = (screenWidth - deductibleWidth) / sizeFactor;
  late final posterHeight = posterWidth /
      (widget.isBigWidget ? Constants.arBackdrop : Constants.arPoster);

  late final isUpcoming = widget.sectionTitle == SectionTitle.upcoming;
  late final isLatest = widget.sectionTitle == SectionTitle.latest;

  late final titleStyle = TextStyle(
    // fontWeight: FontWeight.bold,
    fontSize: titleFontSize,
    height: titleLineHeight,
  );

  late final yearStyle = TextStyle(
    // fontWeight: FontWeight.normal,
    fontSize: yearFontSize,
    height: 1.0,
  );

  late final ratingStyle = TextStyle(
    // fontWeight: FontWeight.normal,
    fontSize: ratingFontSize,
    height: 1.0,
  );

  late final titleTextHeight =
      titleStyle.height! * titleStyle.fontSize! * titleLines;

  late final yearTextHeight = yearStyle.height! * yearStyle.fontSize! * 1;

  late final ratingTextHeight = ratingStyle.height! * ratingStyle.fontSize! * 1;

  late final titleContainerHeight = titleTextHeight + titleContainerPadding * 2;

  late final ratingContainerHeight =
      max(ratingTextHeight, ratingIconSize) + titleContainerPadding;

  late final yearContainerHeight = yearTextHeight + titleContainerPadding;

  late final cardHeight = posterHeight +
      titleContainerHeight +
      listViewVerticalPadding + listViewBottomPadding +
      (isUpcoming || isLatest ? 0 : ratingContainerHeight) +
      yearContainerHeight;

  Map<int, List<String?>> imageUrlToId = {};

  @override
  Widget build(BuildContext context) {
    logIfDebug(
        'width:${MediaQuery.of(context).size.width}, deductible:$deductibleWidth, borderWidth: $totalBorderWidth');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: screenWidth,
          height: cardHeight,
          child: ListView.separated(
            // shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
                listViewHorizontalPadding,
                listViewVerticalPadding, listViewHorizontalPadding, listViewBottomPadding),
            itemBuilder: (_, index) {
              var movie = widget.results[index];
              if (index == 0) {
                logIfDebug('${widget.sectionTitle.name} '
                    'count:${widget.results.length}');
              }

              /// Have to stack the InkWell on top of the Card to make the
              /// splash work, when there is an image in the card.
              return getSectionItem(movie);
            },
            scrollDirection: Axis.horizontal,
            itemCount: widget.results.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: separatorWidth);
            },
          ),
        ),
      ],
    );
  }

  Stack getSectionItem(CombinedResult media) {
    return Stack(
      children: [
        Card(
          surfaceTintColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            // side: BorderSide(
            //   color: Theme.of(context).primaryColorDark,
            //   width: borderWidth,
            // ),
          ),
          margin: EdgeInsets.zero,

          /// Wrapping in a width constraint is essential
          child: SizedBox(
            width: posterWidth,
            // height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  child: getImageView(media),
                ),
                getRatingWidget(media),
                Container(
                  // alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      vertical: titleContainerPadding,
                      horizontal: titleContainerPadding),
                  height: titleContainerHeight,

                  /// \n\n ensures that the text is always 3 lines
                  /// long
                  child: Text(
                    '${media.mediaTitle}\n\n',
                    // textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: titleLines,
                    style: titleStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: titleContainerPadding,
                      right: titleContainerPadding,
                      left: titleContainerPadding),
                  child: Text(
                    isUpcoming
                        ? getReadableDate(media.mediaReleaseDate)
                        : getYearStringFromDate(media.mediaReleaseDate),
                    style: yearStyle,
                    maxLines: 1,
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                logIfDebug(
                    'onTap called for:${media.mediaTitle}, type:${media.mediaType}');
                if (media.mediaType == MediaType.movie.name) {
                  goToMoviePage(
                    context,
                    id: media.id,
                    title: media.mediaTitle,
                    releaseDate: media.mediaReleaseDate,
                    voteAverage: media.voteAverage,
                    overview: media.overview,
                  );
                } else if (media.mediaType == MediaType.tv.name) {
                  goToTvPage(
                    context,
                    id: media.id,
                    title: media.mediaTitle,
                    releaseDate: media.mediaReleaseDate,
                    voteAverage: media.voteAverage,
                    overview: media.overview,
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget getRatingWidget(CombinedResult movie) {
    if (isUpcoming || isLatest) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(
          top: titleContainerPadding,
          right: titleContainerPadding,
          left: titleContainerPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.star,
            size: ratingIconSize,
            color: Colors.yellow.shade700,
          ),
          Text(
            ' ${applyCommaAndRound(movie.voteAverage, 1, false, true)}'
            // '   (${applyCommaAndRoundNoZeroes(movie.voteCount * 1.0, 0, true)})'
            '',
            style: ratingStyle,
          ),
          if (movie.mediaType == MediaType.tv.name)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'TV',
                style: ratingStyle,
              ),
            ),
        ],
      ),
    );
  }

  // Widget getPosterView(MovieResult movie) {
  //   final cvm = context.read<ConfigViewModel>();
  //   String base = cvm.apiConfig!.images.baseUrl;
  //   String size = cvm.apiConfig!.images.backdropSizes[1];
  //   if (widget.isBigWidget) {
  //     if (movie.backdropPath != null) {
  //       imageUrl = '$base$size${movie.backdropPath}';
  //     }
  //   } else {
  //     if (movie.posterPath != null) {
  //       size = cvm.apiConfig!.images.posterSizes[1];
  //       imageUrl = '$base$size${movie.posterPath}';
  //     }
  //   }
  //   logIfDebug('url:$imageUrl');
  //   return getImageView(imageUrl, movie.id);
  // }

  String? getImageUrl(CombinedResult movie, {bool? isBigWidget}) {
    String? imageUrl;
    String? destImageUrl;
    isBigWidget ??= widget.isBigWidget;
    final cvm = context.read<ConfigViewModel>();
    String base = cvm.apiConfig!.images.baseUrl;
    String size = cvm.apiConfig!.images.backdropSizes[1];
    if (movie.backdropPath != null) {
      imageUrl = '$base$size${movie.backdropPath}';

      /// If best res images are required, then enable this size definition
      size = cvm.apiConfig!.images.backdropSizes[2];

      destImageUrl = '$base$size${movie.backdropPath}';
    } else {
      if (movie.posterPath != null) {
        size = cvm.apiConfig!.images.posterSizes.last;
        destImageUrl = '$base$size${movie.posterPath}';
      }
    }
    if (isBigWidget) {
      if (imageUrl == null && movie.posterPath != null) {
        size = cvm.apiConfig!.images.posterSizes.last;
        imageUrl = '$base$size${movie.posterPath}';
      }
    } else {
      if (movie.posterPath != null) {
        size = cvm.apiConfig!.images.posterSizes[3];
        imageUrl = '$base$size${movie.posterPath}';
      }
    }
    imageUrlToId.putIfAbsent(movie.id, () => [imageUrl, destImageUrl]);
    logIfDebug('url:$imageUrl');
    return imageUrl;
  }

  String? getCacheImageUrl(MovieResult movie) {
    if (movie.backdropPath != null) {
      final cvm = context.read<ConfigViewModel>();
      String base = cvm.apiConfig!.images.baseUrl;
      String size = cvm.apiConfig!.images.backdropSizes[2];
      return '$base$size${movie.backdropPath}';
    }
    return null;
  }

  Widget getImageView(CombinedResult movie) {
    String? url = getImageUrl(movie);
    var child = url != null
        ? Image.network(
            url,
            loadingBuilder: (_, child, progress) {
              if (progress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            fit: BoxFit.fill,
            errorBuilder: (_, __, ___) {
              return Icon(
                Icons.error_outline_sharp,
                size: min(posterWidth, posterHeight) * 0.20,
                color: Colors.red,
              );
            },
          )
        : Padding(
            padding: const EdgeInsets.all(24.0),
            child: Image.asset(
              'assets/images/placeholder.png',
              // fit: BoxFit.scaleDown,
            ),
          );
    // String? cacheImageUrl = getCacheImageUrl(movie);
    // if (cacheImageUrl != null) {
    //   logIfDebug('precacheUrl:$cacheImageUrl');
    //   precacheImage(
    //       Image.network(cacheImageUrl, fit: BoxFit.fill).image, context);
    // }
    return AspectRatio(
      aspectRatio:
          widget.isBigWidget ? Constants.arBackdrop : Constants.arPoster,
      // That's the actual aspect ratio of TMDB posters
      child:
          Hero(tag: '${widget.sectionTitle}-image-${movie.id}', child: child),
    );
  }
}

// class HomeSection2 extends StatefulWidget {
//   final SectionTitle sectionTitle;
//   final bool isBigWidget;
//   final MediaType? mediaType;
//   final TimeWindow? timeWindow;
//
//   const HomeSection2(
//     this.sectionTitle, {
//     this.mediaType,
//     this.timeWindow,
//     Key? key,
//     this.isBigWidget = false,
//   }) : super(key: key);
//
//   @override
//   State<HomeSection2> createState() => _HomeSectionState2();
// }
//
// class _HomeSectionState2 extends State<HomeSection2>
//     with GenericFunctions, Utilities, CommonFunctions, RouteAware {
//   final smallFactor = 2.25;
//   final bigFactor = 1.0;
//   final titleContainerPadding = 8.0;
//   late final titleFontSize = widget.isBigWidget ? 18.0 : 16.0;
//   final titleLineHeight = 1.2;
//   late final titleLines = widget.isBigWidget ? 1 : 2;
//   late final yearFontSize = titleFontSize - 4.0;
//   final listViewVerticalPadding = 8.0;
//   final listViewHorizontalPadding = 16.0;
//   late final ratingIconSize = widget.isBigWidget ? 24.0 : 20.0;
//   late final ratingFontSize = widget.isBigWidget ? 18.0 : 16.0;
//   final separatorWidth = 10.0;
//   final borderWidth = 0.7;
//
//   late final sizeFactorInt = sizeFactor.toInt();
//   late final totalBorderWidth =
//       (sizeFactorInt * 2 + (sizeFactor > sizeFactorInt ? 1 : 0)) * borderWidth;
//
//   late final sizeFactor = widget.isBigWidget ? bigFactor : smallFactor;
//   late final screenWidth = MediaQuery.of(context).size.width;
//   late final deductibleWidth = listViewHorizontalPadding +
//       separatorWidth * sizeFactorInt +
//       totalBorderWidth;
//   late final posterWidth = (screenWidth - deductibleWidth) / sizeFactor;
//   late final posterHeight = posterWidth /
//       (widget.isBigWidget ? Constants.arBackdrop : Constants.arPoster);
//
//   late final isUpcoming = widget.sectionTitle == SectionTitle.upcoming;
//   late final isLatest = widget.sectionTitle == SectionTitle.latest;
//
//   late final titleStyle = TextStyle(
//     // fontWeight: FontWeight.bold,
//     fontSize: titleFontSize,
//     height: titleLineHeight,
//   );
//
//   late final yearStyle = TextStyle(
//     // fontWeight: FontWeight.normal,
//     fontSize: yearFontSize,
//     height: 1.0,
//   );
//
//   late final ratingStyle = TextStyle(
//     // fontWeight: FontWeight.normal,
//     fontSize: ratingFontSize,
//     height: 1.0,
//   );
//
//   late final titleTextHeight =
//       titleStyle.height! * titleStyle.fontSize! * titleLines;
//
//   late final yearTextHeight = yearStyle.height! * yearStyle.fontSize! * 1;
//
//   late final ratingTextHeight = ratingStyle.height! * ratingStyle.fontSize! * 1;
//
//   late final titleContainerHeight = titleTextHeight + titleContainerPadding * 2;
//
//   late final ratingContainerHeight =
//       max(ratingTextHeight, ratingIconSize) + titleContainerPadding;
//
//   late final yearContainerHeight = yearTextHeight + titleContainerPadding;
//
//   late final cardHeight = posterHeight +
//       titleContainerHeight +
//       listViewVerticalPadding * 2 +
//       (isUpcoming || isLatest ? 0 : ratingContainerHeight) +
//       yearContainerHeight;
//
//   Map<int, List<String?>> imageUrlToId = {};
//
//   @override
//   void didPush() {
//     logIfDebug('didPush called');
//     super.didPush();
//   }
//
//   @override
//   void didPushNext() {
//     logIfDebug('didPushNext called');
//     super.didPushNext();
//   }
//
//   @override
//   void didPopNext() {
//     logIfDebug('didPopNext called');
//     super.didPopNext();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     var hvm = context.read<HomeViewModel>();
//     switch (widget.sectionTitle) {
//       case SectionTitle.nowPlaying:
//         hvm.getNowPlaying(widget.mediaType);
//         break;
//       case SectionTitle.trending:
//         hvm.getTrending(timeWindow: widget.timeWindow);
//         break;
//       case SectionTitle.latest:
//         hvm.getLatestMovies(null);
//         break;
//       case SectionTitle.popular:
//         hvm.getPopularMovies(widget.mediaType);
//         break;
//       case SectionTitle.topRated:
//         hvm.getTopRatedMovies(widget.mediaType);
//         break;
//       case SectionTitle.upcoming:
//         hvm.getDiscoverUpcoming(widget.mediaType);
//         break;
//       case SectionTitle.streaming:
//         // TODO: Handle this case.
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     logIfDebug(
//         'width:${MediaQuery.of(context).size.width}, deductible:$deductibleWidth, borderWidth: $totalBorderWidth');
//     return Selector<HomeViewModel, CombinedResults?>(
//       selector: (_, hvm) => hvm.getResultBySectionTitle(widget.sectionTitle),
//       builder: (_, result, __) {
//         if (result != null) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.fromLTRB(listViewHorizontalPadding, 24.0,
//                     listViewHorizontalPadding, 4.0),
//                 child: Text(
//                   widget.sectionTitle.name,
//                   style: const TextStyle(
//                     color: Colors.black87,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18.0,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: screenWidth,
//                 height: cardHeight,
//                 child: ListView.separated(
//                   // shrinkWrap: true,
//                   physics: const ClampingScrollPhysics(),
//                   padding: EdgeInsets.symmetric(
//                       horizontal: listViewHorizontalPadding,
//                       vertical: listViewVerticalPadding),
//                   itemBuilder: (_, index) {
//                     var movie = result.results[index];
//                     if (index == 0) {
//                       logIfDebug('${widget.sectionTitle.name} '
//                           'count:${result.results.length}');
//                     }
//
//                     /// Have to stack the InkWell on top of the Card to make the
//                     /// splash work, when there is an image in the card.
//                     return getSectionItem(movie);
//                   },
//                   scrollDirection: Axis.horizontal,
//                   itemCount: result.results.length,
//                   separatorBuilder: (BuildContext context, int index) {
//                     return SizedBox(width: separatorWidth);
//                   },
//                 ),
//               ),
//             ],
//           );
//         }
//         return Container();
//       },
//     );
//   }
//
//   Stack getSectionItem(CombinedResult media) {
//     return Stack(
//       children: [
//         Card(
//           surfaceTintColor: Colors.white,
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             // side: BorderSide(
//             //   color: Theme.of(context).primaryColorDark,
//             //   width: borderWidth,
//             // ),
//           ),
//           margin: EdgeInsets.zero,
//
//           /// Wrapping in a width constraint is essential
//           child: SizedBox(
//             width: posterWidth,
//             // height: height,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12.0),
//                     topRight: Radius.circular(12.0),
//                   ),
//                   child: getImageView(media),
//                 ),
//                 getRatingWidget(media),
//                 Container(
//                   // alignment: Alignment.center,
//                   padding: EdgeInsets.symmetric(
//                       vertical: titleContainerPadding,
//                       horizontal: titleContainerPadding),
//                   height: titleContainerHeight,
//
//                   /// \n\n ensures that the text is always 3 lines
//                   /// long
//                   child: Text(
//                     '${media.mediaTitle}\n\n',
//                     // textAlign: TextAlign.center,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: titleLines,
//                     style: titleStyle,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                       bottom: titleContainerPadding,
//                       right: titleContainerPadding,
//                       left: titleContainerPadding),
//                   child: Text(
//                     isUpcoming
//                         ? getReadableDate(media.mediaReleaseDate)
//                         : getYearStringFromDate(media.mediaReleaseDate),
//                     style: yearStyle,
//                     maxLines: 1,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         Positioned.fill(
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () {
//                 logIfDebug(
//                     'onTap called for:${media.mediaTitle}, type:${media.mediaType}');
//                 if (media.mediaType == MediaType.movie.name) {
//                   goToMoviePage(
//                     context,
//                     id: media.id,
//                     title: media.mediaTitle,
//                     releaseDate: media.mediaReleaseDate,
//                     voteAverage: media.voteAverage,
//                     overview: media.overview,
//                   );
//                 } else if (media.mediaType == MediaType.tv.name) {
//                   goToTvPage(
//                     context,
//                     id: media.id,
//                     title: media.mediaTitle,
//                     releaseDate: media.mediaReleaseDate,
//                     voteAverage: media.voteAverage,
//                     overview: media.overview,
//                   );
//                 }
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget getRatingWidget(CombinedResult movie) {
//     if (isUpcoming || isLatest) return const SizedBox.shrink();
//     return Padding(
//       padding: EdgeInsets.only(
//           top: titleContainerPadding,
//           right: titleContainerPadding,
//           left: titleContainerPadding),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Icon(
//             Icons.star,
//             size: ratingIconSize,
//             color: Colors.yellow.shade700,
//           ),
//           Text(
//             ' ${applyCommaAndRound(movie.voteAverage, 1, false, true)}'
//             // '   (${applyCommaAndRoundNoZeroes(movie.voteCount * 1.0, 0, true)})'
//             '',
//             style: ratingStyle,
//           ),
//           if (movie.mediaType == MediaType.tv.name)
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0),
//               child: Text(
//                 'TV',
//                 style: ratingStyle,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   // Widget getPosterView(MovieResult movie) {
//   //   final cvm = context.read<ConfigViewModel>();
//   //   String base = cvm.apiConfig!.images.baseUrl;
//   //   String size = cvm.apiConfig!.images.backdropSizes[1];
//   //   if (widget.isBigWidget) {
//   //     if (movie.backdropPath != null) {
//   //       imageUrl = '$base$size${movie.backdropPath}';
//   //     }
//   //   } else {
//   //     if (movie.posterPath != null) {
//   //       size = cvm.apiConfig!.images.posterSizes[1];
//   //       imageUrl = '$base$size${movie.posterPath}';
//   //     }
//   //   }
//   //   logIfDebug('url:$imageUrl');
//   //   return getImageView(imageUrl, movie.id);
//   // }
//
//   String? getImageUrl(CombinedResult movie, {bool? isBigWidget}) {
//     String? imageUrl;
//     String? destImageUrl;
//     isBigWidget ??= widget.isBigWidget;
//     final cvm = context.read<ConfigViewModel>();
//     String base = cvm.apiConfig!.images.baseUrl;
//     String size = cvm.apiConfig!.images.backdropSizes[1];
//     if (movie.backdropPath != null) {
//       imageUrl = '$base$size${movie.backdropPath}';
//
//       /// If best res images are required, then enable this size definition
//       size = cvm.apiConfig!.images.backdropSizes[2];
//
//       destImageUrl = '$base$size${movie.backdropPath}';
//     } else {
//       if (movie.posterPath != null) {
//         size = cvm.apiConfig!.images.posterSizes.last;
//         destImageUrl = '$base$size${movie.posterPath}';
//       }
//     }
//     if (isBigWidget) {
//       if (imageUrl == null && movie.posterPath != null) {
//         size = cvm.apiConfig!.images.posterSizes.last;
//         imageUrl = '$base$size${movie.posterPath}';
//       }
//     } else {
//       if (movie.posterPath != null) {
//         size = cvm.apiConfig!.images.posterSizes[3];
//         imageUrl = '$base$size${movie.posterPath}';
//       }
//     }
//     imageUrlToId.putIfAbsent(movie.id, () => [imageUrl, destImageUrl]);
//     logIfDebug('url:$imageUrl');
//     return imageUrl;
//   }
//
//   String? getCacheImageUrl(MovieResult movie) {
//     if (movie.backdropPath != null) {
//       final cvm = context.read<ConfigViewModel>();
//       String base = cvm.apiConfig!.images.baseUrl;
//       String size = cvm.apiConfig!.images.backdropSizes[2];
//       return '$base$size${movie.backdropPath}';
//     }
//     return null;
//   }
//
//   Widget getImageView(CombinedResult movie) {
//     String? url = getImageUrl(movie);
//     var child = url != null
//         ? Image.network(
//             url,
//             loadingBuilder: (_, child, progress) {
//               if (progress == null) {
//                 return child;
//               }
//               return Center(
//                 child: CircularProgressIndicator(
//                   value: progress.expectedTotalBytes != null
//                       ? progress.cumulativeBytesLoaded /
//                           progress.expectedTotalBytes!
//                       : null,
//                 ),
//               );
//             },
//             fit: BoxFit.fill,
//             errorBuilder: (_, __, ___) {
//               return Icon(
//                 Icons.error_outline_sharp,
//                 size: min(posterWidth, posterHeight) * 0.20,
//                 color: Colors.red,
//               );
//             },
//           )
//         : Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Image.asset(
//               'assets/images/placeholder.png',
//               // fit: BoxFit.scaleDown,
//             ),
//           );
//     // String? cacheImageUrl = getCacheImageUrl(movie);
//     // if (cacheImageUrl != null) {
//     //   logIfDebug('precacheUrl:$cacheImageUrl');
//     //   precacheImage(
//     //       Image.network(cacheImageUrl, fit: BoxFit.fill).image, context);
//     // }
//     return AspectRatio(
//       aspectRatio:
//           widget.isBigWidget ? Constants.arBackdrop : Constants.arPoster,
//       // That's the actual aspect ratio of TMDB posters
//       child:
//           Hero(tag: '${widget.sectionTitle}-image-${movie.id}', child: child),
//     );
//   }
// }
