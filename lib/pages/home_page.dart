import 'package:cinema_scope/architecture/home_view_model.dart';
import 'package:cinema_scope/pages/movie_page.dart';
import 'package:cinema_scope/pages/search_page.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/home_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class HomePage extends MultiProvider {
  HomePage({super.key})
      : super(
          providers: [
            ChangeNotifierProvider(create: (_) => HomeViewModel()),
            // ChangeNotifierProvider(create: (_) => HeroViewModel()),
          ],
          builder: (_, __) => const _HomePageChild(),
        );
}

class _HomePageChild extends StatefulWidget {
  const _HomePageChild({Key? key}) : super(key: key);

  @override
  State<_HomePageChild> createState() => _HomePageChildState();
}

class _HomePageChildState extends State<_HomePageChild>
    with GenericFunctions, Utilities, RouteAware, CommonFunctions {
  @override
  void initState() {
    logIfDebug('initState called');
    // context.read<HomeViewModel>().getAllResults(MediaType.movie);
    logIfDebug('async tasks started');
    super.initState();
  }

  @override
  void didPush() {
    logIfDebug('didPush called');
    super.didPush();
  }

  @override
  void didPushNext() {
    logIfDebug('didPushNext called');
    super.didPushNext();
  }

  @override
  void didPopNext() {
    logIfDebug('didPopNext called');
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');
    return Scaffold(
      backgroundColor: getScaffoldColor(context),
      appBar: AppBar(
        title: const Text('Cinema scope'),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchPage()),
              );
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            getAnimatedSizeWidget(
              HomeSection(
                SectionTitle.trending,
                params: [TimeWindow.day.name, TimeWindow.week.name],
                paramTitles: const [
                  'Today',
                  'This week',
                ],

                /*timeWindow: TimeWindow.week,*/ /*isBigWidget: true*/
              ),
            ),
            getAnimatedSizeWidget(
              HomeSection(
                SectionTitle.nowPlaying,
                params: [MediaType.movie.name, MediaType.tv.name],
                paramTitles: const [
                  'In theaters',
                  'On TV',
                ],
                /*mediaType: MediaType.tv,*/ /*, isBigWidget: true*/
              ),
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
            // HomeSection(
            //   SectionTitle.popular,
            //   params: [MediaType.movie.name, MediaType.tv.name],
            //   paramTitles: const [
            //     'Movie',
            //     'TV show',
            //   ],
            // ),
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
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget getAnimatedSizeWidget(Widget child) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: child,
    );
  }
}

