import 'package:cinema_scope/models/configuration.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../architecture/config_view_model.dart';
import '../models/movie.dart';
import '../widgets/frosted_app_bar.dart';

/// This page is meant to show the sub details of movie details
/// T can be any model object which means that all possible objects would have
/// to be dealt with in the code that links the models with the UI.
class MediaSubDetailsPage<T> extends StatelessWidget with GenericFunctions {
  final String title; // Page title
  final String name; // Movie name
  final List<T> list;

  const MediaSubDetailsPage({
    required this.title,
    required this.name,
    required this.list,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: FrostedAppBar.withSubtitle(
        title: Text(title),
        subtitle: Text(name),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () => openSearchPage(context),
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (_, index) {
          T item = list[index];
          if (item is ReleaseDatesResult) {
            return _ReleaseDateTile(item);
          } else if (item is LanguageConfig) {
            return _TextTile(item.englishName);
          } else if (item is ProductionCountry) {
            return _TextTile(item.name);
          } else if (item is ProductionCompany) {
            return _TextTile(item.name);
          }
          return null;
        },
        separatorBuilder: (_, __) => Divider(
          height: 1.0,
          thickness: 0.3,
          indent: 16.0,
          endIndent: 16.0,
          color: Theme.of(context).primaryColor,
        ),
        itemCount: list.length,
      ),
    );
  }
}

class _TextTile extends StatelessWidget {
  final String englishName;

  const _TextTile(this.englishName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        englishName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ReleaseDateTile extends StatelessWidget with GenericFunctions {
  final ReleaseDatesResult result;

  const _ReleaseDateTile(this.result, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cvm = context.read<ConfigViewModel>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cvm.cfgCountries
                .singleWhere((element) => element.iso31661 == result.iso31661)
                .englishName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ...getSubDetailViews(result.releaseDates),
        ],
      ),
    );
  }

  List<Widget> getSubDetailViews(List<ReleaseDate> dates) {
    List<Widget> views = [];
    for (var date in dates) {
      var type = ReleaseType.values
          .singleWhere((element) => element.id == date.type)
          .name;
      var checkNotes = date.type == ReleaseType.physical.id ||
          date.type == ReleaseType.digital.id ||
          date.type == ReleaseType.tv.id;
      views.add(Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(checkNotes && date.note != null && date.note!.isNotEmpty
                ? date.note!
                : type),
            Text(getReadableDate(date.releaseDate)),
          ],
        ),
      ));
    }
    return views;
  }
}
