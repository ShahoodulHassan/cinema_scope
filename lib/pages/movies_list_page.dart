import 'package:cinema_scope/architecture/config_view_model.dart';
import 'package:cinema_scope/constants.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/image_view.dart';
import 'package:cinema_scope/widgets/ink_well_overlay.dart';
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
              ChangeNotifierProvider(create: (_) => MoviesListViewModel()),
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
    context.read<MoviesListViewModel>().initializePaging(
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
                  child: Selector<MoviesListViewModel, int?>(
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
                context.read<MoviesListViewModel>().pagingController,
            builderDelegate: PagedChildBuilderDelegate<MovieResult>(
              itemBuilder: (_, movie, index) {
                return PosterTile(
                  onTap: () => goToMoviePage(context, movie),
                  title: movie.title,
                  poster: NetworkImageView(
                    movie.posterPath,
                    imageType: ImageType.poster,
                    aspectRatio: Constants.arPoster,
                    topRadius: 4.0,
                    bottomRadius: 4.0,
                  ),
                  subtitle: Row(
                    children: [
                      Visibility(
                        visible: movie.releaseDate != null &&
                            movie.releaseDate!.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            getYearStringFromDate(movie.releaseDate),
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: movie.voteAverage > 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_sharp,
                                size: 20.0,
                                color: Constants.ratingIconColor,
                              ),
                              Text(
                                ' ${applyCommaAndRound(
                                  movie.voteAverage,
                                  1,
                                  false,
                                  true,
                                )}',
                                style: const TextStyle(fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  description: movie.overview.isNotEmpty
                      ? Text(
                          movie.overview,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.0,
                            height: 1.1,
                          ),
                        )
                      : null,
                );
                // return InkWellOverlay(
                //   onTap: () => goToMoviePage(context, movie),
                //   child: IntrinsicHeight(
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const SizedBox(width: 8.0),
                //         SizedBox(
                //           width: (MediaQuery.of(context).size.width) * 0.25,
                //           // height: (MediaQuery.of(context).size.width) * 0.25 / Constants.arPoster,
                //           child: NetworkImageView(
                //             movie.posterPath,
                //             imageType: ImageType.poster,
                //             aspectRatio: Constants.arPoster,
                //             topRadius: 4.0,
                //             bottomRadius: 4.0,
                //           ),
                //         ),
                //         Expanded(
                //           child: Padding(
                //             padding:
                //                 const EdgeInsets.symmetric(horizontal: 8.0),
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                   movie.title,
                //                   maxLines: 2,
                //                   overflow: TextOverflow.ellipsis,
                //                   style: const TextStyle(
                //                     height: 1.2,
                //                     fontSize: 16.0,
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //                 // const SizedBox(height: 0.0),
                //                 Row(
                //                   children: [
                //                     Visibility(
                //                       visible: movie.releaseDate != null &&
                //                           movie.releaseDate!.isNotEmpty,
                //                       child: Padding(
                //                         padding:
                //                             const EdgeInsets.only(right: 16.0),
                //                         child: Text(
                //                           getYearStringFromDate(
                //                               movie.releaseDate),
                //                           textAlign: TextAlign.start,
                //                           style: const TextStyle(
                //                             fontSize: 15.0,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     Visibility(
                //                       visible: movie.voteAverage > 0.0,
                //                       child: Padding(
                //                         padding:
                //                             const EdgeInsets.only(right: 16.0),
                //                         child: Row(
                //                           children: [
                //                             Icon(
                //                               Icons.star_sharp,
                //                               size: 20.0,
                //                               color: Constants.ratingIconColor,
                //                             ),
                //                             Text(
                //                               ' ${applyCommaAndRound(movie.voteAverage, 1, false, true)}'
                //                               // '   (${applyCommaAndRoundNoZeroes(movie.voteCount * 1.0, 0, true)})'
                //                               '',
                //                               style: const TextStyle(
                //                                 // fontWeight: FontWeight.normal,
                //                                 fontSize: 15.0,
                //                                 // height: 1.0,
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //                 const SizedBox(height: 8.0),
                //                 if (movie.overview.isNotEmpty)
                //                   Text(
                //                     movie.overview,
                //                     maxLines: 3,
                //                     overflow: TextOverflow.ellipsis,
                //                     style: const TextStyle(
                //                       fontSize: 14.0,
                //                       height: 1.1,
                //                     ),
                //                   ),
                //                 // Text(getYearStringFromDate(movie.releaseDate)),
                //               ],
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // );
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
