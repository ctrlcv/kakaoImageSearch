import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../models/image_item.dart';
import 'image_view.dart';

/*
*   전달받은 이미지의 width/height 를 사용하여 이미지를 자르지 않고 폰 가로사이즈에 맞게 resize 하여 표시
*   thumbnailUrl 을 사용하면 width/height 에 맞지 않은 이미지가 전달되어 imageUrl 을 사용
* */
class ImageListViewEx extends StatelessWidget {
  const ImageListViewEx({
    Key? key,
    required this.scrollController,
    required this.imageList,
    this.emptyMessage = "표시할 항목이 없습니다",
  }) : super(key: key);

  final ScrollController scrollController;
  final List<ArrangedImageItem> imageList;
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
      itemCount: imageList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildArrangedImageItems(imageList[index]);
      },
    );
  }

  Widget buildArrangedImageItems(ArrangedImageItem arrangedItem) {
    return Row(
      children: arrangedItem.items.map((item) {
        return buildImageItem(item, arrangedItem.imageHeight);
      }).toList(),
    );
  }

  Widget buildImageItem(ImageItem item, double imageHeight) {
    double imageWidth = (item.width * imageHeight) / item.height;

    return GestureDetector(
      onTap: () {
        Get.to(() => ImageView(imageItem: item));
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ExtendedImage.network(
              item.imageUrl,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.fitWidth,
              cache: true,
              loadStateChanged: (ExtendedImageState state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE2E2E2)),
                        ),
                      ),
                    );

                  case LoadState.failed:
                    return GestureDetector(
                      onTap: () {
                        state.reLoadImage();
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text("😧", style: TextStyle(fontSize: 22)),
                            SizedBox(height: 8),
                            Text(
                              "Loading fail",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                  default:
                    break;
                }
              },
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
  }
}
