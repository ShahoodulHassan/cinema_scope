import 'package:cinema_scope/architecture/home_view_model.dart';
import 'package:cinema_scope/pages/search_page.dart';
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
  freeToWatch('FREE TO WATCH');

  final String name;

  const SectionTitle(this.name);
}

class HomePage extends MultiProvider {
  HomePage({super.key})
      : super(
          providers: [
            ChangeNotifierProvider(create: (_) => HomeViewModel()),
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
      backgroundColor: scaffoldColor,
      body: CustomScrollView(
        slivers: [
          SliverFrostedAppBar(
            pinned: true,
            title: const Text('Cinema scope'),
            actions: [
              IconButton(
                tooltip: 'Search',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SearchPage()),
                    // MaterialPageRoute(builder: (_) => MoviesListPage(mediaType: MediaType.movie, genres: [Genre(10749, 'Romance')],)),
                  );
                },
                icon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
          ...homeSections.map(
            (section) => SliverToBoxAdapter(
              child: section,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24.0),
          )
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
        SectionTitle.freeToWatch,
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
        SectionTitle.topRated,
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
