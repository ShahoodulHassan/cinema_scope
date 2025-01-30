import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_scope/providers/configuration_provider.dart';
import 'package:cinema_scope/models/movie.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/widgets/image_view.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../main.dart';

class ImagePage extends StatefulWidget {
  final List<ImageDetail> images;
  final int initialPage;

  final ImageQuality placeholderQuality;

  const ImagePage({
    required this.images,
    required this.initialPage,
    this.placeholderQuality = ImageQuality.medium,
    Key? key,
  }) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> with GenericFunctions {
  final isFullscreen = ValueNotifier<bool>(false);

  late final PageController _controller = PageController(
    initialPage: widget.initialPage,
  );

  @override
  void dispose() {
    if (isFullscreen.value) exitFullScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final color = Colors.white.withValues(alpha: 0.85);
    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverStack(
            children: [
              SliverFillRemaining(
                child: PhotoViewGallery.builder(
                  pageController: _controller,
                  itemCount: widget.images.length,
                  builder: (context, index) =>
                      getPhotoViewOptions(context, widget.images[index]),
                  allowImplicitScrolling: true,
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: isFullscreen,
                builder: (_, isFullscreen, __) {
                  return isFullscreen
                      ? SliverToBoxAdapter(child: Container())
                      : SliverAppBar(
                          pinned: true,
                          backgroundColor: Colors.black54,
                          title: Text(
                            'Image${widget.images.length > 1 ? 's' : ''}',
                            style: appBarTheme.titleTextStyle
                                ?.copyWith(color: color),
                          ),
                          actions: [
                            if (Platform.isAndroid || Platform.isIOS)
                              IconButton(
                                icon: const FaIcon(
                                  FontAwesomeIcons.download,
                                  size: 22.0,
                                ),
                                tooltip: 'Save to gallery',
                                onPressed: () => saveImage(),
                              ),
                          ],
                          iconTheme:
                              appBarTheme.iconTheme?.copyWith(color: color),
                          actionsIconTheme: appBarTheme.actionsIconTheme
                              ?.copyWith(color: color),
                        );
                },
              ),
            ],
          ),
        ],
      ),

      // body: Swiper(
      //   itemBuilder: (context, index) {
      //     // return getImageView(context, images[index]);
      //     return buildPhotoView(context, images[index]);
      //   },
      //   index: initialPage,
      //   itemCount: images.length,
      //   loop: images.length > 1,
      //   // autoplay: true,
      //   indicatorLayout: PageIndicatorLayout.SCALE,
      //   pagination: const SwiperPagination(),
      //   allowImplicitScrolling: true,
      // ),

      // body: PageView.builder(
      //   itemBuilder: (context, index) => buildPhotoView(context, images[index]),
      //   controller: _controller,
      //   itemCount: images.length,
      //   allowImplicitScrolling: true,
      // ),
    );
  }

  /// Saves the current image to photo gallery.
  ///
  /// getSingleFile() either returns the cached image or downloads the image
  /// and returns it.
  ///
  /// This method also checks and prohibits saving duplicate copies of the same
  /// image.
  ///
  /// TODO 13/07/2023 Save operations should be performed via a WorkManager
  /// TODO 13/07/2023 Needs testing for iOS and web
  void saveImage() async {
    final pageNum = _controller.page;
    if (pageNum != null) {
      final url = getImageUrl(widget.images[pageNum.toInt()]);
      if (url.isNotNullNorEmpty) {
        final cacheFile = await DefaultCacheManager().getSingleFile(url);
        logIfDebug('cacheFile:${cacheFile.path}');
        const albumName = 'Cinema scope';
        if (Platform.isAndroid) {
          await _saveImageToGalleryAndroid(cacheFile.path, albumName);
        } else if (Platform.isIOS) {
          await _saveImageToGalleryIos(cacheFile.path, albumName);
        }
      } else {
        serveFreshToast('Error saving image!');
      }
    } else {
      serveFreshToast('Error saving image!');
    }
  }

  Future<void> _saveImageToGalleryAndroid(
    String inputImagePath,
    String albumName,
  ) async {
    try {
      final galleryPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_PICTURES,
      );
      if (galleryPath.isNotEmpty) {
        var filename = Uri.parse(inputImagePath).pathSegments.last;
        var imagePath = '$galleryPath/$albumName/$filename';
        logIfDebug('imagePath:$imagePath');
        File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          serveFreshToast('Image already saved!');
        } else {
          bool hasPermission = await Gal.requestAccess(toAlbum: true);
          final photosStatus = await Permission.photos.status;
          logIfDebug('hasAccess:$hasPermission, status:$photosStatus');

          if (hasPermission) {
            try {
              await Gal.putImage(inputImagePath, album: albumName);
              serveFreshToast('Image saved to gallery!');
            } on GalException catch (e) {
              logIfDebug('Gal error:${e.type.message}');
              serveFreshToast('Image save error!');
            }
          } else {
            if (photosStatus.isPermanentlyDenied) {
              if (mounted) {
                showOpenSettingsDialog();
              }
            } else {
              serveFreshToast('Permission is required for saving images');
            }
          }
        }
      } else {
        serveFreshToast('Error saving image!');
      }
    } on Exception catch (e) {
      logIfDebug(e.toString());
    }
  }

  Future<void> _saveImageToGalleryIos(
    String inputImagePath,
    String albumName,
  ) async {
    try {
      var hasPermission = await Gal.requestAccess(toAlbum: true);
      final photosStatus = await Permission.photos.status;
      logIfDebug('hasAccess:$hasPermission, status:$photosStatus');

      if (hasPermission) {
        try {
          await Gal.putImage(inputImagePath, album: albumName);
          serveFreshToast('Image saved to gallery!');
        } on GalException catch (e) {
          logIfDebug('Gal error:${e.type.message}');
          serveFreshToast('Image save error!');
        }
      } else {
        if (photosStatus.isPermanentlyDenied) {
          if (mounted) {
            showOpenSettingsDialog();
          }
        } else {
          serveFreshToast('Permission is required for saving images');
        }
      }
    } on Exception catch (e) {
      logIfDebug(e.toString());
      serveFreshToast('Image save error!');
    }
  }

  showOpenSettingsDialog() {
    showBooleanDialog(
      context,
      'Permission required',
      '${AppInfo.appName} requires permission to add photos to the '
          'gallery.\n\n'
          'Please grant the relevant permission in System settings',
      positiveButtonTitle: 'Settings',
      negativeButtonTitle: 'Cancel',
    ).then((consent) async {
      if (consent != null && consent) {
        await openAppSettings();
      }
    });
  }

  void toggleFullscreen() {
    if (isFullscreen.value) {
      isFullscreen.value = false;
      exitFullScreen();
    } else {
      isFullscreen.value = true;
      enterFullScreen();
    }
  }

  PhotoViewGalleryPageOptions getPhotoViewOptions(
      BuildContext context, ImageDetail image) {
    return PhotoViewGalleryPageOptions.customChild(
      child: buildPhotoView(context, image),
    );
  }

  PhotoView buildPhotoView(BuildContext context, ImageDetail image) {
    var imageType = image.imageType != null
        ? ImageType.values
            .firstWhere((element) => element.name == image.imageType)
        : ImageType.profile;
    return PhotoView(
      imageProvider: CachedNetworkImageProvider(getImageUrl(image)),
      onTapUp: (_, details, value) => toggleFullscreen(),
      maxScale: PhotoViewComputedScale.contained * 4.0,
      minScale: PhotoViewComputedScale.contained * 1.0,
      loadingBuilder: (_, progress) {
        return Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              NetworkImageView(
                image.filePath,
                imageType: imageType,
                aspectRatio: image.aspectRatio,
                imageQuality: widget.placeholderQuality,
              ),
              if (progress != null)
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: kPrimaryContainer,
                    color: kPrimary,
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                        : null,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String getImageUrl(ImageDetail image) {
    var imageType = image.imageType != null
        ? ImageType.values
            .firstWhere((element) => element.name == image.imageType)
        : ImageType.profile;
    var imageUrl = image.filePath.contains('/http')
        ? image.filePath.replaceFirst('/http', 'http')
        : context
            .read<ConfigurationProvider>()
            .getImageUrl(imageType, ImageQuality.original, image.filePath);
    return imageUrl;
  }

  @Deprecated('InteractiveViewer didn\'t work as per my requirements')
  Widget getImageView(BuildContext context, ImageDetail image) {
    var imageType = image.imageType != null
        ? ImageType.values
            .firstWhere((element) => element.name == image.imageType)
        : ImageType.profile;
    return InteractiveViewer(
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            NetworkImageView(
              image.filePath,
              imageType: imageType,
              aspectRatio: image.aspectRatio,
              imageQuality: widget.placeholderQuality,
              // heroImageTag: image.filePath,
            ),
            // if (progress != null)
            //   Center(
            //     child: CircularProgressIndicator(
            //       backgroundColor: Theme.of(context).primaryColorLight,
            //       color: Theme.of(context).primaryColor,
            //       value: progress.expectedTotalBytes != null
            //           ? progress.cumulativeBytesLoaded /
            //           progress.expectedTotalBytes!
            //           : null,
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
