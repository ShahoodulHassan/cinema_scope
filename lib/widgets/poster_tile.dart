import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/ink_well_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../architecture/config_view_model.dart';
import '../constants.dart';
import 'image_view.dart';

class PosterTile extends StatelessWidget {
  final double posterWidthRatio = 0.25;
  final Function()? onTap;
  final String title;
  final int titleMaxLines;
  final Widget poster;
  final Widget? subtitle, description;

  const PosterTile({
    required this.title,
    this.titleMaxLines = 2,
    required this.poster,
    this.subtitle,
    this.description,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellOverlay(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width) * posterWidthRatio,
                // height: (MediaQuery.of(context).size.width) * 0.25 / Constants.arPoster,
                child: poster,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: titleMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          height: 1.2,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SizedBox(height: 0.0),
                      if (subtitle != null) subtitle!,
                      if (description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: description!,
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MoviePosterTile extends StatelessWidget with Utilities, CommonFunctions,
    GenericFunctions {

  final MovieResult movie;

  const MoviePosterTile({required this.movie, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
              ],
            ),
            if (movie.genreIds.isNotEmpty)
              Text(
                context
                    .read<ConfigViewModel>()
                    .getGenreNamesFromIds(
                  movie.genreIds,
                  MediaType.movie,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.0,
                  height: 1.2,
                ),
              ),
          ],
        ),
      ),
      description: movie.overview.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          movie.overview,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14.0,
            height: 1.1,
          ),
        ),
      )
          : null,
    );
  }
}

