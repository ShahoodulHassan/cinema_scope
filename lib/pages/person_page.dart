import 'dart:math';

import 'package:age_calculator/age_calculator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_scope/architecture/config_view_model.dart';
import 'package:cinema_scope/constants.dart';
import 'package:cinema_scope/models/movie.dart';
import 'package:cinema_scope/models/person.dart';
import 'package:cinema_scope/pages/filmography_page.dart';
import 'package:cinema_scope/pages/image_page.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/expandable_synopsis.dart';
import 'package:cinema_scope/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tuple/tuple.dart';

import '../architecture/person_view_model.dart';
import '../models/search.dart';
import '../utilities/generic_functions.dart';
import '../widgets/base_section_sliver.dart';
import '../widgets/compact_text_button.dart';
import '../widgets/home_section_test.dart';

class PersonPage extends MultiProvider {
  PersonPage({
    super.key,
    required int id,
    required String name,
    required String? profilePath,
    required int? gender,
    required String knownForDepartment,
    List<CombinedResult>? knownFor,
  }) : super(
            providers: [
              ChangeNotifierProvider(create: (_) => PersonViewModel()),
              // ChangeNotifierProvider(create: (_) => YoutubeViewModel()),
            ],
            child: _PersonPageChild(
              id: id,
              name: name,
              profilePath: profilePath,
              gender: gender,
              knownForDepartment: knownForDepartment,
              knownFor: knownFor,
            ));
}

class _PersonPageChild extends StatefulWidget {
  final int id;
  final String name;
  final String? profilePath;
  final int? gender;
  final String knownForDepartment;
  final List<CombinedResult>? knownFor;

  const _PersonPageChild({
    Key? key,
    required this.id,
    required this.name,
    required this.profilePath,
    required this.gender,
    required this.knownForDepartment,
    this.knownFor,
  }) : super(key: key);

  @override
  State<_PersonPageChild> createState() => _PersonPageChildState();
}

class _PersonPageChildState extends State<_PersonPageChild>
    with Utilities, CommonFunctions {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context
          .read<PersonViewModel>()
          .fetchPersonWithDetail(widget.id, widget.name, widget.knownFor),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getScaffoldColor(context),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // floating: true,
            pinned: true,
            // snap: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name),
              ],
            ),
          ),
          MultiSliver(
            children: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            // height: (MediaQuery.of(context).size.width * 0.40) /
                            //     Constants.arProfile * 0.8,
                            child: NetworkImageView(
                              widget.profilePath,
                              imageType: ImageType.profile,
                              aspectRatio: Constants.arProfile * 1.15,
                              topRadius: 4.0,
                              bottomRadius: 4.0,
                              fit: BoxFit.fitWidth,
                              heroImageTag: '${widget.id}',
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          right: 8.0,
                          left: 8.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                fontSize: 24.0,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold,
                                // height: 1.1,
                              ),
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 250),
                              child: Selector<PersonViewModel, String?>(
                                builder: (_, jobs, __) {
                                  if (jobs == null || jobs.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    jobs,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  );
                                },
                                selector: (_, pvm) => pvm.jobs,
                              ),
                            ),
                            const _ExternalIdsView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const _BiographySection(),
              _FilmographySection(),
              const _PersonalInfoSection(),
              const ImagesSection<PersonViewModel>(),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExternalIdsView extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  const _ExternalIdsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PersonViewModel, Tuple2<String?, ExternalIds?>>(
      builder: (_, tuple, __) {
        String? homepage = tuple.item1;
        ExternalIds? externalIds = tuple.item2;
        if (homepage == null && externalIds == null) {
          return const SizedBox.shrink();
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (externalIds!.imdbId != null)
                  getIconButton(
                    context,
                    const Icon(FontAwesomeIcons.imdb),
                    () => openUrlString(
                      '${Constants.imdbPersonUrl}${externalIds.imdbId}',
                    ),
                  ),
                if (externalIds.instagramId != null)
                  getIconButton(
                    context,
                    const Icon(FontAwesomeIcons.instagram),
                    () => openUrlString(
                      '${Constants.instagramBaseUrl}${externalIds.instagramId}',
                    ),
                  ),
                if (externalIds.twitterId != null)
                  getIconButton(
                    context,
                    const Icon(FontAwesomeIcons.twitter),
                    () => openUrlString(
                        '${Constants.twitterBaseUrl}${externalIds.twitterId}'),
                  ),
                if (externalIds.facebookId != null)
                  getIconButton(
                    context,
                    const Icon(FontAwesomeIcons.facebook),
                    () => openUrlString(
                      '${Constants.facebookBaseUrl}${externalIds.facebookId}',
                    ),
                  ),
                if (homepage != null)
                  getIconButton(
                    context,
                    const Icon(Icons.link),
                    () => openUrlString(homepage),
                  ),
              ],
            ),
          );
        }
      },
      selector: (_, pvm) => Tuple2(
        pvm.personWithKnownFor.person?.homepage,
        pvm.personWithKnownFor.person?.externalIds,
      ),
    );
  }

// Widget getIconButton(IconData icon, Function() onPressed) =>
//     IconButton(onPressed: onPressed, icon: Icon(icon));
}

class _PersonalInfoSection extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  const _PersonalInfoSection({Key? key}) : super(key: key);

  final _separator = const SizedBox(height: 16.0);

  @override
  Widget build(BuildContext context) {
    return Selector<PersonViewModel, Person?>(
      builder: (_, person, __) {
        if (person == null) {
          return SliverToBoxAdapter(child: Container());
        } else {
          var place = person.placeOfBirth;
          var deathDay = person.deathday;
          var dead = isDead(deathDay);
          var birthdayText = dead
              ? ''
              : getBirthDayText(
                  person.birthday,
                  person.gender,
                );
          return BaseSectionSliver(
            title: 'Personal info',
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getLabelView('Gender'),
                        getTextView(getGenderText(person.gender)),
                      ],
                    ),
                    _separator,
                    getBirthSection(person, dead, place, birthdayText),
                    if (dead) getDeathSection(deathDay, person),
                    _separator,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getLabelView('Known for'),
                        getTextView(person.knownForDepartment),
                      ],
                    ),
                    _separator,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getLabelView('Known credits'),
                        getTextView(
                          applyCommaAndRoundNoZeroes(
                              person.knownCredits.toDouble(), 0, true),
                        ),
                      ],
                    ),
                    if (person.alsoKnownAs.isNotEmpty)
                      getAlsoKnownAsView(person),
                  ],
                ),
              )
            ],
          );
        }
      },
      selector: (_, pvm) => pvm.personWithKnownFor.person,
    );
  }

  Widget getDeathSection(String? deathDay, Person person) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getLabelView('Death'),
                getTextView(getDeathText(
                  deathDay!,
                  person.birthday,
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getBirthSection(
      Person person, bool dead, String? place, String birthdayText) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getLabelView('Birth'),
              getTextView(getBirthText(person.birthday, dead)),
              if (place != null && place.isNotEmpty) getTextView(place),
              if (birthdayText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: getTextView(birthdayText),
                ),
            ],
          ),
        )
      ],
    );
  }

  Widget getAlsoKnownAsView(Person person) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          getLabelView('Also known as'),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => getTextView(person.alsoKnownAs[index]),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Container(
                height: 0.20,
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              ),
            ),
            itemCount: person.alsoKnownAs.length,
          ),
        ],
      );

  String getBirthText(String? birthDay, bool dead) {
    if (birthDay == null || birthDay.isEmpty) return '-';
    String ageText = getAgeText(birthDay);
    return '${getReadableDate(birthDay)}${dead ? '' : '  ($ageText)'}';
  }

  String getDeathText(String deathDay, String? birthday) {
    String ageAtDeath = '';
    if (birthday != null && birthday.isNotEmpty) {
      DateDuration duration = AgeCalculator.age(
        DateTime.parse(birthday),
        today: DateTime.parse(deathDay),
      );
      int years = duration.years;
      int months = duration.months;
      var durations = <String>[];
      if (years > 0) durations.add('$years year${years == 1 ? '' : 's'}');
      if (months > 0) durations.add('$months month${months == 1 ? '' : 's'}');
      ageAtDeath = '  (at ${durations.join(', ')})';
    }
    return '${getReadableDate(deathDay)}$ageAtDeath';
  }

  String getAgeText(String birthDay) {
    DateDuration duration = AgeCalculator.age(DateTime.parse(birthDay));
    int years = duration.years;
    int months = duration.months;
    var durations = <String>[];
    if (years > 0) durations.add('$years year${years == 1 ? '' : 's'}');
    if (months > 0) durations.add('$months month${months == 1 ? '' : 's'}');
    return durations.join(', ');
  }

  String getBirthDayText(String? birthDay, int? gender) {
    if (birthDay == null || birthDay.isEmpty) return '';
    DateDuration duration =
        AgeCalculator.timeToNextBirthday(DateTime.parse(birthDay));
    if (duration.months > 0) return '';
    String genderText = 'their';
    if (gender == 1) {
      genderText = 'her';
    } else if (gender == 2) {
      genderText = 'his';
    }
    int days = duration.days;
    if (days == 0) {
      return 'Today is $genderText birthday';
    } else if (days == 1) {
      return 'Tomorrow is $genderText birthday';
    } else {
      return 'Birthday in $days days';
    }
  }

  bool isDead(String? deathday) => deathday != null && deathday.isNotEmpty;

  Widget getLabelView(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14.0,
        // height: 1.1,
        color: Colors.black54,
      ),
    );
  }

  Widget getTextView(String? text) {
    return Text(
      (text == null || text.isEmpty) ? '-' : text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16.0,
        // fontWeight: FontWeight.bold,
        // height: 1.1,
      ),
    );
  }
}

class _BiographySection extends StatelessWidget {
  const _BiographySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PersonViewModel, String?>(
      builder: (_, bio, __) {
        if (bio == null || bio.isEmpty) {
          return SliverToBoxAdapter(child: Container());
        }
        return BaseSectionSliver(
          title: 'Biography',
          children: [
            ExpandableSynopsis(
              bio,
              expanded: false,
              maxLines: 12,
              changeSize: false,
              vertical: 16.0,
              // horizontal: 8.0,
            ),
          ],
        );
      },
      selector: (_, pvm) => pvm.personWithKnownFor.person?.biography,
    );
  }
}

class ImagesSection<T extends BaseMediaViewModel> extends StatelessWidget
    with GenericFunctions {
  const ImagesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<T, List<ImageDetail>>(
      selector: (_, pvm) => pvm.images ?? [],
      builder: (_, images, __) {
        if (images.isEmpty) {
          return SliverToBoxAdapter(child: Container());
        } else {
          final totalCount = images.length;
          const trimmedCount = 15;
          final showSeeAll = totalCount > trimmedCount;
          return BaseSectionSliver(
            title: 'Images ($totalCount)',
            showSeeAll: showSeeAll,
            onPressed: showSeeAll ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ImagePage(
                    images: images,
                    initialPage: 0,
                  ),
                ),
              );
            } : null,
            children: [
              MyImageCardListView(images, trimmedCount),
            ],
          );
        }
      },
    );
  }
}

class MyImageCardListView extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final List<ImageDetail> _items;
  final int _trimmedCount;
  final double posterHeight;
  final double radius;

  final listViewVerticalPadding = 16.0;

  final listViewHorizontalPadding = 16.0 - Constants.cardMargin;

  MyImageCardListView(
    this._items, this._trimmedCount, {
    this.posterHeight = 150.0,
    this.radius = 4.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');

    const cardMargin = 4.0;

    final listViewHeight = posterHeight + listViewVerticalPadding * 2;

    final images = _items.take(_trimmedCount)
        .where((element) => element.imageType != ImageType.logo.name)
        .toList();

    return SizedBox(
      height: listViewHeight,
      child: ListView.builder(
        itemBuilder: (_, index) {
          // logIfDebug('MyListView itemBuilder called');
          final image = images[index];
          return buildItemView(
            context,
            image,
            index,
            cardMargin: cardMargin,
          );
        },
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: listViewHorizontalPadding,
          vertical: listViewVerticalPadding,
        ),
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget buildItemView(
    BuildContext context,
    ImageDetail image,
    int index, {
    required double cardMargin,
  }) {
    var imageType = image.imageType != null
        ? ImageType.values
            .firstWhere((element) => element.name == image.imageType)
        : ImageType.profile;
    var imageQuality =
        image.imageType == ImageType.still.name && image.aspectRatio > 1.0
            ? ImageQuality.high
            : ImageQuality.medium;
    return Stack(
      children: [
        Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 3.0,
          margin: EdgeInsets.symmetric(horizontal: cardMargin),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: SizedBox(
            height: posterHeight,
            child: NetworkImageView(
              image.filePath,
              imageType: imageType,
              imageQuality: imageQuality,
              aspectRatio: image.aspectRatio,
              topRadius: radius,
              bottomRadius: radius,
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: cardMargin),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(radius),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ImagePage(
                        images: _items,
                        initialPage: index,
                        placeholderQuality: imageQuality,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilmographySection extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final int _maxCount = 10;

  _FilmographySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PersonViewModel, Map<int, CombinedResult>>(
      selector: (_, pvm) => pvm.knownForMediaResults,
      builder: (_, knownFor, __) {
        // logIfDebug('knownFor:$knownFor');
        if (knownFor.isEmpty) {
          return SliverToBoxAdapter(child: Container());
        }
        return BaseSectionSliver(
          title: 'Known for',
          children: [
            MediaPosterListView(
              items: knownFor.values.take(_maxCount).toList(),
              posterWidth: 140.0,
              radius: 4.0,
              listViewBottomPadding: 16.0,
              subtitle: (item) => getJob(item),
            ),
            // PosterCardListView(
            //   items: knownFor.values.take(_maxCount).toList(),
            //   screenWidth: MediaQuery.of(context).size.width,
            //   aspectRatio: Constants.arPoster,
            //   subtitle: (item) => getJob(item),
            //   onTap: (item) {
            //     if (item.mediaType == MediaType.movie.name) {
            //       goToMoviePage(
            //         context,
            //         id: item.id,
            //         title: item.mediaTitle,
            //         overview: item.overview,
            //         releaseDate: item.mediaReleaseDate /*getReleaseDate(item)*/,
            //         voteAverage: item.voteAverage,
            //       );
            //     } else if (item.mediaType == MediaType.tv.name) {
            //       goToTvPage(
            //         context,
            //         id: item.id,
            //         title: item.mediaTitle,
            //         overview: item.overview,
            //         releaseDate: item.mediaReleaseDate /*getReleaseDate(item)*/,
            //         voteAverage: item.voteAverage,
            //       );
            //     }
            //   },
            // ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CompactTextButton('All filmography', onPressed: () {
                var pvm = context.read<PersonViewModel>();
                var person = pvm.personWithKnownFor.person;
                goToFilmographyPage(
                    context, person!.id, person.name, person.combinedCredits);
              }),
            ),
          ],
        );
      },
    );
  }

  String getJob(CombinedResult item) {
    // logIfDebug('getJob=>id:${item.id}, title:${getMediaTitle(item)}, type:${item.mediaType}');
    if (item is CombinedOfCast) return item.character;
    if (item is CombinedOfCrew) return item.job;
    return '';
  }

  goToFilmographyPage(
    BuildContext context,
    int id,
    String name,
    CombinedCredits combinedCredits,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => FilmographyPage(
                id: id,
                name: name,
                combinedCredits: combinedCredits,
              )),
    );
  }
}

class PosterCardListView extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final List<CombinedResult> items;
  final double screenWidth;
  final double aspectRatio;

  final String Function(CombinedResult item)? subtitle;
  final Function(CombinedResult item) onTap;

  PosterCardListView({
    required this.items,
    required this.screenWidth,
    required this.aspectRatio,
    required this.onTap,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  final separatorWidth = 10.0;

  final listViewHorizontalPadding = 16.0;

  final listViewVerticalPadding = 16.0;

  final cardCount = 2.5;

  late final deductibleWidth =
      listViewHorizontalPadding + separatorWidth * cardCount.toInt();

  late final posterWidth = 145.0;

  late final posterHeight = posterWidth / aspectRatio;

  final maxLines = 2;

  final textHorizPadding = 8.0;

  final nameTopPadding = 8.0;

  final nameBottomPadding = 2.0;

  final yearTopPadding = 0.0;

  final yearBottomPadding = 8.0;

  final subtitleTopPadding = 0.0;

  final subtitleBottomPadding = 8.0;

  final iconSize = 18.0;

  final nameStyle = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  final yearStyle = const TextStyle(
    fontSize: 14.0,
    height: 1.2,
  );

  final topRadius = 4.0;

  final bottomRadius = 0.0;

  late final nameHeight = nameStyle.height! * nameStyle.fontSize! * maxLines;

  late final subtitleHeight =
      yearStyle.height! * yearStyle.fontSize! * maxLines;

  late final yearHeight = yearStyle.height! * yearStyle.fontSize!;

  late final nameContainerHeight =
      nameHeight + nameTopPadding + nameBottomPadding;

  late final subtitleContainerHeight =
      subtitleHeight + subtitleTopPadding + subtitleBottomPadding;

  late final yearContainerHeight =
      max(iconSize, yearHeight) + yearTopPadding + yearBottomPadding;

  late final cardHeight = posterHeight +
      nameContainerHeight +
      (subtitle != null ? subtitleContainerHeight : 0.0) +
      yearContainerHeight;

  /// This 0.8 is being added to escape the "A RenderFlex overflowed by 0.800
  /// pixels on the bottom." error. The error is being caused by not
  /// assigning any height to the name and character test widgets.
  /// However, assigning height, especially to name text widget makes it
  /// expand to two lines no matter if name is actually on one line only,
  /// thereby showing an extra blank line between home snd tasks.
  late final viewHeight = cardHeight + listViewVerticalPadding * 2 + 0.8;

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called with list:$items');
    return SizedBox(
      height: viewHeight,
      child: ListView.builder(
        itemExtent: posterWidth,
        itemBuilder: (_, index) {
          var item = items[index];
          logIfDebug('item:${item.id}, mediaType:${item.mediaType}');
          var title = item.mediaTitle /*getMediaTitle(item)*/;
          var year =
              getYearStringFromDate(item.mediaReleaseDate) /*getYear(item)*/;
          var job = /*getJob(item)*/ subtitle?.call(item) ?? '';
          return Stack(
            children: [
              Card(
                surfaceTintColor: Colors.white,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(topRadius),
                ),
                margin: EdgeInsets.zero,
                child: SizedBox(
                  width: posterWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NetworkImageView(
                        item.posterPath,
                        imageType: ImageType.poster,
                        aspectRatio: aspectRatio,
                        topRadius: topRadius,
                        bottomRadius: bottomRadius,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          textHorizPadding,
                          nameTopPadding,
                          textHorizPadding,
                          nameBottomPadding,
                        ),
                        // height: nameContainerHeight,
                        child: Text(
                          title,
                          maxLines: maxLines,
                          overflow: TextOverflow.ellipsis,
                          style: nameStyle,
                        ),
                      ),
                      if (year.isNotEmpty || item.voteAverage > 0.0)
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            textHorizPadding,
                            yearTopPadding,
                            textHorizPadding,
                            yearBottomPadding,
                          ),
                          child: Row(
                            children: [
                              Visibility(
                                visible: year.isNotEmpty,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    year,
                                    textAlign: TextAlign.start,
                                    style: yearStyle,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: item.voteAverage > 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star_sharp,
                                        size: iconSize,
                                        color: Constants.ratingIconColor,
                                      ),
                                      Text(
                                        ' ${applyCommaAndRound(
                                          item.voteAverage,
                                          1,
                                          false,
                                          true,
                                        )}',
                                        style: yearStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: item.mediaType == MediaType.tv.name,
                                child: Text(
                                  'TV',
                                  style: yearStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Visibility(
                        visible: job.isNotEmpty,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                            textHorizPadding,
                            subtitleTopPadding,
                            textHorizPadding,
                            subtitleBottomPadding,
                          ),
                          // height: characterContainerHeight,
                          child: Text(
                            job,
                            maxLines: maxLines,
                            overflow: TextOverflow.ellipsis,
                            style: yearStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(topRadius),
                    onTap: () => onTap(item),
                  ),
                ),
              ),
            ],
          );
        },
        // separatorBuilder: (_, index) => SizedBox(width: separatorWidth),
        padding: EdgeInsets.symmetric(
          horizontal: listViewHorizontalPadding,
          vertical: listViewVerticalPadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
      ),
    );
  }

  String getJob(CombinedResult item) {
    // logIfDebug('getJob=>id:${item.id}, title:${getMediaTitle(item)}, type:${item.mediaType}');
    if (item is CombinedOfCast) return item.character;
    if (item is CombinedOfCrew) return item.job;
    return '';
  }
}

class PosterCardListViewOld extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final List<CombinedResult> items;
  final double screenWidth;
  final double aspectRatio;

  final String Function(CombinedResult item)? subtitle;
  final Function(CombinedResult item) onTap;

  PosterCardListViewOld({
    required this.items,
    required this.screenWidth,
    required this.aspectRatio,
    required this.onTap,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  final separatorWidth = 10.0;

  final listViewHorizontalPadding = 16.0;

  final listViewVerticalPadding = 16.0;

  final cardCount = 2.5;

  late final deductibleWidth =
      listViewHorizontalPadding + separatorWidth * cardCount.toInt();

  late final posterWidth = (screenWidth - deductibleWidth) / cardCount;

  late final posterHeight = posterWidth / aspectRatio;

  final maxLines = 2;

  final textHorizPadding = 8.0;

  final nameTopPadding = 8.0;

  final nameBottomPadding = 2.0;

  final yearTopPadding = 0.0;

  final yearBottomPadding = 8.0;

  final subtitleTopPadding = 0.0;

  final subtitleBottomPadding = 8.0;

  final iconSize = 18.0;

  final nameStyle = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  final yearStyle = const TextStyle(
    fontSize: 14.0,
    height: 1.2,
  );

  final topRadius = 4.0;

  final bottomRadius = 0.0;

  late final nameHeight = nameStyle.height! * nameStyle.fontSize! * maxLines;

  late final subtitleHeight =
      yearStyle.height! * yearStyle.fontSize! * maxLines;

  late final yearHeight = yearStyle.height! * yearStyle.fontSize!;

  late final nameContainerHeight =
      nameHeight + nameTopPadding + nameBottomPadding;

  late final subtitleContainerHeight =
      subtitleHeight + subtitleTopPadding + subtitleBottomPadding;

  late final yearContainerHeight =
      max(iconSize, yearHeight) + yearTopPadding + yearBottomPadding;

  late final cardHeight = posterHeight +
      nameContainerHeight +
      (subtitle != null ? subtitleContainerHeight : 0.0) +
      yearContainerHeight;

  /// This 0.8 is being to escape the "A RenderFlex overflowed by 0.800
  /// pixels on the bottom." error. The error is being caused by not
  /// assigning any height to the name and character test widgets.
  /// However, assigning height, especially to name text widget makes it
  /// expand to two lines no matter if name is actually on one line only,
  /// thereby showing an extra blank line between home snd tasks.
  late final viewHeight = cardHeight + listViewVerticalPadding * 2 + 0.8;

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called with list:$items');
    return SizedBox(
      width: screenWidth,
      height: viewHeight,
      child: ListView.separated(
        // primary: false,
        itemBuilder: (_, index) {
          var item = items[index];
          logIfDebug('item:${item.id}, mediaType:${item.mediaType}');
          var title = item.mediaTitle /*getMediaTitle(item)*/;
          var year =
              getYearStringFromDate(item.mediaReleaseDate) /*getYear(item)*/;
          var job = /*getJob(item)*/ subtitle?.call(item) ?? '';
          return Stack(
            children: [
              Card(
                surfaceTintColor: Colors.white,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(topRadius),
                ),
                margin: EdgeInsets.zero,
                child: SizedBox(
                  width: posterWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NetworkImageView(
                        item.posterPath,
                        imageType: ImageType.poster,
                        aspectRatio: aspectRatio,
                        topRadius: topRadius,
                        bottomRadius: bottomRadius,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          textHorizPadding,
                          nameTopPadding,
                          textHorizPadding,
                          nameBottomPadding,
                        ),
                        // height: nameContainerHeight,
                        child: Text(
                          title,
                          maxLines: maxLines,
                          overflow: TextOverflow.ellipsis,
                          style: nameStyle,
                        ),
                      ),
                      if (year.isNotEmpty || item.voteAverage > 0.0)
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            textHorizPadding,
                            yearTopPadding,
                            textHorizPadding,
                            yearBottomPadding,
                          ),
                          child: Row(
                            children: [
                              Visibility(
                                visible: year.isNotEmpty,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    year,
                                    textAlign: TextAlign.start,
                                    style: yearStyle,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: item.voteAverage > 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star_sharp,
                                        size: iconSize,
                                        color: Constants.ratingIconColor,
                                      ),
                                      Text(
                                        ' ${applyCommaAndRound(
                                          item.voteAverage,
                                          1,
                                          false,
                                          true,
                                        )}',
                                        style: yearStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: item.mediaType == MediaType.tv.name,
                                child: Text(
                                  'TV',
                                  style: yearStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Visibility(
                        visible: job.isNotEmpty,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                            textHorizPadding,
                            subtitleTopPadding,
                            textHorizPadding,
                            subtitleBottomPadding,
                          ),
                          // height: characterContainerHeight,
                          child: Text(
                            job,
                            maxLines: maxLines,
                            overflow: TextOverflow.ellipsis,
                            style: yearStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(topRadius),
                    onTap: () => onTap(item),
                  ),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (_, index) => SizedBox(width: separatorWidth),
        padding: EdgeInsets.symmetric(
          horizontal: listViewHorizontalPadding,
          vertical: listViewVerticalPadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
      ),
    );
  }

  String getJob(CombinedResult item) {
    // logIfDebug('getJob=>id:${item.id}, title:${getMediaTitle(item)}, type:${item.mediaType}');
    if (item is CombinedOfCast) return item.character;
    if (item is CombinedOfCrew) return item.job;
    return '';
  }
}
