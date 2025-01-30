import 'package:age_calculator/age_calculator.dart';
import 'package:cinema_scope/providers/configuration_provider.dart';
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
import 'package:tuple/tuple.dart';

import '../providers/person_provider.dart';
import '../models/search.dart';
import '../utilities/generic_functions.dart';
import '../widgets/base_section_sliver.dart';
import '../widgets/compact_text_button.dart';
import '../widgets/frosted_app_bar.dart';
import '../widgets/home_section.dart';
import 'image_gallery_page.dart';

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
              ChangeNotifierProvider(create: (_) => PersonProvider()),
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
    with Utilities, GenericFunctions, CommonFunctions {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context
          .read<PersonProvider>()
          .fetchPersonWithDetail(widget.id, widget.name, widget.knownFor),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: CustomScrollView(
        slivers: [
          SliverFrostedAppBar(
            pinned: true,
            title: Text(widget.name),
            actions: [
              IconButton(
                tooltip: 'Search',
                onPressed: () => openSearchPage(context),
                icon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
          MediaQuery.sizeOf(context).aspectRatio <= 1
              ? buildIntroPortrait()
              : buildIntroLandscape(),
          const _BiographySection(),
          _FilmographySection(),
          const _PersonalInfoSection(),
          const ImagesSection<PersonProvider>(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  SliverToBoxAdapter buildIntroPortrait() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          right: 8.0,
          left: 8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildPhoto(context, widget.id, widget.profilePath),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: Column(
                children: [
                  buildName(widget.name),
                  buildJobs(TextAlign.center),
                ],
              ),
            ),
            const Align(
              alignment: AlignmentDirectional.topCenter,
              child: _ExternalIdsView(),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildIntroLandscape() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          right: 16.0,
          left: 16.0,
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildPhoto(context, widget.id, widget.profilePath),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildName(widget.name),
                        buildJobs(TextAlign.start),
                      ],
                    ),
                  ),
                  const _ExternalIdsView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildPhoto(BuildContext context, int id, String? imagePath) {
  return Stack(
    children: [
      SizedBox(
        width: 157.0,
        child: NetworkImageView(
          imagePath,
          imageType: ImageType.profile,
          imageQuality: ImageQuality.original,
          aspectRatio: Constants.arProfile,
          topRadius: 4.0,
          bottomRadius: 4.0,
          heroImageTag: '$id',
        ),
      ),
      Positioned.fill(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: imagePath != null
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ImagePage(
                          images: [
                            ImageDetail(
                              Constants.arProfile,
                              0,
                              imagePath,
                              0,
                              0,
                              0,
                            ),
                          ],
                          initialPage: 0,
                        ),
                      ),
                    );
                  }
                : null,
          ),
        ),
      ),
    ],
  );
}

Widget buildName(String name) {
  return Text(
    name,
    style: const TextStyle(
      fontSize: 24.0,
      letterSpacing: 2.0,
      fontWeight: FontWeightExt.semibold,
      color: Colors.black87,
      // height: 1.1,
    ),
  );
}

Widget buildJobs(TextAlign textAlign) {
  return AnimatedSize(
    duration: const Duration(milliseconds: 250),
    child: Selector<PersonProvider, String?>(
      builder: (_, jobs, __) {
        if (jobs == null || jobs.isEmpty) {
          return const SizedBox.shrink();
        }
        return Text(
          jobs,
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 16.0,
            height: 1.2,
          ),
        );
      },
      selector: (_, pvm) => pvm.jobs,
    ),
  );
}

class _ExternalIdsView extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  const _ExternalIdsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PersonProvider, Tuple2<String?, ExternalIds?>>(
      builder: (_, tuple, __) {
        String? homepage = tuple.item1;
        ExternalIds? externalIds = tuple.item2;
        if (homepage == null && externalIds == null) {
          return const SizedBox.shrink();
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (externalIds!.imdbId != null)
                  getIconButton(
                    const Icon(FontAwesomeIcons.imdb),
                    () => openUrlString(
                      '${Constants.imdbPersonUrl}${externalIds.imdbId}',
                    ),
                  ),
                if (externalIds.instagramId != null)
                  getIconButton(
                    const Icon(FontAwesomeIcons.instagram),
                    () => openUrlString(
                      '${Constants.instagramBaseUrl}${externalIds.instagramId}',
                    ),
                  ),
                if (externalIds.twitterId != null)
                  getIconButton(
                    const Icon(FontAwesomeIcons.twitter),
                    () => openUrlString(
                        '${Constants.twitterBaseUrl}${externalIds.twitterId}'),
                  ),
                if (externalIds.facebookId != null)
                  getIconButton(
                    const Icon(FontAwesomeIcons.facebook),
                    () => openUrlString(
                      '${Constants.facebookBaseUrl}${externalIds.facebookId}',
                    ),
                  ),
                if (homepage != null)
                  getIconButton(
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
    return Selector<PersonProvider, Person?>(
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
                color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
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
    return Selector<PersonProvider, String?>(
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

class ImagesSection<T extends BaseMediaProvider> extends StatelessWidget
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
            onPressed: showSeeAll
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ImageGalleryPage(
                          images: images,
                        ),
                      ),
                    );
                  }
                : null,
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
    this._items,
    this._trimmedCount, {
    this.posterHeight = 150.0,
    this.radius = 4.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');

    const cardMargin = 4.0;

    final listViewHeight = posterHeight + listViewVerticalPadding * 2;

    final images = _items
        .take(_trimmedCount)
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
    return Selector<PersonProvider, Map<int, CombinedResult>>(
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
                var pvm = context.read<PersonProvider>();
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