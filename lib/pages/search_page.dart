import 'package:cinema_scope/architecture/search_view_model.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../architecture/config_view_model.dart';
import '../constants.dart';
import '../main.dart';
import '../models/search.dart';
import '../widgets/poster_tile.dart';

class SearchPage extends MultiProvider {
  SearchPage({super.key})
      : super(
          providers: [
            ChangeNotifierProvider(create: (_) => SearchViewModel()),
            // ChangeNotifierProvider(create: (_) => HeroViewModel()),
          ],
          builder: (_, __) => const _SearchPageChild(),
          // child: const _SearchPageChild(),
        );
}

class _SearchPageChild extends StatefulWidget {
  const _SearchPageChild({Key? key}) : super(key: key);

  @override
  State<_SearchPageChild> createState() => _SearchPageChildState();
}

class _SearchPageChildState extends State<_SearchPageChild>
    with GenericFunctions, Utilities, CommonFunctions {
  late final ConfigViewModel cvm;
  late final SearchViewModel svm;

  Map<int, List<String?>> imageUrlToId = {};

  @override
  void initState() {
    logIfDebug('initState called');
    cvm = context.read<ConfigViewModel>();
    svm = context.read<SearchViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      svm.initializePaging(cvm.combinedGenres);
    });
    super.initState();
  }

  bool get isPortrait =>
      MediaQuery.orientationOf(context) == Orientation.portrait;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          // key: const PageStorageKey<String>('controllerA'),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            buildSliverSearchBar(),
            buildCountSliver(),
            // FutureBuilder(
            //   future: Future.delayed(const Duration(milliseconds: 500)),
            //   builder: (_, snapshot) {
            //     logIfDebug('connectionState:${snapshot.connectionState}');
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       return MultiSliver(
            //         children: [
            //           buildCountSliver(),
            //         ],
            //       );
            //     } else {
            //       return const SliverToBoxAdapter(
            //         child: SizedBox(height: 8 + 8 + 14,),
            //       );
            //     }
            //   },
            // ),
            PagedSliverGrid(
              pagingController: svm.pagingController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isPortrait ? 1 : 2,
                mainAxisExtent: mainAxisExtent,
              ),
              builderDelegate: PagedChildBuilderDelegate<BaseResult>(
                itemBuilder: (_, media, index) {
                  logIfDebug('itemBuilder called with index:$index, $media');
                  var mediaType = media.mediaType;
                  logIfDebug('mediaType:$mediaType');
                  // return const SizedBox.shrink();
                  return getSearchViews(mediaType, media);
                },
                newPageProgressIndicatorBuilder: (_) => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ),
                noMoreItemsIndicatorBuilder: (_) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'You have reached the end!',
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSearchViews(String? mediaType, BaseResult media) {
    if (mediaType == MediaType.movie.name) {
      return MoviePosterTile(movie: media as CombinedResult);
    } else if (mediaType == MediaType.person.name) {
      return PersonPosterTile(
        person: media as PersonResult,
        subtitle: media.knownForDepartment.isNotEmpty ||
                (media.gender != null && media.gender! > 0)
            ? Row(
                children: [
                  if (media.knownForDepartment.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        media.knownForDepartment,
                        // textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ),
                  if (media.gender != null && media.gender! > 0)
                    Text(
                      '(${getGenderText(media.gender)})',
                      // textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 15.0),
                    ),
                ],
              )
            : null,
        description: media.knownFor.isNotEmpty
            ? getRichText(context, media.knownFor)
            : null,
        /// It has been set as false to all clicking the rich text links of
        /// person's media titles
        overlay: false,
      );
    } else if (mediaType == MediaType.tv.name) {
      return TvPosterTile(tv: media as CombinedResult);
    }
    return const SizedBox.shrink();
  }

  SliverAppBar buildSliverSearchBar() {
    BorderRadius borderRadius = BorderRadius.circular(isPortrait ? 30.0 : 48.0);
    return SliverAppBar(
      pinned: false,
      automaticallyImplyLeading: false,
      toolbarHeight: kToolbarHeight + 16,
      elevation: 24,
      title: SizedBox(
        width: double.infinity,
        height: kToolbarHeight - 4,
        child: Center(
          child: TextField(
            focusNode: context.read<SearchViewModel>().focusNode,
            controller: context.read<SearchViewModel>().controller,
            onChanged: context.read<SearchViewModel>().onChanged,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: kPrimary,
                  width: 2.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: EdgeInsets.zero,
              // isDense: true,
              // constraints: const BoxConstraints.tightFor(width: double.maxFinite, height: kToolbarHeight - 4),
              prefixIcon: IconButton(
                onPressed: () => Navigator.pop(context),
                // borderRadius: borderRadius,
                icon: Icon(
                  Icons.adaptive.arrow_back,
                  // color: Theme.of(context).appBarTheme.iconTheme!.color!,
                ),
              ),
              suffixIcon: Selector<SearchViewModel, String>(
                selector: (_, svm) => svm.lastQuery,
                builder: (_, query, __) => query.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: () =>
                            context.read<SearchViewModel>().clearQuery(),
                        // borderRadius: borderRadius,
                        icon: const Icon(
                          Icons.clear_rounded,
                          // color: Theme.of(context).appBarTheme.iconTheme!.color!,
                        ),
                      ),
              ),
              hintText: 'Search movies, TV, people',
              hintStyle: TextStyle(
                  fontSize: isPortrait ? 17 /*.spMin*/ : 18 /*.spMin*/),
              filled: true,
              fillColor: kPrimary.withOpacity(0.07),
            ),
            style:
                TextStyle(fontSize: isPortrait ? 17 /*.spMin*/ : 18 /*.spMin*/),
            maxLines: 1,
            // cursorHeight: 17.spMin,
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
      ),
    );
  }

  SliverPinnedHeader buildCountSliver() {
    return SliverPinnedHeader(
      child: Selector<SearchViewModel, int>(
        selector: (_, svm) => svm.searchResult?.totalResults ?? 0,
        builder: (_, count, __) {
          if (count > 0) {
            var countStr = applyCommaAndRound(count.toDouble(), 0, true, false);
            return Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: isPortrait
                    ? Constants.posterVPadding
                    : Constants.posterVPadding * 2,
              ),
              child: Text(
                'RESULTS ($countStr)',
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeightExt.semibold,
                  color: Colors.black87,
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  double get mainAxisExtent {
    return (Constants.posterWidth / Constants.arPoster) +
        (Constants.posterVPadding * 2);
  }

  Widget getRichText(BuildContext context, List<CombinedResult> results) {
    logIfDebug('titles:${results.map((e) => e.mediaTitle)..join(', ')}');
    List<InlineSpan> spans = [];
    for (var result in results) {
      spans.add(TextSpan(
        text: result.mediaTitle,
        style: const TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: Colors.black87,
          // decorationStyle: TextDecorationStyle.dotted,
          // height: 1.1,
          // decorationColor: Colors.blue,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
          logIfDebug('${result.mediaTitle} clicked');
            if (result.mediaType == MediaType.movie.name) {
              goToMoviePage(
                context,
                id: result.id,
                title: result.mediaTitle,
                overview: result.overview,
                releaseDate: result.mediaReleaseDate,
                voteAverage: result.voteAverage,
              );
            } else if (result.mediaType == MediaType.tv.name) {
              goToTvPage(
                context,
                id: result.id,
                title: result.mediaTitle,
                overview: result.overview,
                releaseDate: result.mediaReleaseDate,
                voteAverage: result.voteAverage,
              );
            }
          },
      ));
      if (result != results.last) spans.add(const TextSpan(text: ', '));
    }
    return Text.rich(
      TextSpan(
        children: spans,
        style: const TextStyle(
          fontSize: 14.5,
          height: 1.3,
          color: Colors.black87,
        ),
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget getBackdropView(MovieResult movie) {
    String? imageUrl;
    String? destImageUrl;
    if (movie.backdropPath != null) {
      final cvm = context.read<ConfigViewModel>();
      String base = cvm.apiConfig!.images.baseUrl;
      String size = cvm.apiConfig!.images.backdropSizes.first;
      imageUrl = '$base$size${movie.backdropPath}';

      /// Enable this size for best res images in MoviePage
      size = cvm.apiConfig!.images.backdropSizes[2];
      destImageUrl = '$base$size${movie.backdropPath}';
    }
    imageUrlToId.putIfAbsent(movie.id, () => [imageUrl, destImageUrl]);
    logIfDebug('url:$imageUrl');
    return getImageView(imageUrl, movie.id);
  }

  Widget getImageView(String? url, int id) {
    var child = url != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.network(
              url,
              loadingBuilder: (_, child, progress) {
                if (progress == null) {
                  return child;
                }
                return Center(
                  /// These factors make sure that the size of progress bar is
                  /// the same as that of the SizedBox, i.e. 24
                  /// This, so far, has emerged has as the neatest way of
                  /// changing the size of a circular progress bar
                  widthFactor: 1,
                  heightFactor: 1,
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              fit: BoxFit.fill,
            ),
          )
        : Image.asset('assets/images/placeholder.png');
    return AspectRatio(
      aspectRatio: Constants.arBackdrop,
      // That's the actual aspect ratio of TMDB posters
      child: Hero(
        tag: 'search-image-$id',
        child: child,
      ),
    );
  }
}

class SearchAppbar extends StatelessWidget
    with GenericFunctions
    implements PreferredSizeWidget {
  const SearchAppbar({Key? key}) : super(key: key);

  double get height => preferredSize.height;

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    BorderRadius borderRadius = BorderRadius.circular(isPortrait ? 30.0 : 48.0);
    logIfDebug('build called - isPortrait:$isPortrait');
    return AppBar(
      toolbarHeight: height,
      automaticallyImplyLeading: context.read<SearchViewModel>().isBackVisible,
      title: SizedBox(
        width: double.infinity,
        height: height,
        child: Center(
          child: TextField(
            focusNode: context.read<SearchViewModel>().focusNode,
            controller: context.read<SearchViewModel>().controller,
            onChanged: context.read<SearchViewModel>().onChanged,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              contentPadding:
                  const EdgeInsets.only(top: 10, bottom: 10, right: 10),
              // isDense: true,
              // constraints: BoxConstraints.tightFor(width: double.maxFinite, height: 80),
              prefixIcon: IconButton(
                onPressed: () => Navigator.pop(context),
                // borderRadius: borderRadius,
                icon: Icon(
                  Icons.adaptive.arrow_back,
                  // color: Theme.of(context).appBarTheme.iconTheme!.color!,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () => context.read<SearchViewModel>().clearQuery(),
                // borderRadius: borderRadius,
                icon: const Icon(
                  Icons.clear_rounded,
                  // color: Theme.of(context).appBarTheme.iconTheme!.color!,
                ),
              ),
              hintText: 'Search movies, TV, people',
              hintStyle: TextStyle(fontSize: isPortrait ? 16 : 18),
              filled: true,
              fillColor: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.5),
            ),
            style: TextStyle(fontSize: isPortrait ? 16 : 18),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight((kToolbarHeight));
}

class CountDelegate extends SliverPersistentHeaderDelegate
    with GenericFunctions {
  double extent = 40.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    logIfDebug('build called with offset:$shrinkOffset');
    return Selector<SearchViewModel, int>(
      selector: (_, svm) => svm.searchResult?.totalResults ?? 0,
      builder: (_, count, __) {
        // extent = count == 0 ? 0 : 48.0;
        // var half = shrinkOffset / 2 ;
        // var top = getTopMargin(half);
        if (count > 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // const SizedBox(height: 16),
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, right: 16.0, left: 16.0),
                  child: Text(
                    'RESULTS (${applyCommaAndRound(count.toDouble(), 0, true, false)})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  double getTopMargin(double half) {
    var max = 30.0;
    var min = 13.0;
    if (half > max) {
      return max;
    } else if (half < min) {
      return min;
    }
    return half;
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
