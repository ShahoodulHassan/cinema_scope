import 'package:cinema_scope/architecture/hero_view_model.dart';
import 'package:cinema_scope/architecture/movie_view_model.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../architecture/config_view_model.dart';
import '../constants.dart';
import '../models/movie.dart';

class MoviePage extends ChangeNotifierProvider<MovieViewModel> {
  // final String heroTag;

  MoviePage(/*this.heroTag, */ String? sourceUrl, String? destUrl,
      {super.key, required int id})
      : super(
            create: (_) => MovieViewModel(),
            child: _MoviePageChild(id /*, heroTag*/, sourceUrl, destUrl));
}

class _MoviePageChild extends StatefulWidget {
  final int id;

  // final String heroTag;
  final String? sourceUrl, destUrl;

  const _MoviePageChild(this.id, this.sourceUrl, this.destUrl,
      /*this.heroTag, */ {Key? key})
      : super(key: key);

  @override
  State<_MoviePageChild> createState() => _MoviePageChildState();
}

class _MoviePageChildState extends State<_MoviePageChild>
    with GenericFunctions, Utilities {
  // late final MovieViewModel mvm;

  @override
  void initState() {
    context.read<MovieViewModel>().getMovieWithDetail(widget.id);
    super.initState();
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
                // getAppbarTitle('Search movies'),
                Selector<MovieViewModel, String>(
                  builder: (_, title, __) => Visibility(
                      visible: title.isNotEmpty, child: getAppbarTitle(title)),
                  selector: (_, mvm) => mvm.movie?.movieTitle ?? '',
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Selector<MovieViewModel, Movie?>(
              selector: (_, mvm) => mvm.movie,
              builder: (_, movie, __) {
                logIfDebug('builder called with movie:$movie');
                return Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getImageView(movie),
                      // getBackdropView(movie),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          movie?.movieTitle ?? '',
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          getYearStringFromDate(movie?.releaseDate),
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      const ExpandableSynopsis(),
                      getGenres(movie),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding getGenres(Movie? movie) {
    final genres = movie?.genres;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          // padding: const EdgeInsets.symmetric(horizontal: 16.0),
          separatorBuilder: (_, index) {
            return const SizedBox(
              width: 8,
            );
          },
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            final genre = genres?[index];
            if (genre != null) {
              return Chip(
                backgroundColor:
                    Theme.of(context).primaryColorLight.withOpacity(0.3),
                // padding: EdgeInsets.zero,
                materialTapTargetSize: null,
                label: Text(
                  genre.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(
                    color: Theme.of(context).primaryColorDark,
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

  // Widget getBackdropView(Movie? movie) {
  //   final cvm = context.read<ConfigViewModel>();
  //   String base = cvm.apiConfig!.images.baseUrl;
  //   String size = cvm.apiConfig!.images.backdropSizes[1];
  //   String url = '$base$size${widget.imageUrl}';
  //   logIfDebug('first url:$url');
  //   if (movie != null) {
  //     if (movie.backdropPath != null) {
  //       // size = cvm.apiConfig!.images.backdropSizes[1];
  //       url = '$base$size${movie.backdropPath}';
  //     } else if (movie.images.posters.isNotEmpty) {
  //       var poster = movie.images.posters.first;
  //       size = cvm.apiConfig!.images.posterSizes.last;
  //       url = '$base$size${poster.filePath}';
  //     }
  //   }
  //   logIfDebug('url:$url');
  //   return getImageView(url: url);
  // }

  String? getImageUrl(Movie? movie) {
    String? imageUrl;
    final cvm = context.read<ConfigViewModel>();
    String base = cvm.apiConfig!.images.baseUrl;
    String size = cvm.apiConfig!.images.backdropSizes[1];

    if (movie?.backdropPath != null) {
      imageUrl = '$base$size${movie?.backdropPath}';
    } else if (movie?.posterPath != null) {
      size = cvm.apiConfig!.images.posterSizes.last;
      imageUrl = '$base$size${movie?.posterPath}';
    }
    logIfDebug('url:$imageUrl');
    return imageUrl;
  }

  Widget getImageView(Movie? movie) {
    var loadableUrl = getImageUrl(movie);
    Widget Function(BuildContext, Widget, ImageChunkEvent?)? builder;
    ImageFrameBuilder? frameBuilder;
    if (loadableUrl != null && loadableUrl != widget.sourceUrl) {
      builder = (context, child, progress) {
        logIfDebug('loadableProgress:$progress');
        if (progress == null) {
          return child;
        }
        return Image.network(
          widget.sourceUrl!,
          fit: BoxFit.fill,
        );
      };
    }
    if (loadableUrl != null && loadableUrl != widget.sourceUrl) {
      frameBuilder = (context, child, frame, isSynchronous) {
        logIfDebug('loadableSync:$isSynchronous');
        // if (isSynchronous) {
        return child;
        // }
        // return Image.network(widget.imageUrl!);
      };
    }

    // logIfDebug(
    //     'loadableUrl:$loadableUrl, receivedUrl:${widget.sourceUrl}, builder:$builder');
    // var child = widget.imageUrl != null
    //     ? FadeInImage(
    //         image: NetworkImage(loadableUrl ?? widget.imageUrl!),
    //         placeholder: NetworkImage(widget.imageUrl!),
    //         // loadingBuilder: builder,
    //         // frameBuilder: frameBuilder,
    //         imageErrorBuilder: (_, error, stacktrace) {
    //           logIfDebug('image load error:$stacktrace');
    //           return Image.asset('assets/images/placeholder.png');
    //         },
    //         fit: BoxFit.fill,
    //       )
    //     : Image.asset('assets/images/placeholder.png');
    Widget child = Image.asset('assets/images/placeholder.png');
    if (widget.sourceUrl != null) {
      loadableUrl = widget.sourceUrl;
      if (widget.destUrl != null && widget.destUrl != widget.sourceUrl) {
        loadableUrl = widget.destUrl;
      }
      logIfDebug(
          'sourceUrl:${widget.sourceUrl}, destUrl:${widget.destUrl}, '
              'loadableUrl:$loadableUrl');
      if (widget.sourceUrl != loadableUrl) {
        child = FadeInImage(
          image: NetworkImage(loadableUrl!),
          placeholder: NetworkImage(widget.sourceUrl!),
          // loadingBuilder: builder,
          // frameBuilder: frameBuilder,
          imageErrorBuilder: (_, error, stacktrace) {
            logIfDebug('image load error:$stacktrace');
            return Image.asset('assets/images/placeholder.png');
          },
          fit: BoxFit.fill,
        );
      } else {
        child = Image.network(
          loadableUrl!,
          errorBuilder: (_, error, stacktrace) {
            logIfDebug('image load error:$stacktrace');
            return Image.asset('assets/images/placeholder.png');
          },
          fit: BoxFit.fill,
        );
      }
    }
    return AspectRatio(
      aspectRatio: Constants.arBackdrop,
      // That's the actual aspect ratio of TMDB posters
      child: Hero(
        tag: context.read<HeroViewModel>().heroImageTag,
        // flightShuttleBuilder: (a, b, c, d, e) {
        //   return widget.sourceUrl != null
        //       ? Image.network(widget.sourceUrl!, fit: BoxFit.fill)
        //       : Padding(
        //           padding: const EdgeInsets.all(24.0),
        //           child: Image.asset(
        //             'assets/images/placeholder.png',
        //           ),
        //         );
        // },
        child: child,
      ),
    );
  }
}

class ExpandableSynopsis extends StatefulWidget {
  const ExpandableSynopsis({Key? key}) : super(key: key);

  @override
  State<ExpandableSynopsis> createState() => _ExpandableSynopsisState();
}

class _ExpandableSynopsisState extends State<ExpandableSynopsis>
    with GenericFunctions {
  final colSize = 14.0;
  final expSize = 16.0;
  final colHeight = 1.2;
  final expHeight = 1.3;
  late var height = colHeight;
  late var fontSize = colSize;

  @override
  Widget build(BuildContext context) {
    logIfDebug(
        'build called with movie:${context.read<MovieViewModel>().movie}');
    return Selector<MovieViewModel, String>(
      builder: (_, synopsis, __) {
        if (synopsis.isNotEmpty) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: ExpandableText(
              synopsis,
              expandText: 'Show more',
              collapseText: 'Show less',
              maxLines: 2,
              linkColor: Colors.blue.shade600,
              animation: true,
              animationCurve: Curves.easeInOut,
              expandOnTextTap: true,
              collapseOnTextTap: true,
              onExpandedChanged: (isExpanded) {
                setState(() {
                  height = isExpanded ? expHeight : colHeight;
                  fontSize = isExpanded ? expSize : colSize;
                });
              },
              style: TextStyle(height: height, fontSize: fontSize),
            ),
          );
        }
        return const SizedBox.shrink();
      },
      selector: (_, mvm) => mvm.synopsis,
    );
  }
}
