import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_scope/architecture/movie_view_model.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/movie.dart';

class MoviePage extends ChangeNotifierProvider<MovieViewModel> {
  MoviePage(
      String title, String? sourceUrl, String? destUrl, String heroImageTag,
      {super.key, required int id})
      : super(
            create: (_) => MovieViewModel(),
            child:
                _MoviePageChild(id, title, sourceUrl, destUrl, heroImageTag));
}

class _MoviePageChild extends StatefulWidget {
  final int id;

  final String title, heroImageTag;
  final String? sourceUrl, destUrl;

  const _MoviePageChild(
      this.id, this.title, this.sourceUrl, this.destUrl, this.heroImageTag,
      {Key? key})
      : super(key: key);

  @override
  State<_MoviePageChild> createState() => _MoviePageChildState();
}

class _MoviePageChildState extends State<_MoviePageChild>
    with GenericFunctions, Utilities {
  late final String? sourceUrl = widget.sourceUrl;
  late final String? destUrl = widget.destUrl;
  late final String heroImageTag = widget.heroImageTag;

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
                getAppbarTitle(widget.title),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageView(
                      widget.sourceUrl, widget.destUrl, widget.heroImageTag),
                  // getImageView(movie),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Selector<MovieViewModel, Movie?>(
              selector: (_, mvm) => mvm.movie,
              builder: (_, movie, __) {
                logIfDebug('builder called with movie:$movie');
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
}

class ImageView extends StatelessWidget with GenericFunctions {
  final String? sourceUrl, destUrl;
  final String heroImageTag;

  const ImageView(this.sourceUrl, this.destUrl, this.heroImageTag, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');
    String? loadableUrl;
    Widget child = Image.asset('assets/images/placeholder.png');
    if (sourceUrl != null) {
      loadableUrl = sourceUrl;
      if (destUrl != null && destUrl != sourceUrl) {
        loadableUrl = destUrl;
      }
      logIfDebug('sourceUrl:$sourceUrl, destUrl:$destUrl, '
          'loadableUrl:$loadableUrl');
      String sourcePath = sourceUrl!.split("/").last;
      String destPath = loadableUrl!.split("/").last;
      logIfDebug('hasKey: ${imageCache.containsKey(loadableUrl)}');
      if (loadableUrl != sourceUrl) {
        Widget placeholderView = Image.network(
          sourceUrl!,
          fit: sourcePath == destPath ? BoxFit.fill : BoxFit.cover,
        );
        if (sourcePath != destPath) {
          placeholderView = ClipRRect(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: placeholderView,
            ),
          );
        }
        child = CachedNetworkImage(
          imageUrl: loadableUrl,
          placeholder: (_, url) => placeholderView,
          fadeOutDuration:
              Duration(milliseconds: sourcePath == destPath ? 1 : 300),
          fadeInDuration:
              Duration(milliseconds: sourcePath == destPath ? 1 : 700),
          fit: BoxFit.fill,
        );
      } else {
        child = Image.network(
          loadableUrl,
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
        tag: heroImageTag,
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
