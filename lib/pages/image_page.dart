import 'package:card_swiper/card_swiper.dart';
import 'package:cinema_scope/architecture/config_view_model.dart';
import 'package:cinema_scope/models/movie.dart';
import 'package:cinema_scope/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class ImagePage extends StatelessWidget {
  final List<ImageDetail> images;
  final int initialPage;
  final ImageType imageType;
  final ImageQuality placeholderQuality;

  ImagePage({
    required this.images,
    required this.initialPage,
    required this.imageType,
    this.placeholderQuality = ImageQuality.medium,
    Key? key,
  }) : super(key: key);

  late final PageController _controller = PageController(
    initialPage: initialPage,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper(
        itemBuilder: (context, index) {
          return buildPhotoView(context, images[index]);
        },
        index: initialPage,
        itemCount: images.length,
        loop: images.length > 1,
        // autoplay: true,
        indicatorLayout: PageIndicatorLayout.SCALE,
        pagination: const SwiperPagination(),
        allowImplicitScrolling: true,
      ),
      // body: PageView.builder(
      //   itemBuilder: (context, index) => buildPhotoView(context, images[index]),
      //   controller: _controller,
      //   itemCount: images.length,
      //   allowImplicitScrolling: true,
      // ),
    );
  }

  PhotoView buildPhotoView(BuildContext context, ImageDetail image) {
    return PhotoView(
      imageProvider: Image.network(getImageUrl(image, context)).image,
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
                imageQuality: placeholderQuality,
                // heroImageTag: image.filePath,
              ),
              if (progress != null)
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    color: Theme.of(context).primaryColor,
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

  String getImageUrl(ImageDetail image, BuildContext context) {
    String imageUrl = image.filePath.contains('/http')
        ? image.filePath.replaceFirst('/http', 'http')
        : context
            .read<ConfigViewModel>()
            .getImageUrl(imageType, ImageQuality.original, image.filePath);
    return imageUrl;
  }
}
