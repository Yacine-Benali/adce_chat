import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageFullScreen extends StatelessWidget {
  final String url;
  final String tag;
  ImageFullScreen(this.tag, this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => PhotoView(
          imageProvider: imageProvider,
        ),
      ),
    );
  }
}
