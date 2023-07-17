import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_scope/main.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../architecture/config_view_model.dart';
import '../architecture/home_view_model.dart';
import '../constants.dart';
import '../models/movie.dart';
import '../models/search.dart';
import '../pages/home_page.dart';
import '../utilities/generic_functions.dart';
import '../utilities/utilities.dart';

// enum SectionTitle {
//   nowPlaying('NOW PLAYING'),
//   trending('TRENDING'),
//   latest('LATEST'),
//   popular('POPULAR'),
//   topRated('TOP RATED'),
//   upcoming('COMING SOON'),
//   streaming('STREAMING'),
//   freeToWatch('FREE TO WATCH');
//
//   final String name;
//
//   const SectionTitle(this.name);
// }

class BaseHomeSection extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
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
    logIfDebug('build called');
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Stack(
        children: [
          /// This serves as the base card on which the content card is
          /// stacked. The fill constructor helps match its height with
          /// the height of the content card.
          const Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Card(
                elevation: 8,
                color: Colors.white,
                surfaceTintColor: Colors.white,
                margin: EdgeInsets.zero,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    bottomLeft: Radius.circular(24.0),
                  ),
                  // side: BorderSide(
                  //   color: kPrimary,
                  // ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // sectionSeparator,
              getSectionTitleRow(),
              ...children,
              // getSectionSeparator(context),
            ],
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
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                // letterSpacing: 1.0,
                color: Colors.black87,
                // height: 1.2,
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
  final List<String> paramTitles;

  const HomeSection(
    this.sectionTitle, {
    this.mediaType,
    this.timeWindow,
    this.params = const <String>[],
    required this.paramTitles,
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
      case SectionTitle.currentYearTopRated:
        hvm.getCurrentYearTopMedia(value as MediaType?);
        break;
      case SectionTitle.lastYearTopRated:
        hvm.getLastYearTopMedia(value as MediaType?);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');
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
                        padding: const EdgeInsets.only(left: 32, top: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ToggleButtons(
                            constraints: const BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                            borderColor: kPrimary,
                            selectedColor: kPrimary,
                            // fillColor: kPrimary.lighten2(55),
                            // highlightColor: Theme.of(context).primaryColor.withOpacity(0.5),
                            selectedBorderColor: kPrimary,
                            borderWidth: 0.8,
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
                              ...(widget.paramTitles).map((e) {
                                final selected = widget.params[
                                        widget.paramTitles.indexOf(e)] ==
                                    param;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight:
                                          selected ? FontWeight.w500 : null,
                                      // height: 1.2,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              MediaPosterListView(
                items: result.results,
                isUpcoming: widget.sectionTitle == SectionTitle.upcoming,
                isLatest: widget.sectionTitle == SectionTitle.latest,
                listViewLeftPadding: 32.0,
                listViewBottomPadding: 16.0,
              ),
              // Center(child: CompactTextButton('EXPLORE ALL', onPressed: () {})),
              const SizedBox(height: 6.0),
            ],
          );
        }
      },
    );
  }
}

class MediaPosterListView extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final bool? isUpcoming;
  final bool? isLatest;
  final List<CombinedResult> items;
  final double posterWidth;
  final double radius;
  final double listViewBottomPadding;
  final double listViewLeftPadding;
  final double listViewRightPadding;
  final String Function(CombinedResult item)? subtitle;

  final titleContainerPadding = 8.0;
  final ratingVerticalPadding = 10.0;

  late final titleFontSize = 14.0;

  final titleLineHeight = 1.2;

  final maxLines = 2;

  late final yearFontSize = titleFontSize;

  final listViewTopPadding = 16.0;

  final subtitleTopPadding = 0.0;

  late final subtitleBottomPadding = ratingVerticalPadding;

  late final ratingIconSize = 14.0;

  late final ratingFontSize = titleFontSize;

// final separatorWidth = 10.w;

  late final titleStyle = TextStyle(
    fontWeight: FontWeightExt.semibold,
    fontSize: titleFontSize,
    height: titleLineHeight,
  );

  late final subTitleLineHeight = titleLineHeight;

  late final yearStyle = TextStyle(
    // fontWeight: FontWeight.normal,
    fontSize: yearFontSize,
    height: 1.0,
  );

  late final subtitleStyle = TextStyle(
    // fontWeight: FontWeight.normal,
    fontSize: yearFontSize,
    height: subTitleLineHeight,
  );

  late final titleTextHeight =
      titleStyle.height! * titleStyle.fontSize! * maxLines;

  late final yearTextHeight = yearStyle.height! * yearStyle.fontSize! * 1;

  late final titleContainerHeight = titleTextHeight + titleContainerPadding;

  late final yearContainerHeight =
      max(yearTextHeight, ratingIconSize) + ratingVerticalPadding * 2;

  late final subtitleHeight = subTitleLineHeight * yearFontSize * maxLines;

  late final subtitleContainerHeight =
      subtitleHeight + subtitleTopPadding + subtitleBottomPadding;

// double get yearFontSize => titleFontSize - 2.0;

  MediaPosterListView({
    required this.items,
    this.posterWidth = 155.0,
    this.radius = 6.0,
    this.listViewBottomPadding = 24.0,
    this.listViewLeftPadding = 16.0,
    this.listViewRightPadding = 16.0,
    this.subtitle,
    this.isUpcoming,
    this.isLatest,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');

    final posterHeight =
        (posterWidth - Constants.cardMargin * 2) / Constants.arPoster;

    final listViewHeight = posterHeight +
        titleContainerHeight +
        yearContainerHeight +
        listViewTopPadding +
        listViewBottomPadding +
        (subtitle == null ? 0.0 : subtitleContainerHeight);
    logIfDebug('poster height:$posterHeight, '
        'title height:$titleContainerHeight, '
        'year height:$yearContainerHeight, '
        'subtitle height:${subtitle == null ? 0.0 : subtitleContainerHeight}, '
        'top padding:$listViewTopPadding, '
        'bottom padding:$listViewBottomPadding, '
        'view height:$listViewHeight');
    return SizedBox(
      height: listViewHeight,
      child: ListView.builder(
        itemBuilder: (_, index) {
          // logIfDebug('MyListView itemBuilder called');
          final media = items[index];
          var job = subtitle?.call(media);
          return buildItemView(
            context,
            media,
            cardMargin: Constants.cardMargin,
            job: job,
          );
        },
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          listViewLeftPadding - Constants.cardMargin,
          listViewTopPadding,
          listViewRightPadding - Constants.cardMargin,
          listViewBottomPadding,
        ),
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemExtent: posterWidth,
      ),
    );
  }

  Widget buildItemView(
    BuildContext context,
    CombinedResult media, {
    required double cardMargin,
    String? job,
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
                media.posterPath,
                imageType: ImageType.poster,
                aspectRatio: Constants.arPoster,
                topRadius: radius,
              ),
              Ink(
                // alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: titleContainerPadding,
                  left: titleContainerPadding,
                  right: titleContainerPadding,
                ),
                height: titleContainerHeight,
                child: Text(
                  media.mediaTitle,
                  // textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLines,
                  style: titleStyle,
                ),
              ),
              buildYearRatingRow(
                media,
                isUpcoming: isUpcoming,
                isLatest: isLatest,
              ),
              if (job.isNotNullNorEmpty)
                Ink(
                  padding: EdgeInsets.fromLTRB(
                    titleContainerPadding,
                    subtitleTopPadding,
                    titleContainerPadding,
                    subtitleBottomPadding,
                  ),
                  height: subtitleContainerHeight,
                  child: Text(
                    job!,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: subtitleStyle,
                  ),
                ),
            ],
          ),
        ),
        if (media.mediaType == MediaType.tv.name)
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Padding(
              padding: EdgeInsets.only(right: cardMargin),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(radius),
                    bottomLeft: Radius.circular(radius),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10.0,
                ),
                child: const Text(
                  'TV',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    // height: 1.0,
                  ),
                ),
              ),
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
                      backdrop: media.backdropPath,
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
        ),
      ],
    );
  }

  Widget buildImageView(BuildContext context, CombinedResult movie) {
    final url = getImageUrl(context, movie);
    final child = url != null
        ? CachedNetworkImage(
            imageUrl: url,
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
      aspectRatio: Constants.arPoster,
      child: child,
    );
  }

  Widget buildYearRatingRow(
    CombinedResult media, {
    bool? isUpcoming,
    bool? isLatest,
  }) {
    final yearString =
        isUpcoming.isNotNullAndTrue ? media.dateString : media.yearString;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ratingVerticalPadding,
        horizontal: titleContainerPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (yearString.isNotEmpty) ...[
            Text(
              yearString,
              style: yearStyle,
              maxLines: 1,
            ),
            const SizedBox(width: 16.0),
          ],
          if (media.voteAverage > 0 && !isUpcoming.isNotNullAndTrue
              /* && !isLatest.isNotNullAndTrue*/
              ) ...[
            FaIcon(
              FontAwesomeIcons.solidStar,
              size: ratingIconSize,
              color: Colors.yellow.shade700,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: Text(
                ' ${applyCommaAndRound(media.voteAverage, 1, false, true)}',
                style: yearStyle,
                maxLines: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String? getImageUrl(BuildContext context, CombinedResult movie) {
    final cvm = context.read<ConfigViewModel>();
    final imageConfig = cvm.apiConfig!.images;
    String base = imageConfig.baseUrl;
    String size = imageConfig.posterSizes[3];
    return movie.posterPath != null ? '$base$size${movie.posterPath}' : null;
  }
}
