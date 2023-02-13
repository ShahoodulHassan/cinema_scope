import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:cinema_scope/models/person.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
  late final FilmographyViewModel fvm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => fvm = context.read<FilmographyViewModel>()
        ..initialize(
          widget.combinedCredits,
          context.read<ConfigViewModel>().combinedGenres,
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lighten2(Theme.of(context).primaryColorLight, 78),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
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
            bottom: const _FilterBar(),
          ),
          // SliverPersistentHeader(
          //   delegate: _FilterDelegate(),
          //   pinned: true,
          //   // floating: true,
          // ),
          // Selector<
          //     FilmographyViewModel,
          //     Tuple3<Map<String, bool?>, Map<String, bool?>,
          //         Map<String, bool?>>>(
          //   builder: (_, tuple, __) {
          //     var depts = tuple.item1;
          //     var types = tuple.item2;
          //     var genres = tuple.item3;
          //     if (depts.isEmpty && types.isEmpty && genres.isEmpty) {
          //       return const SliverToBoxAdapter(child: SizedBox.shrink());
          //     } else {
          //       return SliverToBoxAdapter(
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 8.0),
          //           child: Column(
          //             children: [
          //               if (depts.isNotEmpty)
          //                 SizedBox(
          //                   height: 46.0,
          //                   child: Row(
          //                     children: [
          //                       if (types.isNotEmpty)
          //                         ListView.separated(
          //                           itemBuilder: (_, index) {
          //                             var item = types.entries.elementAt(index);
          //                             var label = item.key == MediaType.tv.name
          //                                 ? item.key.toUpperCase()
          //                                 : item.key.toProperCase();
          //                             var selected =
          //                                 item.value == null || item.value!;
          //                             return buildFilterChip(
          //                               label,
          //                               context,
          //                               selected,
          //                                   (isSelected) {
          //                                 fvm.toggleMediaTypes(
          //                                     item.key, isSelected);
          //                               },
          //                             );
          //                           },
          //                           shrinkWrap: true,
          //                           physics: const NeverScrollableScrollPhysics(),
          //                           padding: const EdgeInsets.only(left: 8.0),
          //                           separatorBuilder: (_, __) =>
          //                           const SizedBox(width: 6.0),
          //                           itemCount: types.length,
          //                           scrollDirection: Axis.horizontal,
          //                         ),
          //                       if (types.isNotEmpty && depts.isNotEmpty)
          //                         Padding(
          //                           padding: const EdgeInsets.symmetric(
          //                               horizontal: 8.0),
          //                           child: Container(
          //                             height: 30.0,
          //                             width: 4.0,
          //                             decoration: BoxDecoration(
          //                               color: Theme.of(context)
          //                                   .primaryColorDark
          //                                   .withOpacity(0.3),
          //                               borderRadius: BorderRadius.circular(50.0),
          //                             ),
          //                           ),
          //                         ),
          //                       // Padding(
          //                       //   padding:
          //                       //       const EdgeInsets.symmetric(horizontal: 8.0),
          //                       //   child: Text(
          //                       //     '|',
          //                       //     style: const TextStyle(
          //                       //         fontWeight: FontWeight.bold),
          //                       //   ),
          //                       // ),
          //                       Expanded(
          //                         child: ListView.separated(
          //                           itemBuilder: (_, index) {
          //                             var item = depts.entries.elementAt(index);
          //                             var label = item.key;
          //                             var selected =
          //                                 item.value == null || item.value!;
          //                             return buildFilterChip(
          //                               label,
          //                               context,
          //                               selected,
          //                                   (isSelected) {
          //                                 fvm.toggleDepartments(
          //                                     label, isSelected);
          //                               },
          //                             );
          //                           },
          //                           padding: EdgeInsets.only(
          //                             left: (types.isNotEmpty ? 0.0 : 8.0),
          //                             right: 8.0,
          //                           ),
          //                           separatorBuilder: (_, __) =>
          //                           const SizedBox(width: 6.0),
          //                           itemCount: depts.length,
          //                           scrollDirection: Axis.horizontal,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               if (genres.isNotEmpty)
          //                 SizedBox(
          //                   height: 46.0,
          //                   child: Row(
          //                     children: [
          //                       // Padding(
          //                       //   padding:
          //                       //       const EdgeInsets.symmetric(horizontal: 8.0),
          //                       //   child: Text(
          //                       //     'Genres'.toUpperCase(),
          //                       //     style: const TextStyle(
          //                       //         fontWeight: FontWeight.bold),
          //                       //   ),
          //                       // ),
          //                       Expanded(
          //                         child: ListView.separated(
          //                           itemBuilder: (_, index) {
          //                             var item = genres.entries.elementAt(index);
          //                             var label = item.key;
          //                             var selected =
          //                                 item.value == null || item.value!;
          //                             return buildFilterChip(
          //                               label,
          //                               context,
          //                               selected,
          //                                   (isSelected) {
          //                                 fvm.toggleGenres(label, isSelected);
          //                               },
          //                             );
          //                           },
          //                           padding: const EdgeInsets.symmetric(
          //                               horizontal: 8.0),
          //                           separatorBuilder: (_, __) =>
          //                           const SizedBox(width: 6.0),
          //                           itemCount: genres.length,
          //                           scrollDirection: Axis.horizontal,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               // if (types.isNotEmpty)
          //               //   SizedBox(
          //               //     height: 52.0,
          //               //     child: Row(
          //               //       children: [
          //               //         Padding(
          //               //           padding:
          //               //               const EdgeInsets.symmetric(horizontal: 8.0),
          //               //           child: Text(
          //               //             'Media types'.toUpperCase(),
          //               //             style: const TextStyle(
          //               //                 fontWeight: FontWeight.bold),
          //               //           ),
          //               //         ),
          //               //         Expanded(
          //               //           child: ListView.separated(
          //               //             itemBuilder: (_, index) {
          //               //               var item = types.entries.elementAt(index);
          //               //               var label = item.key == MediaType.tv.name
          //               //                   ? item.key.toUpperCase()
          //               //                   : item.key.toProperCase();
          //               //               var selected =
          //               //                   item.value == null || item.value!;
          //               //               return buildFilterChip(
          //               //                 label,
          //               //                 context,
          //               //                 selected,
          //               //                 (isSelected) {
          //               //                   fvm.toggleMediaTypes(
          //               //                       item.key, isSelected);
          //               //                 },
          //               //               );
          //               //             },
          //               //             padding: const EdgeInsets.only(right: 8.0),
          //               //             separatorBuilder: (_, __) =>
          //               //                 const SizedBox(width: 4.0),
          //               //             itemCount: types.length,
          //               //             scrollDirection: Axis.horizontal,
          //               //           ),
          //               //         ),
          //               //       ],
          //               //     ),
          //               //   ),
          //             ],
          //           ),
          //         ),
          //       );
          //     }
          //   },
          //   selector: (_, fvm) => Tuple3(
          //     fvm.availableDepartments,
          //     fvm.availableMediaTypes,
          //     fvm.availableGenreNames,
          //   ),
          // ),
          Selector<FilmographyViewModel, List<CombinedResult>>(
            selector: (_, fvm) => fvm.results,
            builder: (_, results, __) {
              logIfDebug(results);
              if (results.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              } else {
                // return ImplicitlyAnimatedList<CombinedResult>(
                //   items: results,
                //   itemBuilder: (context, animation, item, index) {
                //     return SizeFadeTransition(
                //       sizeFraction: 0.7,
                //       curve: Curves.easeInOut,
                //       animation: animation,
                //       child: CombinedPosterTile(result: item),
                //     );
                //   },
                //   insertDuration: const Duration(milliseconds: 300),
                //   removeDuration: const Duration(milliseconds: 300),
                //   areItemsTheSame: (a, b) => a.id == b.id,
                // );
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

class _FilterBar extends StatelessWidget implements PreferredSizeWidget {
  final double rowHeight = 46.0;
  final double verticalPadding = 8.0;

  const _FilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<
        FilmographyViewModel,
        Tuple3<Map<String, FilterState>, Map<String, FilterState>,
            Map<String, FilterState>>>(
      builder: (_, tuple, __) {
        var depts = tuple.item1;
        var types = tuple.item2;
        var genres = tuple.item3;
        if (depts.isEmpty && types.isEmpty && genres.isEmpty) {
          return const SizedBox.shrink();
        } else {
          var fvm = context.read<FilmographyViewModel>();
          return Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Column(
              children: [
                if (depts.isNotEmpty)
                  SizedBox(
                    height: rowHeight,
                    child: Row(
                      children: [
                        if (types.isNotEmpty)
                          buildMediaTypeList(context, types, fvm),
                        if (types.isNotEmpty && depts.isNotEmpty)
                          buildSeparator(context),
                        if (depts.isNotEmpty)
                          buildDepartmentsList(context, depts, fvm, types),
                      ],
                    ),
                  ),
                if (genres.isNotEmpty) buildGenresList(context, genres, fvm),
              ],
            ),
          );
        }
      },
      selector: (_, fvm) => Tuple3(
        fvm.availableDepartments,
        fvm.availableMediaTypes,
        fvm.availableGenreNames,
      ),
    );
  }

  Widget buildSeparator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 30.0,
        width: 4.0,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  Widget buildGenresList(BuildContext context, Map<String, FilterState> genres,
      FilmographyViewModel fvm) {
    return SizedBox(
      height: rowHeight,
      child: Row(
        children: [
          Expanded(
            child: buildListView(
              context,
              itemBuilder: (_, index) {
                var item = genres.entries.elementAt(index);
                var label = item.key;
                var selected = item.value != FilterState.unselected;
                return buildFilterChip(
                  label,
                  context,
                  selected,
                  (isSelected) {
                    if (item.value != FilterState.forceSelected) {
                      fvm.toggleGenres(item, isSelected);
                    }
                  },
                );
              },
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: genres.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDepartmentsList(
      BuildContext context,
      Map<String, FilterState> depts,
      FilmographyViewModel fvm,
      Map<String, FilterState> types) {
    return Expanded(
      child: buildListView(
        context,
        itemBuilder: (_, index) {
          var item = depts.entries.elementAt(index);
          var label = item.key;
          var selected = item.value != FilterState.unselected;
          return buildFilterChip(
            label,
            context,
            selected,
            (isSelected) {
              if (item.value != FilterState.forceSelected) {
                fvm.toggleDepartments(item, isSelected);
              }
            },
          );
        },
        itemCount: depts.length,
        padding: EdgeInsets.only(
          left: (types.isNotEmpty ? 0.0 : 8.0),
          right: 8.0,
        ),
      ),
    );
  }

  Widget buildMediaTypeList(BuildContext context,
      Map<String, FilterState> types, FilmographyViewModel fvm) {
    return buildListView(
      context,
      itemBuilder: (_, index) {
        var item = types.entries.elementAt(index);
        var label = item.key == MediaType.tv.name
            ? item.key.toUpperCase()
            : item.key.toProperCase();
        var selected = item.value != FilterState.unselected;
        return buildFilterChip(
          label,
          context,
          selected,
          (isSelected) {
            if (item.value != FilterState.forceSelected) {
              fvm.toggleMediaTypes(item, isSelected);
            }
          },
        );
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 8.0),
      itemCount: types.length,
    );
  }

  ListView buildListView(
    BuildContext context, {
    required NullableIndexedWidgetBuilder itemBuilder,
    required int itemCount,
    required EdgeInsetsGeometry padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return ListView.separated(
      itemBuilder: itemBuilder,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      separatorBuilder: (_, __) => const SizedBox(width: 6.0),
      itemCount: itemCount,
      scrollDirection: Axis.horizontal,
    );
  }

  Widget buildFilterChip(
    String label,
    BuildContext context,
    bool selected,
    Function(bool) onSelected,
  ) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Theme.of(context).primaryColorDark,
          ),
        ),
        side: selected
            ? null
            : BorderSide(
                color: Theme.of(context).primaryColorDark,
                width: 0.7,
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        // avatar: selected
        //     ? const Icon(
        //         Icons.check_rounded,
        //         size: 20.0,
        //         color: Colors.white,
        //       )
        //     : null,
        // visualDensity: VisualDensity(horizontal: 0.0, vertical: -1,),
        selected: selected,
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.8),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        showCheckmark: false,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Size get preferredSize => Size(0, rowHeight * 2 + verticalPadding * 2);
}

class CombinedPosterTile extends StatelessWidget
    with Utilities, CommonFunctions, GenericFunctions {
  final CombinedResult result;

  const CombinedPosterTile({required this.result, Key? key}) : super(key: key);

  bool get isTv => result.mediaType == MediaType.tv.name;

  @override
  Widget build(BuildContext context) {
    var deptJobsString =
        context.read<FilmographyViewModel>().getDeptJobString(result.id);
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
      description: deptJobsString.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                deptJobsString,
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
