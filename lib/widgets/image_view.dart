import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_scope/architecture/config_view_model.dart';
import 'package:cinema_scope/main.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../utilities/generic_functions.dart';

class NetworkImageView extends StatelessWidget
    with GenericFunctions, Utilities, CommonFunctions {
  final String? imagePath;

  final ImageType imageType;

  final ImageQuality imageQuality;

  final double topRadius, bottomRadius, aspectRatio;

  final BoxFit fit;

  final String? heroImageTag;

  final Widget placeholder = Image.asset(
    Constants.placeholderPath,
    fit: BoxFit.contain,
  );

  late final Widget loadingPlaceholder = Container(
    decoration: BoxDecoration(
      borderRadius: borderRadius,
      color: kPrimary.lighten2(88),
    ),
  );

  BorderRadius get borderRadius {
    if (topRadius > 0 || bottomRadius > 0) {
      return BorderRadius.only(
        topRight: Radius.circular(topRadius),
        topLeft: Radius.circular(topRadius),
        bottomRight: Radius.circular(bottomRadius),
        bottomLeft: Radius.circular(bottomRadius),
      );
    }
    return BorderRadius.zero;
  }

  NetworkImageView(
    this.imagePath, {
    Key? key,
    required this.imageType,
    this.imageQuality = ImageQuality.medium,
    required this.aspectRatio,
    this.topRadius = 0.0,
    this.bottomRadius = 0.0,
    this.fit = BoxFit.fill,
    this.heroImageTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (imagePath == null) {
      child = placeholder;
    } else {
      // double imageWidth = width == null ? MediaQuery.of(context).size.width : width!;
      String imageUrl = imagePath!.startsWith('http')
          ? imagePath!
          : imagePath!.contains('/http')
              ? imagePath!.replaceFirst('/http', 'http')
              : context
                  .read<ConfigViewModel>()
                  .getImageUrl(imageType, imageQuality, imagePath!);
      // logIfDebug('imagePath:$imagePath, imageUrl:$imageUrl');
      child = CachedNetworkImage(
        alignment: Alignment.topRight,
        imageUrl: imageUrl,
        placeholder: (_, __) => loadingPlaceholder,
        errorWidget: (_, __, ___) {
          return const Center(
            child: Icon(
              Icons.error_outline_sharp,
              color: Colors.red,
            ),
          );
        },
        fit: fit,
      );
    }
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: heroImageTag != null
            ? Hero(tag: heroImageTag!, child: child)
            : child,
      ),
    );
  }
}

class CustomHeroView extends StatelessWidget with GenericFunctions {
  final String? sourceUrl, destUrl;
  final String heroImageTag;

  const CustomHeroView(this.sourceUrl, this.destUrl, this.heroImageTag,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');
    String? loadableUrl;
    Widget child = Image.asset(Constants.placeholderPath);
    if (sourceUrl != null) {
      loadableUrl = sourceUrl;
      if (destUrl != null && destUrl != sourceUrl) {
        loadableUrl = destUrl;
      }
      logIfDebug('sourceUrl:$sourceUrl, destUrl:$destUrl, '
          'loadableUrl:$loadableUrl');
      String sourcePath = sourceUrl!.split("/").last;
      String destPath = loadableUrl!.split("/").last;
      logIfDebug('hasKey: ${imageCache.containsKey(loadableUrl)}');
      if (loadableUrl != sourceUrl) {
        Widget placeholderView = Image.network(
          sourceUrl!,
          fit: sourcePath == destPath ? BoxFit.fill : BoxFit.cover,
        );
        if (sourcePath != destPath) {
          placeholderView = ClipRRect(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: placeholderView,
            ),
          );
        }
        child = CachedNetworkImage(
          imageUrl: loadableUrl,
          placeholder: (_, url) => placeholderView,
          fadeOutDuration:
              Duration(milliseconds: sourcePath == destPath ? 1 : 300),
          fadeInDuration:
              Duration(milliseconds: sourcePath == destPath ? 1 : 700),
          fit: BoxFit.fill,
        );
      } else {
        child = Image.network(
          loadableUrl,
          errorBuilder: (_, error, stacktrace) {
            logIfDebug('image load error:$stacktrace');
            return Image.asset('assets/images/placeholder.png');
          },
          fit: BoxFit.fill,
        );
      }
    }
    return AspectRatio(
      aspectRatio: Constants.arBackdrop,
      // That's the actual aspect ratio of TMDB posters
      child: Hero(
        tag: heroImageTag,
        // flightShuttleBuilder: (a, b, c, d, e) {
        //   return widget.sourceUrl != null
        //       ? Image.network(widget.sourceUrl!, fit: BoxFit.fill)
        //       : Padding(
        //           padding: const EdgeInsets.all(24.0),
        //           child: Image.asset(
        //             'assets/images/placeholder.png',
        //           ),
        //         );
        // },
        child: child,
      ),
    );
  }
}
