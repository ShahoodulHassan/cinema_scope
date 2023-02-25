import 'package:cinema_scope/architecture/home_view_model.dart';
import 'package:cinema_scope/pages/search_page.dart';
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
    with GenericFunctions, Utilities, RouteAware {
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
      backgroundColor: lighten2(Theme.of(context).primaryColorLight, 78),
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
              SectionTitle.latest,
              params: [MediaType.movie.name, MediaType.tv.name],
              paramTitles: const [
                'Movie',
                'TV show',
              ],
            ),
            HomeSection(
              SectionTitle.popular,
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

class BaseHomeSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  final bool showSeeAll;
  final Function()? onPressed;
  final String buttonText;

  const BaseHomeSection({
    required this.title,
    required this.children,
    this.showSeeAll = false,
    this.buttonText = 'See all',
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36.0),
      child: Stack(
        children: [
          /// This serves as the base card on which the content card is
          /// stacked. The fill constructor helps match its height with
          /// the height of the content card.
          Positioned.fill(
            child: Container(
              color: Colors.white,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getSeparator(context),
              getSectionTitleRow(),
              ...children,
              getSeparator(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget getSeparator(BuildContext context) => Container(
        height: 1.0,
        color: Theme.of(context).primaryColorLight,
      );

  Widget getSectionTitleRow() => Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                // height: 1.1,
              ),
            ),
            // if (showSeeAll) CompactTextButton(buttonText, onPressed: onPressed),
          ],
        ),
      );
}
