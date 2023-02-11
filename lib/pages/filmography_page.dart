import 'package:cinema_scope/models/person.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../architecture/config_view_model.dart';
import '../architecture/filmography_view_model.dart';
import '../constants.dart';
import '../widgets/image_view.dart';
import '../widgets/poster_tile.dart';

class FilmographyPage extends MultiProvider {
  FilmographyPage({
    super.key,
    required CombinedCredits combinedCredits,
    required int id,
    required String name,
  }) : super(
            providers: [
              ChangeNotifierProvider(create: (_) => FilmographyViewModel()),
            ],
            child: _FilmographyPageChild(
              id: id,
              name: name,
              combinedCredits: combinedCredits,
            ));
}

class _FilmographyPageChild extends StatefulWidget {
  final int id;
  final String name;
  final CombinedCredits combinedCredits;

  const _FilmographyPageChild({
    required this.id,
    required this.name,
    required this.combinedCredits,
    Key? key,
  }) : super(key: key);

  @override
  State<_FilmographyPageChild> createState() => _FilmographyPageChildState();
}

class _FilmographyPageChildState extends State<_FilmographyPageChild>
    with GenericFunctions, Utilities, CommonFunctions {
  @override
  void initState() {
    super.initState();
    context.read<FilmographyViewModel>().initialize(widget.combinedCredits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lighten2(Theme.of(context).primaryColorLight, 78),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // floating: true,
            pinned: true,
            // snap: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filmography'),
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          Selector<FilmographyViewModel, List<CombinedResult>>(
            selector: (_, fvm) => fvm.results,
            builder: (_, results, __) {
              logIfDebug(results);
              if (results.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) {
                      var result = results[index];
                      return CombinedPosterTile(result: result);
                    },
                    childCount: results.length,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class CombinedPosterTile extends StatelessWidget
    with Utilities, CommonFunctions, GenericFunctions {
  final CombinedResult result;

  const CombinedPosterTile({required this.result, Key? key}) : super(key: key);

  bool get isTv => result.mediaType == MediaType.tv.name;

  @override
  Widget build(BuildContext context) {
    return PosterTile(
      onTap: () {
        if (isTv) {
        } else {
          goToMoviePage(
            context,
            id: result.id,
            title: result.mediaTitle,
            releaseDate: result.mediaReleaseDate,
            voteAverage: result.voteAverage,
            overview: result.overview,
          );
        }
      },
      title: result.mediaTitle,
      poster: NetworkImageView(
        result.posterPath,
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
                  visible: result.mediaReleaseDate != null &&
                      result.mediaReleaseDate!.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      getYearStringFromDate(result.mediaReleaseDate),
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                ),
                if (result.voteAverage > 0.0)
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
                            result.voteAverage,
                            1,
                            false,
                            true,
                          )}',
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                if (isTv)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 0.5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.4),
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
              ],
            ),
            if (result.genreIds.isNotEmpty)
              Text(
                context.read<ConfigViewModel>().getGenreNamesFromIds(
                      result.genreIds,
                      isTv ? MediaType.tv : MediaType.movie,
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
      description: result.overview.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                context.read<FilmographyViewModel>().getRolesWithJobs(result.id),
                maxLines: 3,
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
