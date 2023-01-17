import 'package:cinema_scope/architecture/home_view_model.dart';
import 'package:cinema_scope/pages/search_page.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/home_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class HomePage extends MultiProvider {

 HomePage({super.key}) : super(
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

class _HomePageChildState extends State<_HomePageChild> with GenericFunctions, Utilities {

  @override
  void initState() {
    logIfDebug('initState called');
    context.read<HomeViewModel>().getAllResults(MediaType.movie);
    logIfDebug('async tasks started');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');
    return Scaffold(
      appBar: AppBar(
        title: getAppbarTitle('Cinema scope'),
        actions: [
          IconButton(
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
          children: const [
            HomeSection(SectionTitle.nowPlaying, isBigWidget: true),
            HomeSection(SectionTitle.dailyTrending),
            HomeSection(SectionTitle.latest),
            HomeSection(SectionTitle.popular),
            HomeSection(SectionTitle.topRated),
            HomeSection(SectionTitle.upcoming),
          ],
        ),
      ),
    );
  }

}
