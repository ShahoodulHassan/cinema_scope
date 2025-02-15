import 'package:cinema_scope/providers/configuration_provider.dart';
import 'package:cinema_scope/constants.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/poster_tile.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../providers/media_list_provider.dart';
import '../models/movie.dart';
import '../models/similar_titles_params.dart';
import '../widgets/frosted_app_bar.dart';

class MoviesListPage extends MultiProvider {
  MoviesListPage({
    super.key,
    required MediaType mediaType,
    String? mediaTitle,
    List<Genre>? genres,
    List<Keyword>? keywords,
    int? mediaId,
    SimilarTitlesParams? similarTitlesParams,
  }) : super(
            providers: [
              ChangeNotifierProvider(create: (_) => MediaListProvider()),
            ],
            child: _MoviesListPageChild(
              mediaType: mediaType,
              genres: genres,
              keywords: keywords,
              mediaId: mediaId,
              similarTitlesParams: similarTitlesParams,
              mediaTitle: mediaTitle,
            ));
}

class _MoviesListPageChild extends StatefulWidget {
  // final int id;
  // final String title;
  // final String? year, overview;
  // final double voteAverage;
  final List<Genre>? genres;
  final List<Keyword>? keywords;
  final MediaType mediaType;
  final int? mediaId;
  final SimilarTitlesParams? similarTitlesParams;
  final String? mediaTitle;

  const _MoviesListPageChild({
    Key? key,
    // this.id,
    // this.title,
    // this.year,
    // this.overview,
    // this.voteAverage,
    required this.mediaType,
    this.genres,
    this.keywords,
    this.mediaId,
    this.similarTitlesParams,
    this.mediaTitle,
  }) : super(key: key);

  @override
  State<_MoviesListPageChild> createState() => _MoviesListPageChildState();
}

class _MoviesListPageChildState extends State<_MoviesListPageChild>
    with GenericFunctions, Utilities {

  @override
  void initState() {
    context.read<MediaListProvider>().initializePaging(
          mediaType: widget.mediaType,
          genreIds: widget.genres?.map((e) => e.id).toList(),
          keywords: widget.keywords,
          mediaId: widget.mediaId,
          combinedGenres: context.read<ConfigurationProvider>().combinedGenres,
          similarTitlesParams: widget.similarTitlesParams,
        );
    super.initState();
  }

  String getAppbarTitle() {
    String? title;
    if (widget.keywords != null && widget.keywords!.isNotEmpty) {
      title = widget.keywords!.first.name.toProperCase();
    } else if (widget.genres != null && widget.genres!.isNotEmpty) {
      title = widget.genres!.first.name;
    } else if (widget.mediaId != null) {
      title = 'Recommendations';
    } else if (widget.similarTitlesParams != null) {
      title = 'Similar titles';
    }
    return title ?? 'Cinema scope';
  }

  bool get isPortrait =>
      MediaQuery.orientationOf(context) == Orientation.portrait;

  @override
  Widget build(BuildContext context) {
    // logIfDebug('screenWidth=${MediaQuery.sizeOf(context).width}');
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFrostedAppBar.withSubtitle(
            title: Text(getAppbarTitle()),
            subtitle: widget.similarTitlesParams != null
                ? Text(widget.mediaTitle!)
                : AnimatedSize(
                    duration: const Duration(milliseconds: 150),
                    child: Selector<MediaListProvider, int?>(
                      builder: (_, count, __) {
                        if (count == null) return const SizedBox.shrink();
                        return Text(
                          '(${applyCommaAndRoundNoZeroes(count.toDouble(), 0, true)})',
                        );
                      },
                      selector: (_, mlm) => mlm.searchResult?.totalResults,
                    ),
                  ),
            pinned: true,
            actions: [
              IconButton(
                tooltip: 'Search',
                onPressed: () => openSearchPage(context),
                icon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
          PagedSliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).width ~/ 340,
              mainAxisExtent: mainAxisExtent,
            ),
            // itemExtent: Constants.posterWidth / Constants.arPoster +
            //     Constants.posterVPadding * 2,
            pagingController:
                context.read<MediaListProvider>().pagingController,
            builderDelegate: PagedChildBuilderDelegate<CombinedResult>(
              itemBuilder: (_, media, index) {
                return media.mediaType == MediaType.movie.name
                    ? MoviePosterTile(movie: media)
                    : TvPosterTile(tv: media);
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
    );
  }

  double get mainAxisExtent {
    return (Constants.posterWidth / Constants.arPoster) +
        (Constants.posterVPadding * 2);
  }
}
