import 'package:extended_image/extended_image.dart' as Extended;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../models/image_item.dart';

class ImageView extends StatelessWidget {
  const ImageView({Key? key, required this.imageItem}) : super(key: key);

  final ImageItem imageItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: Extended.ExtendedNetworkImageProvider(imageItem.imageUrl, cache: true),
                  heroAttributes: PhotoViewHeroAttributes(tag: index),
                );
              },
              itemCount: 1,
              backgroundDecoration: const BoxDecoration(color: Colors.transparent),
              allowImplicitScrolling: true,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 46,
            right: 23,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.close, color: Color(0xFFFFFFFE), size: 36),
            ),
          ),
        ],
      ),
    );
  }
}
