import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import 'image_list_view.dart';

class FavoriteListView extends StatefulWidget {
  const FavoriteListView({Key? key}) : super(key: key);

  @override
  State<FavoriteListView> createState() => _FavoriteListViewState();
}

class _FavoriteListViewState extends State<FavoriteListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Tab 간 이동시 scroll 상태값 복원
      double offset = Get.find<FavoriteController>().scrollOffset;
      if (Get.find<FavoriteController>().favoriteImageList.isNotEmpty &&
          offset <= _scrollController.position.maxScrollExtent) {
        _scrollController.jumpTo(offset);
      }
    });
  }

  void scrollListener() async {
    // 이후 복원을 위해 현재 scroll 위치값을 저장
    Get.find<FavoriteController>().setScrollOffset(_scrollController.offset);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteController>(
      init: Get.find<FavoriteController>(),
      builder: (controller) {
        return Stack(
          children: [
            ImageListView(
              imageList: controller.favoriteImageList,
              scrollController: _scrollController,
              emptyMessage: "즐겨찾기한 항목이 없습니다",
            ),
            if (controller.isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF407BFF)),
                ),
              )
          ],
        );
      },
    );
  }
}
