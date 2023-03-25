import 'package:extended_image/extended_image.dart' as Extended;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../models/image_item.dart';

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({Key? key}) : super(key: key);

  static const routeName = '/ImageViewPage';

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  late PageController _pageController;

  List<ImageItem> _imageItemList = [];
  int _imageIndex = 0;

  @override
  void initState() {
    super.initState();

    Map<String, dynamic> params = Get.arguments;

    _imageItemList = params['_imageItemList'];
    _imageIndex = params['_imageIndex'];

    _pageController = PageController(initialPage: _imageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double arrowPosY = (MediaQuery.of(context).size.height - 40) / 2;

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
                  imageProvider: Extended.ExtendedNetworkImageProvider(_imageItemList[index].imageUrl!, cache: true),
                  heroAttributes: PhotoViewHeroAttributes(tag: index),
                );
              },
              itemCount: _imageItemList.length,
              backgroundDecoration: const BoxDecoration(color: Colors.transparent),
              allowImplicitScrolling: true,
              pageController: _pageController,
              onPageChanged: (int page) {
                _imageIndex = (page + 1);
                if (mounted) {
                  setState(() {});
                }
              },
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
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.close, color: Color(0xFFFFFFFE), size: 36),
            ),
          ),
          if (_imageIndex != _imageItemList.length)
            Positioned(
              top: arrowPosY,
              right: 23,
              child: GestureDetector(
                onTap: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                child: const Icon(Icons.arrow_forward_ios, size: 40, color: Colors.white),
              ),
            ),
          if (_imageIndex != 1)
            Positioned(
              top: arrowPosY,
              left: 23,
              child: GestureDetector(
                onTap: () {
                  _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                },
                child: const Icon(Icons.arrow_back_ios, size: 40, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
