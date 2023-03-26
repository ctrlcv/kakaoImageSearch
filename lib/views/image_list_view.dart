import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../models/image_item.dart';
import 'image_view.dart';

/*
*   thumbnailUrl 을 사용하여 Grid 로 3행으로 표시, 가로가 360보다 적은 사이즈의 폰이면 2행 표시
* */
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

    double screenWidth = MediaQuery.of(context).size.width;
    int columnCount = 2;
    if (screenWidth > 360) {
      columnCount = 3;
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: (imageList.length / columnCount).ceil(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              buildImageItem(context, imageList[(index * columnCount)], (index * columnCount)),
              if (((index * columnCount) + 1) <= (imageList.length - 1))
                buildImageItem(context, imageList[(index * columnCount) + 1], (index * columnCount) + 1),
              if (columnCount == 3 && ((index * columnCount) + 2) <= (imageList.length - 1))
                buildImageItem(context, imageList[(index * columnCount) + 2], (index * columnCount) + 2),
            ],
          ),
        );
      },
    );
  }

  Widget buildImageItem(BuildContext context, ImageItem item, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    int columnCount = 2;
    if (screenWidth > 360) {
      columnCount = 3;
    }

    double imageWidth = (MediaQuery.of(context).size.width - 32) / columnCount;
    double imageHeight = imageWidth;

    return GestureDetector(
      onTap: () {
        Get.to(() => ImageView(imageItem: item));
      },
      child: Stack(
        children: [
          Container(
            width: imageWidth,
            height: imageHeight,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: ExtendedImage.network(
              item.thumbnailUrl,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.cover,
              cache: true,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          Positioned(
            top: 10,
            right: 2,
            child: GetBuilder<FavoriteController>(
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
          ),
          Positioned(
            bottom: 10,
            left: 2,
            child: Stack(
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
                      fontSize: 13.1,
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
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        Get.to(() => ImageView(imageItem: item));
      },
      child: Container(
        width: imageWidth,
        height: imageHeight,
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
