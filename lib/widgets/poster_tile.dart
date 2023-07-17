import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../architecture/config_view_model.dart';
import '../constants.dart';
import 'image_view.dart';

class PosterTile extends StatelessWidget with GenericFunctions {
  final Function()? onTap;
  final String title;
  final int titleMaxLines;
  final Widget poster;
  final Widget? subtitle, description;
  final double posterWidth;
  final bool overlay;

  const PosterTile({
    required this.title,
    this.titleMaxLines = 2,
    required this.poster,
    this.posterWidth = Constants.posterWidth,
    this.subtitle,
    this.description,
    this.onTap,
    this.overlay = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    // logIfDebug('build called with isPortrait=$isPortrait');
    final content = Ink(
      padding: const EdgeInsets.all(Constants.posterVPadding),
      // height:
      //     posterWidth / Constants.arPoster + Constants.posterVPadding * 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: posterWidth,
            child: poster,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: Constants.posterVPadding),
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
                      fontWeight: FontWeightExt.semibold,
                      color: Colors.black87,
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
    );
    return /*snapshot.connectionState == ConnectionState.done
        ? */
        Stack(
      children: [
        overlay
            ? content
            : InkWell(
                onTap: onTap,
                child: content,
              ),
        if (overlay)
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              // color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
              ),
            ),
          ),
      ],
    );
  }
}

class MoviePosterTile extends StatelessWidget
    with Utilities, GenericFunctions, CommonFunctions {
  final CombinedResult movie;

  const MoviePosterTile({required this.movie, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PosterTile(
      onTap: () {
        return goToMoviePage(
          context,
          id: movie.id,
          title: movie.mediaTitle,
          releaseDate: movie.mediaReleaseDate,
          overview: movie.overview,
          voteAverage: movie.voteAverage,
        );
      },
      title: movie.mediaTitle,
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
                  visible: movie.yearString.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      movie.yearString,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 15.0,
                        height: 1.2,
                      ),
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
                movie.genreNamesString,
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
                  height: 1.2,
                ),
              ),
            )
          : null,
    );
  }
}

// TODO See if it can be merged with MoviePosterTile to form a MediaPosterTile
// TODO Show Tv specific properties like year range, episode count etc. as well
class TvPosterTile extends StatelessWidget
    with Utilities, GenericFunctions, CommonFunctions {
  final CombinedResult tv;

  const TvPosterTile({required this.tv, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PosterTile(
      onTap: () => goToTvPage(
        context,
        id: tv.id,
        title: tv.mediaTitle,
        overview: tv.overview,
        releaseDate: tv.mediaReleaseDate,
        voteAverage: tv.voteAverage,
      ),
      title: tv.mediaTitle,
      poster: Stack(
        children: [
          NetworkImageView(
            tv.posterPath,
            imageType: ImageType.poster,
            aspectRatio: Constants.arPoster,
            topRadius: 4.0,
            bottomRadius: 4.0,
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.0),
                  bottomLeft: Radius.circular(4.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 9.0,
              ),
              child: const Text(
                'TV',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeightExt.semibold,
                  fontSize: 12.0,
                  // height: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (tv.yearString.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      tv.yearString,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
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
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 4.0,
                //     vertical: 0.5,
                //   ),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(4.0),
                //     color: kPrimaryContainer.withOpacity(0.6),
                //   ),
                //   child: Text(
                //     'TV Series',
                //     style: TextStyle(
                //       fontSize: 12.0,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.grey.shade800,
                //     ),
                //   ),
                // ),
              ],
            ),
            if (tv.genreIds.isNotEmpty)
              Text(
                tv.genreNamesString,
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
                  height: 1.2,
                ),
              ),
            )
          : null,
    );
  }
}

class PersonPosterTile extends StatelessWidget
    with Utilities, GenericFunctions, CommonFunctions {
  final BasePersonResult person;
  final Widget? subtitle;
  final Widget? description;
  final bool overlay;

  const PersonPosterTile({
    required this.person,
    this.subtitle,
    this.description,
    this.overlay = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PosterTile(
      onTap: () {
        context.unfocus();
        goToPersonPage(context, person);
      },
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
      overlay: overlay,
    );
  }
}
