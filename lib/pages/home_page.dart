import 'package:cinema_scope/providers/home_provider.dart';
import 'package:cinema_scope/main.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/home_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/frosted_app_bar.dart';

enum SectionTitle {
  nowPlaying('NOW PLAYING'),
  trending('TRENDING'),
  latest('LATEST'),
  popular('POPULAR'),
  topRated('TOP RATED'),
  upcoming('COMING SOON'),
  streaming('STREAMING'),
  freeToWatch('FREE TO WATCH'),
  currentYearTopRated('BEST OF THIS YEAR'),
  lastYearTopRated('BEST OF LAST YEAR');

  final String name;

  const SectionTitle(this.name);
}

class HomePage extends MultiProvider {
  HomePage({super.key})
      : super(
          providers: [
            ChangeNotifierProvider(create: (_) => HomeProvider()),
          ],
          builder: (_, __) => const _HomePageChild(),
        );
}

class _HomePageChild extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  const _HomePageChild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');
    var homeSections = getHomeSections();
    return Scaffold(
      backgroundColor: kPrimary.lighten2(75),
      body: CustomScrollView(
        slivers: [
          SliverFrostedAppBar(
            pinned: true,
            title: const Text('Cinema scope'),
            actions: [
              IconButton(
                tooltip: 'Search',
                onPressed: () => openSearchPage(context),
                icon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
          ...homeSections.map(
            (section) => SliverToBoxAdapter(
              child: section,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 48.0)),
        ],
      ),
    );
  }

  List<Widget> getHomeSections() {
    return [
      HomeSection(
        SectionTitle.trending,
        params: [TimeWindow.day.name, TimeWindow.week.name],
        paramTitles: const [
          'Today',
          'This week',
        ],
        /*timeWindow: TimeWindow.week,*/ /*isBigWidget: true*/
      ),
      HomeSection(
        SectionTitle.nowPlaying,
        params: [MediaType.movie.name, MediaType.tv.name],
        paramTitles: const [
          'In theaters',
          'On TV',
        ],
        /*mediaType: MediaType.tv,*/ /*, isBigWidget: true*/
      ),
      HomeSection(
        SectionTitle.streaming,
        params: [MediaType.movie.name, MediaType.tv.name],
        paramTitles: const [
          'Movie',
          'TV show',
        ],
      ),
      HomeSection(
        SectionTitle.latest,
        params: [MediaType.movie.name, MediaType.tv.name],
        paramTitles: const [
          'Movie',
          'TV show',
        ],
      ),
      HomeSection(
        SectionTitle.upcoming,
        params: [MediaType.movie.name, MediaType.tv.name],
        paramTitles: const [
          'Movie',
          'TV show',
        ],
      ),
      HomeSection(
        SectionTitle.currentYearTopRated,
        params: [MediaType.movie.name, MediaType.tv.name],
        paramTitles: const [
          'Movie',
          'TV show',
        ],
      ),
      HomeSection(
        SectionTitle.lastYearTopRated,
        params: [MediaType.movie.name, MediaType.tv.name],
        paramTitles: const [
          'Movie',
          'TV show',
        ],
      ),
      HomeSection(
        SectionTitle.freeToWatch,
        params: [MediaType.movie.name, MediaType.tv.name],
        paramTitles: const [
          'Movie',
          'TV show',
        ],
      ),
      HomeSection(
        SectionTitle.topRated,
        params: [MediaType.movie.name, MediaType.tv.name],
        paramTitles: const [
          'Movie',
          'TV show',
        ],
      ),

    ];
  }

  Widget getAnimatedSizeWidget(Widget child) {
    // return AnimatedSize(
    //   duration: const Duration(milliseconds: 250),
    //   child: child,
    // );
    return child;
  }
}
