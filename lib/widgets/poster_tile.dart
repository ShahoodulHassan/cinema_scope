import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/gestures.dart';
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
    return IntrinsicHeight(
      child: InkWell(
        onTap: onTap,
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
                      if (subtitle != null) subtitle!,
                      if (description != null) description!,
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

class MoviePosterTile extends StatelessWidget
    with Utilities, CommonFunctions, GenericFunctions {
  final MovieResult movie;

  const MoviePosterTile({required this.movie, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PosterTile(
      onTap: () => goToMoviePageByMovieResult(context, movie),
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
                context.read<ConfigViewModel>().getGenreNamesFromIds(
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

class TvPosterTile extends StatelessWidget
    with Utilities, CommonFunctions, GenericFunctions {
  final TvResult tv;

  const TvPosterTile({required this.tv, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PosterTile(
      onTap: () /*=> goToMoviePage(context, tv)*/ {},
      title: tv.name,
      poster: NetworkImageView(
        tv.posterPath,
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
                if (tv.firstAirDate != null && tv.firstAirDate!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      getYearStringFromDate(tv.firstAirDate),
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                // Visibility(
                //   visible:
                //       tv.firstAirDate != null && tv.firstAirDate!.isNotEmpty,
                //   child: Padding(
                //     padding: const EdgeInsets.only(right: 16.0),
                //     child: Text(
                //       getYearStringFromDate(tv.firstAirDate),
                //       textAlign: TextAlign.start,
                //       style: const TextStyle(fontSize: 15.0),
                //     ),
                //   ),
                // ),
                if (tv.voteAverage > 0.0)
                  Padding(
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
                            tv.voteAverage,
                            1,
                            false,
                            true,
                          )}',
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 0.5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Theme.of(context).primaryColorLight.withOpacity(0.4),
                  ),
                  child: Text(
                    'TV Series',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                // Visibility(
                //   visible: tv.voteAverage > 0.0,
                //   child: Row(
                //     children: [
                //       Icon(
                //         Icons.star_sharp,
                //         size: 20.0,
                //         color: Constants.ratingIconColor,
                //       ),
                //       Text(
                //         ' ${applyCommaAndRound(
                //           tv.voteAverage,
                //           1,
                //           false,
                //           true,
                //         )}',
                //         style: const TextStyle(fontSize: 15.0),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            if (tv.genreIds.isNotEmpty)
              Text(
                context.read<ConfigViewModel>().getGenreNamesFromIds(
                      tv.genreIds,
                      MediaType.tv,
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
      description: tv.overview.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                tv.overview,
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

class PersonPosterTile extends StatelessWidget
    with Utilities, CommonFunctions, GenericFunctions {
  final BasePersonResult person;
  final Widget? subtitle;
  final Widget? description;

  const PersonPosterTile(
      {required this.person, this.subtitle, this.description, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PosterTile(
      onTap: () => goToPersonPage(context, person),
      title: person.name,
      poster: NetworkImageView(
        person.profilePath,
        imageType: ImageType.profile,
        aspectRatio: Constants.arProfile,
        topRadius: 4.0,
        bottomRadius: 4.0,
        heroImageTag: '${person.id}',
      ),
      subtitle: subtitle != null
          ? Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: subtitle,
            )
          : null,
      description: description != null
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: description,
            )
          : null,
    );
  }
}
