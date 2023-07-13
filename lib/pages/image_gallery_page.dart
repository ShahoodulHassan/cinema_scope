import 'package:cinema_scope/architecture/config_view_model.dart';
import 'package:cinema_scope/main.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/widgets/frosted_app_bar.dart';
import 'package:cinema_scope/widgets/image_view.dart';
import 'package:cinema_scope/widgets/ink_well_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../constants.dart';
import '../models/movie.dart';
import 'image_page.dart';

const spacing = 2.0;
const padding = 8.0;

class ImageGalleryPage extends StatelessWidget with GenericFunctions {
  final List<ImageDetail> images;

  const ImageGalleryPage({required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final color = Colors.white.withOpacity(0.85);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverFrostedAppBar(
            // pinned: true,
            // backgroundColor: Colors.black54,
            title: Text(
              'Image Gallery',
              // style: appBarTheme.titleTextStyle?.copyWith(color: color),
            ),
            // iconTheme: appBarTheme.iconTheme?.copyWith(color: color),
            // actionsIconTheme:
            //     appBarTheme.actionsIconTheme?.copyWith(color: color),
          ),
          ...getStickySlivers(),
          const SliverToBoxAdapter(child: SizedBox(height: 56.0)),
        ],
      ),
    );
  }

  List<Widget> getStickySlivers() {
    final color = Colors.white.withOpacity(0.85);
    var profiles = images
        .where((image) => image.imageType == ImageType.profile.name)
        .toList();
    var posters = images
        .where((image) => image.imageType == ImageType.poster.name)
        .toList();
    var backdrops = images
        .where((image) => image.imageType == ImageType.backdrop.name)
        .toList();
    var logos = images
        .where((image) => image.imageType == ImageType.logo.name)
        .toList();
    logIfDebug(
        'posterCount:${posters.length}, backdropCount:${backdrops.length}, logoCount:${logos.length}');

    List<Widget> slivers = [];

    if (profiles.isNotEmpty) {
      slivers.add(
        SliverStickyHeader(
          header: buildHeader('PROFILES (${profiles.length})'),
          sliver: buildImageView(
            profiles,
            maxCrossAxisExtent: 80.0,
            pastIndices: 0,
            baseImageType: ImageType.profile,
            aspectRatio: Constants.arProfile,
          ),
        ),
      );
    }

    if (posters.isNotEmpty) {
      slivers.add(
        SliverStickyHeader(
          header: buildHeader('POSTERS (${posters.length})'),
          sliver: buildImageView(
            posters,
            maxCrossAxisExtent: 80.0,
            pastIndices: profiles.length,
            baseImageType: ImageType.poster,
            aspectRatio: Constants.arPoster,
          ),
        ),
      );
    }

    if (backdrops.isNotEmpty) {
      slivers.add(
        SliverStickyHeader(
          header: buildHeader('BACKDROPS (${backdrops.length})'),
          sliver: buildImageView(
            backdrops,
            maxCrossAxisExtent: 150.0,
            pastIndices: posters.length + profiles.length,
            baseImageType: ImageType.backdrop,
            aspectRatio: Constants.arBackdrop,
          ),
        ),
      );
      // slivers.add(
      //   SliverStickyHeader(
      //     header: buildHeader('BACKDROPS HORIZONTAL (${backdrops.length})'),
      //     sliver: SliverToBoxAdapter(
      //       child: SizedBox(
      //         height: 200.0,
      //         child: GridView.builder(
      //           padding: const EdgeInsets.symmetric(horizontal: padding),
      //           scrollDirection: Axis.horizontal,
      //           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //             maxCrossAxisExtent: 140.0 / Constants.arBackdrop,
      //             childAspectRatio: 1 / Constants.arBackdrop,
      //             mainAxisSpacing: spacing,
      //             crossAxisSpacing: spacing,
      //           ),
      //           itemBuilder: (BuildContext context, int index) {
      //             final image = backdrops[index];
      //             var imageType = image.imageType != null
      //                 ? ImageType.values
      //                 .firstWhere((element) => element.name == image.imageType)
      //                 : ImageType.backdrop;
      //             return InkWellOverlay(
      //               child: NetworkImageView(
      //                 image.filePath,
      //                 imageType: imageType,
      //                 aspectRatio: Constants.arBackdrop,
      //                 topRadius: 4.0,
      //                 bottomRadius: 4.0,
      //                 imageQuality: ImageQuality.low,
      //               ),
      //               onTap: () {
      //                 // Navigator.of(context).push(
      //                 //   MaterialPageRoute(
      //                 //     builder: (_) => ImagePage(
      //                 //       images: images,
      //                 //       initialPage: index + pastIndices,
      //                 //       placeholderQuality: ImageQuality.low,
      //                 //     ),
      //                 //   ),
      //                 // );
      //               },
      //             );
      //           },
      //           itemCount: backdrops.length,
      //         ),
      //       ),
      //     ),
      //   ),
      // );
    }

    if (logos.isNotEmpty) {
      slivers.add(
        SliverStickyHeader(
          header: buildHeader('LOGOS (${logos.length})'),
          sliver: buildImageView(
            logos,
            maxCrossAxisExtent: 100.0,
            pastIndices: posters.length + profiles.length + backdrops.length,
            baseImageType: ImageType.logo,
            aspectRatio: Constants.arBackdrop,
            backgroundColor: Colors.grey.shade500,
          ),
        ),
      );
    }

    return slivers;
  }

  SliverPadding buildImageView(
    List<ImageDetail> list, {
    required double maxCrossAxisExtent,
    required int pastIndices,
    required ImageType baseImageType,
    required double aspectRatio,
    Color? backgroundColor,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: padding, right: padding),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxCrossAxisExtent,
          childAspectRatio: aspectRatio,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
        ),
        itemBuilder: (BuildContext context, int index) {
          final image = list[index];
          var imageType = image.imageType != null
              ? ImageType.values
                  .firstWhere((element) => element.name == image.imageType)
              : baseImageType;
          return InkWellOverlay(
            child: Container(
              color: backgroundColor,
              child: NetworkImageView(
                image.filePath,
                imageType: imageType,
                aspectRatio: aspectRatio,
                topRadius: 4.0,
                bottomRadius: 4.0,
                imageQuality: ImageQuality.low,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ImagePage(
                    images: images,
                    initialPage: index + pastIndices,
                    placeholderQuality: ImageQuality.low,
                  ),
                ),
              );
            },
          );
        },
        itemCount: list.length,
      ),
    );
  }

  Widget buildHeader(String title) {
    return FrostFilter(
      Container(
        padding: EdgeInsets.only(
          left: padding,
          right: padding,
          top: kScaffoldPaddingTop, // 20.0
          bottom: 8.0,
        ),
        color: kScaffoldBackgroundColor.withOpacity(kFrostOpacity),
        child: Text(
          title,
          style: Theme.of(appContext).textTheme.bodyLarge?.copyWith(
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                // color: ,
              ),
        ),
      ),
    );
  }
}
