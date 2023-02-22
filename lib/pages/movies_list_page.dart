import 'package:cinema_scope/constants.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/poster_tile.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../architecture/movies_list_view_model.dart';
import '../models/movie.dart';
import 'movie_page.dart';

class MoviesListPage extends MultiProvider {
  MoviesListPage({
    super.key,
    // required int id,
    // required String title,
    // required String? year,
    // required double voteAverage,
    // required String? overview,
    required MediaType mediaType,
    List<Genre>? genres,
    List<Keyword>? keywords,
    int? mediaId,
  }) : super(
            providers: [
              ChangeNotifierProvider(create: (_) => MediaListViewModel()),
            ],
            child: _MoviesListPageChild(
              // id: id,
              // title: title,
              // year: year,
              // voteAverage: voteAverage,
              // overview: overview,
              mediaType: mediaType,
              genres: genres,
              keywords: keywords,
              mediaId: mediaId,
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
  }) : super(key: key);

  @override
  State<_MoviesListPageChild> createState() => _MoviesListPageChildState();
}

class _MoviesListPageChildState extends State<_MoviesListPageChild>
    with GenericFunctions, Utilities {
  @override
  void initState() {
    context.read<MediaListViewModel>().initializePaging(
          mediaType: widget.mediaType,
          genreIds: widget.genres?.map((e) => e.id).toList(),
          keywords: widget.keywords,
          mediaId: widget.mediaId,
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
    }
    return title ?? 'Cinema scope';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // floating: true,
            pinned: true,
            // snap: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getAppbarTitle()),
                AnimatedSize(
                  duration: const Duration(milliseconds: 150),
                  child: Selector<MediaListViewModel, int?>(
                    builder: (_, count, __) {
                      if (count == null) return const SizedBox.shrink();
                      return Text(
                        '(${applyCommaAndRoundNoZeroes(count.toDouble(), 0, true)})',
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      );
                    },
                    selector: (_, mlm) => mlm.searchResult?.totalResults,
                  ),
                ),
              ],
            ),
          ),
          PagedSliverList.separated(
            separatorBuilder: (_, index) {
              return Container(
                height: 0.6,
                color: Theme.of(context).primaryColorLight,
              );
              // return SizedBox.fromSize(
              //   size: const Size.fromHeight(8.0),
              // );
            },
            pagingController:
                context.read<MediaListViewModel>().pagingController,
            builderDelegate: PagedChildBuilderDelegate<CombinedResult>(
              itemBuilder: (_, media, index) {
                return media.mediaType == MediaType.movie.name ?
                MoviePosterTile(movie: media) : TvPosterTile(tv: media);
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

  void goToMoviePage(BuildContext context, MovieResult movie,
      {String? destUrl}) {
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
}
