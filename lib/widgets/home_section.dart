import 'dart:math';

import 'package:cinema_scope/architecture/hero_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../architecture/config_view_model.dart';
import '../architecture/home_view_model.dart';
import '../constants.dart';
import '../models/search.dart';
import '../pages/movie_page.dart';
import '../utilities/generic_functions.dart';
import '../utilities/utilities.dart';

enum SectionTitle {
  nowPlaying('NOW PLAYING'),
  dailyTrending('DAILY TRENDING'),
  latest('LATEST'),
  popular('POPULAR'),
  topRated('TOP RATED'),
  upcoming('COMING SOON');

  final String name;

  const SectionTitle(this.name);
}

class HomeSection extends StatefulWidget {
  final SectionTitle sectionTitle;
  final bool isBigWidget;

  const HomeSection(
    this.sectionTitle, {
    Key? key,
    this.isBigWidget = false,
  }) : super(key: key);

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection>
    with GenericFunctions, Utilities {
  final smallFactor = 2.5;
  final bigFactor = 1.0;
  final titleContainerPadding = 8.0;
  late final titleFontSize = widget.isBigWidget ? 18.0 : 16.0;
  final titleLineHeight = 1.2;
  late final titleLines = widget.isBigWidget ? 1 : 3;
  late final yearFontSize = titleFontSize - 4.0;
  final listViewVerticalPadding = 4.0;
  final listViewHorizontalPadding = 8.0;
  late final ratingIconSize = widget.isBigWidget ? 24.0 : 20.0;
  late final ratingFontSize = widget.isBigWidget ? 18.0 : 16.0;
  final separatorWidth = 8.0;
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
      listViewVerticalPadding * 2 +
      (isUpcoming || isLatest ? 0 : ratingContainerHeight) +
      yearContainerHeight;

  Map<int, List<String?>> imageUrlToId = {};

  @override
  Widget build(BuildContext context) {
    logIfDebug(
        'width:${MediaQuery.of(context).size.width}, deductible:$deductibleWidth, borderWidth: $totalBorderWidth');
    return Selector<HomeViewModel, SearchResult?>(
      selector: (_, hvm) => hvm.getResultBySectionTitle(widget.sectionTitle),
      builder: (_, result, __) {
        if (result != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(listViewHorizontalPadding, 24.0,
                    listViewHorizontalPadding, 4.0),
                child: Text(
                  widget.sectionTitle.name,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: cardHeight,
                child: ListView.separated(
                  // shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: listViewHorizontalPadding,
                      vertical: listViewVerticalPadding),
                  itemBuilder: (_, index) {
                    var movie = result.results[index];
                    if (index == 0) {
                      logIfDebug('${widget.sectionTitle.name} '
                          'count:${result.results.length}');
                    }

                    /// Have to stack the InkWell on top of the Card to make the
                    /// splash work, when there is an image in the card.
                    return getSectionItem(movie);
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: result.results.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: separatorWidth);
                  },
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  Stack getSectionItem(MovieResult movie) {
    return Stack(
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(
              color: Theme.of(context).primaryColorDark,
              width: borderWidth,
            ),
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
                  borderRadius: BorderRadius.circular(4.0),
                  child: getImageView(movie),
                ),
                getRatingWidget(movie),
                Container(
                  // alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      vertical: titleContainerPadding,
                      horizontal: titleContainerPadding),
                  height: titleContainerHeight,

                  /// \n\n ensures that the text is always 3 lines
                  /// long
                  child: Text(
                    '${movie.movieTitle}\n\n',
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
                        ? getReadableDate(movie.releaseDate)
                        : getYearStringFromDate(movie.releaseDate),
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
              onTap: () {
                context.read<HeroViewModel>().heroImageTag =
                    '${widget.sectionTitle}-${movie.id}';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MoviePage(
                      id: movie.id,
                      imageUrlToId[movie.id]?[0],
                      imageUrlToId[movie.id]?[1],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget getRatingWidget(MovieResult movie) {
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

  String? getImageUrl(MovieResult movie, {bool? isBigWidget}) {
    String? imageUrl;
    String? destImageUrl;
    isBigWidget ??= widget.isBigWidget;
    final cvm = context.read<ConfigViewModel>();
    String base = cvm.apiConfig!.images.baseUrl;
    String size = cvm.apiConfig!.images.backdropSizes[1];
    if (movie.backdropPath != null) {
      destImageUrl = imageUrl = '$base$size${movie.backdropPath}';
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
        size = cvm.apiConfig!.images.posterSizes[1];
        imageUrl = '$base$size${movie.posterPath}';
      }
    }
    imageUrlToId.putIfAbsent(movie.id, () => [imageUrl, destImageUrl]);
    logIfDebug('url:$imageUrl');
    return imageUrl;
  }

  Widget getImageView(MovieResult movie) {
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
          )
        : Padding(
            padding: const EdgeInsets.all(24.0),
            child: Image.asset(
              'assets/images/placeholder.png',
              // fit: BoxFit.scaleDown,
            ),
          );
    return AspectRatio(
      aspectRatio:
          widget.isBigWidget ? Constants.arBackdrop : Constants.arPoster,
      // That's the actual aspect ratio of TMDB posters
      child: Hero(tag: '${widget.sectionTitle}-${movie.id}', child: child),
    );
  }
}
