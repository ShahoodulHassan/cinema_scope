import 'package:cinema_scope/architecture/home_view_model.dart';
import 'package:cinema_scope/models/search.dart';
import 'package:cinema_scope/pages/movie_page.dart';
import 'package:cinema_scope/pages/search_page.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/home_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../architecture/config_view_model.dart';
import '../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with GenericFunctions, Utilities {

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
