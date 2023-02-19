import 'package:cinema_scope/architecture/search_view_model.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../architecture/config_view_model.dart';
import '../constants.dart';
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

  // final TextEditingController _controller = TextEditingController();
  String lastQuery = '';

  @override
  void initState() {
    logIfDebug('initState called');
    cvm = context.read<ConfigViewModel>();
    svm = context.read<SearchViewModel>()..initializePaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // key: const PageStorageKey<String>('controllerA'),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          const SliverAppBar(
            floating: true,
            pinned: true,
            // snap: true,
            // title: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     getAppbarTitle('Search movies'),
            //     // Selector<SearchViewModel, int>(
            //     //   builder: (_, count, __) => Visibility(
            //     //     visible: count > 0,
            //     //     child: getAppbarSubtitle('($count)'),
            //     //   ),
            //     //   selector: (_, svm) => svm.searchResult?.totalResults ?? 0,
            //     // ),
            //   ],
            // ),
            automaticallyImplyLeading: true,
            toolbarHeight: 0,
            elevation: 24,
            bottom: SearchAppbar(),
            // flexibleSpace: FlexibleSpaceBar(
            //   background: Padding(
            //     padding: const EdgeInsets.only(
            //         top: 28, bottom: 8, left: 16, right: 16),
            //     child: TextField(
            //       expands: true,
            //       maxLines: null,
            //       minLines: null,
            //       controller: _controller,
            //       onChanged: (query) {
            //         logIfDebug('query:{$query}');
            //         if (query != lastQuery) {
            //           lastQuery = query;
            //           context.read<SearchViewModel>().searchPagedMovies(query);
            //         }
            //       },
            //       decoration: InputDecoration(
            //         focusedBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(30.0),
            //           borderSide: BorderSide(
            //             color: Theme.of(context).primaryColor,
            //             width: 2.0,
            //           ),
            //         ),
            //         disabledBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(30.0),
            //           borderSide: const BorderSide(
            //             style: BorderStyle.none,
            //           ),
            //         ),
            //         errorBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(30.0),
            //           borderSide: const BorderSide(
            //             style: BorderStyle.none,
            //           ),
            //         ),
            //         enabledBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(30.0),
            //           borderSide: const BorderSide(
            //             style: BorderStyle.none,
            //           ),
            //         ),
            //         contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
            //         // isDense: true,
            //         // constraints: BoxConstraints.tightFor(width: double.maxFinite, height: 80),
            //         prefixIcon: const Icon(Icons.search),
            //         hintText: 'Search',
            //         filled: true,
            //         fillColor: Colors.amber.shade50,
            //       ),
            //     ),
            //   ),
            // ),
          ),
          SliverPersistentHeader(
            delegate: CountDelegate(),
            pinned: true,
          ),
          PagedSliverList(
            pagingController: svm.pagingController,
            builderDelegate: PagedChildBuilderDelegate<BaseResult>(
              itemBuilder: (_, person, index) {
                logIfDebug('itemBuilder called with index:$index, $person');
                var mediaType = person.mediaType;
                logIfDebug('mediaType:${mediaType}');
                if (mediaType == MediaType.movie.name) {
                  return MoviePosterTile(movie: person as MovieResult);
                } else if (mediaType == MediaType.person.name) {
                  return PersonPosterTile(
                    person: person as PersonResult,
                    subtitle: person.knownForDepartment.isNotEmpty ||
                            (person.gender != null && person.gender! > 0)
                        ? Row(
                            children: [
                              if (person.knownForDepartment.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    person.knownForDepartment,
                                    // textAlign: TextAlign.start,
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                ),
                              if (person.gender != null && person.gender! > 0)
                                Text(
                                  '(${getGenderText(person.gender)})',
                                  // textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 15.0),
                                ),
                            ],
                          )
                        : null,
                    description: person.knownFor.isNotEmpty
                        ? getRichText(context, person.knownFor)
                        : null,
                  );
                } else if (mediaType == MediaType.tv.name) {
                  return TvPosterTile(tv: person as TvResult);
                }
                return const SizedBox.shrink();
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
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('You have reached the end!'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getRichText(BuildContext context, List<CombinedResult> results) {
    // logIfDebug('titles:${results.join(', ')}');
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
    return RichText(
      text: TextSpan(
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

class SearchAppbar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppbar({Key? key}) : super(key: key);

  final height = kToolbarHeight + 8;

  @override
  State<SearchAppbar> createState() => _SearchAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _SearchAppbarState extends State<SearchAppbar> with GenericFunctions {
  final TextEditingController _controller = TextEditingController();
  String lastQuery = '';

  bool isBackVisible = false /*true*/;

  final focusNode = FocusNode();

  @override
  void initState() {
    // focusNode.addListener(() =>
    //     setState(() => isBackVisible = !focusNode.hasFocus));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: widget.height,
      automaticallyImplyLeading: isBackVisible,
      title: SizedBox(
        width: double.infinity,
        height: widget.height - 8,
        child: Center(
          child: TextField(
            focusNode: focusNode,
            controller: _controller,
            onChanged: (query) {
              logIfDebug('query:{$query}');
              if (query != lastQuery) {
                lastQuery = query;
                context.read<SearchViewModel>().searchPagedMovies(query);
              }
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              contentPadding:
                  const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 16.0),
              // isDense: true,
              // constraints: BoxConstraints.tightFor(width: double.maxFinite, height: 80),
              prefixIcon: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(30.0),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  // color: Theme.of(context).appBarTheme.iconTheme!.color!,
                ),
              ),
              suffixIcon: InkWell(
                onTap: () => _controller.clear(),
                borderRadius: BorderRadius.circular(30.0),
                child: const Icon(
                  Icons.clear_rounded,
                  // color: Theme.of(context).appBarTheme.iconTheme!.color!,
                ),
              ),
              hintText: 'Search movies, TV, people',
              filled: true,
              fillColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
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
