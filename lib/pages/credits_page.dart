import 'package:cinema_scope/architecture/credits_view_model.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../architecture/filmography_view_model.dart';
import '../constants.dart';
import '../main.dart';
import '../models/movie.dart';
import '../widgets/frosted_app_bar.dart';
import '../widgets/poster_tile.dart';

class CreditsPage extends MultiProvider {
  CreditsPage({
    super.key,
    required Credits credits,
    required int id,
    required String name,
    String? title,
  }) : super(
            providers: [
              ChangeNotifierProvider(create: (_) => CreditsViewModel(credits)),
            ],
            child: _CreditsPageChild(
              id: id,
              name: name,
              credits: credits,
              title: title ?? 'Cast & crew',
            ));
}

class _CreditsPageChild extends StatefulWidget {
  final int id;
  final String name;
  final Credits credits;
  final String title;

  const _CreditsPageChild({
    required this.id,
    required this.name,
    required this.credits,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<_CreditsPageChild> createState() => _CreditsPageChildState();
}

class _CreditsPageChildState extends State<_CreditsPageChild>
    with GenericFunctions, Utilities, CommonFunctions {
  late final cast = widget.credits.cast;
  late final crew = widget.credits.crew;

  late final tabCount = cast.isNotEmpty && crew.isNotEmpty ? tabs.length : 1;

  final tabs = const [
    Tab(
      text: 'CAST',
    ),
    Tab(
      text: 'CREW',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<CreditsViewModel>().initialize());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabCount,
      child: Scaffold(
        body: NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (context, __) {
            return [
              /// Helps make pinned / sticky headers inside a TabBarView
              /// Followed the pattern mentioned in
              /// https://gist.github.com/letsar/2e3cc98d328b3e84170abacf154e545f
              /*SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: */
              SliverFrostedAppBar.withSubtitle(
                title: Text(widget.title),
                subtitle: Text(widget.name),
                floating: true,
                pinned: true,
                actions: [
                  IconButton(
                    tooltip: 'Search',
                    onPressed: () => openSearchPage(context),
                    icon: const Icon(Icons.search_rounded),
                  ),
                ],
                bottom: crew.isNotEmpty && cast.isNotEmpty
                    ? TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: kPrimary,
                        labelColor: Colors.black87,
                        labelStyle: TextStyle(
                          fontWeight: weightBold,
                          letterSpacing: 1.0,
                        ),
                        tabs: tabs,
                      )
                    : null,
              ),
              /*),*/
            ];
          },
          body: Builder(
            builder: (context) => TabBarView(
              children: [
                if (cast.isNotEmpty)
                  CustomScrollView(
                    slivers: [
                      // SliverObstructionInjector(
                      //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      //       context),
                      // ),
                      getSliverTabData<Cast>(context),
                    ],
                  ),
                if (crew.isNotEmpty)
                  CustomScrollView(
                    slivers: [
                      // SliverObstructionInjector(
                      //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      //       context),
                      // ),
                      // SliverStickyHeader(
                      //   header: Selector<CreditsViewModel,
                      //       Map<String, FilterState>>(
                      //     selector: (_, cvm) => cvm.availableDepartments,
                      //     builder: (_, filters, __) {
                      //       return (filters.length <= 1)
                      //           ? Container()
                      //           : _FilterBar(filters);
                      //     },
                      //   ),
                      //   sliver: getSliverTabData<Crew>(context),
                      // ),
                      SliverPinnedHeader(
                        child: Selector<CreditsViewModel,
                            Map<String, FilterState>>(
                          selector: (_, cvm) => cvm.availableDepartments,
                          builder: (_, filters, __) {
                            return (filters.length <= 1)
                                ? Container()
                                : _FilterBar(filters);
                          },
                        ),
                      ),
                      getSliverTabData<Crew>(context),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Selector<CreditsViewModel, List<T>> getSliverTabData<T extends BaseCredit>(
      BuildContext context) {
    return Selector<CreditsViewModel, List<T>>(
      selector: (_, cvm) {
        return T.toString() == (Cast).toString()
            ? (cvm.cast as List<T>)
            : (cvm.crew as List<T>);
      },
      builder: (_, credits, __) {
        if (credits.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        } else {
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).width ~/ 340,
              mainAxisExtent: Constants.posterWidth / Constants.arPoster +
                  Constants.posterVPadding * 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var person = credits[index];
                return PersonPosterTile(
                  person: person,
                  subtitle: /*person.gender != null && person.gender! > 0
                      ? */
                      Row(
                    children: [
                      Text(
                        getGenderText(person.gender),
                        // textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 15.0,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ) /*: null*/,
                  description: Text(
                    person is Cast
                        ? person.character
                        : person is Crew
                            ? person.jobs ?? ''
                            : '',
                    style: const TextStyle(
                      fontSize: 15.0,
                      height: 1.2,
                      color: Colors.black87,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
              childCount: credits.length,
            ),
          );
        }
      },
    );
  }
}

class _FilterBar extends StatelessWidget implements PreferredSizeWidget {
  final double rowHeight = 62.0;

  final Map<String, FilterState> filters;

  const _FilterBar(this.filters, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: rowHeight,
      child: buildDepartmentsList(context, filters),
    );
  }

  Widget buildDepartmentsList(
      BuildContext context, Map<String, FilterState> depts) {
    return buildListView(
      itemBuilder: (_, index) {
        var item = depts.entries.elementAt(index);
        var label = item.key;
        var selected = item.value == FilterState.selected;
        return buildFilterChip(
          label,
          selected,
          (isSelected) {
            var currentlySelected = item.value == FilterState.selected;
            if (isSelected != currentlySelected) {
              context
                  .read<CreditsViewModel>()
                  .toggleDepartments(item, isSelected);
            }
          },
        );
      },
      itemCount: depts.length,
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
    );
  }

  ListView buildListView({
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
    bool selected,
    Function(bool) onSelected,
  ) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : kPrimary,
        ),
      ),
      side: selected ? null : BorderSide(color: kPrimary, width: 0.7),
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
      selectedColor: kPrimary.withValues(alpha: 0.8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      showCheckmark: false,
      onSelected: onSelected,
    );
  }

  @override
  Size get preferredSize => Size(0, rowHeight);
}
