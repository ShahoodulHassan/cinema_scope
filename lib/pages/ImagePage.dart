import 'package:cinema_scope/architecture/config_view_model.dart';
import 'package:cinema_scope/models/movie.dart';
import 'package:cinema_scope/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';


class ImagePage extends StatelessWidget {
  final ImageDetail image;
  final ImageType imageType;

  const ImagePage({
    required this.image,
    required this.imageType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = image.filePath.contains('/http')
        ? image.filePath.replaceFirst('/http', 'http')
        : context
            .read<ConfigViewModel>()
            .getImageUrl(imageType, ImageQuality.original, image.filePath);
    return Scaffold(
      body: PhotoView(
        imageProvider: Image.network(imageUrl).image,
        loadingBuilder: (_, __) {
          return Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: NetworkImageView(
              image.filePath,
              imageType: imageType,
              aspectRatio: image.aspectRatio,
              // heroImageTag: image.filePath,
            ),
          );
        },
      ),
    );
  }
}
