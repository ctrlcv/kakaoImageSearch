import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import 'image_list_view.dart';

class FavoriteListView extends StatelessWidget {
  const FavoriteListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteController>(
      init: Get.find<FavoriteController>(),
      builder: (controller) {
        return ImageListView(
          imageList: controller.favoriteImageList,
          scrollController: ScrollController(),
        );
      },
    );
  }
}
