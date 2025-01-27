import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../architecture/filmography_view_model.dart';
import '../architecture/tv_credits_view_model.dart';
import '../constants.dart';
import '../models/tv.dart';
import '../widgets/frosted_app_bar.dart';
import '../widgets/poster_tile.dart';

class TvCreditsPage extends MultiProvider {
  TvCreditsPage({
    super.key,
    required AggregateCredits credits,
    required int id,
    required String name,
    String? title,
  }) : super(
            providers: [
              ChangeNotifierProvider(
                  create: (_) => TvCreditsViewModel(credits)),
            ],
            child: _TvCreditsPageChild(
              id: id,
              name: name,
              credits: credits,
              title: title ?? 'Cast & crew',
            ));
}

class _TvCreditsPageChild extends StatefulWidget {
  final int id;
  final String name;
  final AggregateCredits credits;
  final String title;

  const _TvCreditsPageChild({
    required this.id,
    required this.name,
    required this.credits,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<_TvCreditsPageChild> createState() => _TvCreditsPageChildState();
}

class _TvCreditsPageChildState extends State<_TvCreditsPageChild>
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
        (_) => context.read<TvCreditsViewModel>().initialize());
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
              SliverFrostedAppBar.withSubtitle(
                floating: true,
                pinned: true,
                title: Text(widget.title),
                subtitle: Text(widget.name),
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
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        labelColor: Colors.black87,
                        labelStyle: TextStyle(
                          fontFamily: baseFontFamily,
                          fontWeight: weightBold,
                          letterSpacing: 1.0,
                        ),
                        tabs: tabs,
                      )
                    : null,
              ),
              // SliverFrostedAppBar(
              //   floating: true,
              //   title: Text(widget.title),
              //   subtitle: Text(widget.name),
              //   bottom: crew.isNotEmpty && cast.isNotEmpty
              //       ? TabBar(
              //     indicatorSize: TabBarIndicatorSize.tab,
              //     indicatorColor: Theme.of(context).colorScheme.primary,
              //     labelColor: Colors.black87,
              //     labelStyle: TextStyle(
              //       fontFamily: baseFontFamily,
              //       fontWeight: weightBold,
              //       letterSpacing: 1.0,
              //     ),
              //     tabs: tabs,
              //   )
              //       : null,
              // ),
            ];
          },
          body: TabBarView(children: [
            if (cast.isNotEmpty)
              CustomScrollView(
                slivers: [
                  getSliverTabData<TvCast>(context),
                ],
              ),
            if (crew.isNotEmpty)
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child:
                        Selector<TvCreditsViewModel, Map<String, FilterState>>(
                      selector: (_, cvm) => cvm.availableDepartments,
                      builder: (_, filters, __) {
                        return (filters.length <= 1)
                            ? Container()
                            : _FilterBar(filters);
                      },
                    ),
                  ),
                  getSliverTabData<TvCrew>(context),
                ],
              ),
          ]),
        ),
      ),
    );
  }

  Selector<TvCreditsViewModel, List<T>>
      getSliverTabData<T extends BaseTvCredit>(BuildContext context) {
    return Selector<TvCreditsViewModel, List<T>>(
      selector: (_, cvm) {
        logIfDebug('selector called for ${T.toString()}');
        return T.toString() == (TvCast).toString()
            ? ((cvm.cast ?? []) as List<T>)
            : ((cvm.crew ?? []) as List<T>);
      },
      builder: (_, credits, __) {
        logIfDebug('builder called for ${T.toString()}');
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
                  subtitle: Row(
                    children: [
                      Text(
                        getGenderText(person.gender),
                        // textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                  description: Text(
                    person.deptJobsString,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.2,
                      color: Colors.black87,
                    ),
                    // maxLines: 8,
                    // overflow: TextOverflow.ellipsis,
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
  final double verticalPadding = 8.0;

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
      context,
      itemBuilder: (_, index) {
        var item = depts.entries.elementAt(index);
        var label = item.key;
        var selected = item.value == FilterState.selected;
        return buildFilterChip(
          label,
          context,
          selected,
          (isSelected) {
            var currentlySelected = item.value == FilterState.selected;
            if (isSelected != currentlySelected) {
              context
                  .read<TvCreditsViewModel>()
                  .toggleDepartments(item, isSelected);
            }
          },
        );
      },
      itemCount: depts.length,
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color:
              selected ? Colors.white : Theme.of(context).colorScheme.primary,
        ),
      ),
      side: selected
          ? null
          : BorderSide(
              color: Theme.of(context).colorScheme.primary,
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
      selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
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
