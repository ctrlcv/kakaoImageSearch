import 'package:extended_image/extended_image.dart' as Extended;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../models/image_item.dart';
import 'image_view.dart';

class ImageListView extends StatelessWidget {
  const ImageListView({
    Key? key,
    required this.scrollController,
    required this.imageList,
    this.emptyMessage = "표시할 항목이 없습니다",
  }) : super(key: key);
  final ScrollController scrollController;
  final List<ImageItem> imageList;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (imageList.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: (imageList.length / 2).ceil(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              buildImageItem(context, imageList[(index * 2)], (index * 2)),
              if (((index * 2) + 1) <= (imageList.length - 1))
                buildImageItem(context, imageList[(index * 2) + 1], (index * 2) + 1),
            ],
          ),
        );
      },
    );
  }

  Widget buildImageItem(BuildContext context, ImageItem item, int index) {
    double imageWidth = (MediaQuery.of(context).size.width - 40) / 2;
    double imageHeight = imageWidth;

    return GestureDetector(
      onTap: () {
        Get.to(() => ImageView(imageItem: item));
      },
      child: Container(
        width: imageWidth,
        height: imageHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E2E2), width: 2),
          image: DecorationImage(
            image: Extended.ExtendedNetworkImageProvider(item.thumbnailUrl, cache: true),
            fit: BoxFit.cover,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: Container()),
                GetBuilder<FavoriteController>(
                  init: FavoriteController(),
                  builder: (controller) {
                    return GestureDetector(
                      onTap: () {
                        if (controller.isFavoriteItem(item.hashKey)) {
                          controller.deleteFavorite(item.hashKey);
                        } else {
                          controller.addFavorite(item);
                        }
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          controller.isFavoriteItem(item.hashKey) ? CupertinoIcons.star_fill : CupertinoIcons.star,
                          size: 24,
                          color: controller.isFavoriteItem(item.hashKey) ? Colors.yellowAccent : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(child: Container()),
            Stack(
              children: [
                Container(
                  height: 24,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    item.displaySiteName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  height: 24,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    item.displaySiteName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
