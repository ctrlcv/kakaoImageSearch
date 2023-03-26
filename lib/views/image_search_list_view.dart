import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threedotthree/controllers/image_controller.dart';

import '../controllers/setting_controller.dart';
import '../models/image_item.dart';
import 'image_list_vew_ex.dart';
import 'image_list_view.dart';

class ImageSearchListView extends StatefulWidget {
  //
  const ImageSearchListView({Key? key}) : super(key: key);

  @override
  State<ImageSearchListView> createState() => _ImageSearchListViewState();
}

class _ImageSearchListViewState extends State<ImageSearchListView> {
  final TextEditingController _searchEditController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  double _currentOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Tab 간 이동시 검색어 및 scroll 상태값 복원
      final imageController = Get.find<ImageController>();
      _searchEditController.text = imageController.searchWord;

      if (_searchEditController.text.isNotEmpty && imageController.imageList.isNotEmpty) {
        _scrollController.jumpTo(imageController.scrollOffset);
      }
    });
  }

  void scrollListener() async {
    final imageController = Get.find<ImageController>();

    double offset = ((_scrollController.offset) / 100).floor() * 100;

    // 이후 복원을 위해 현재 scroll 위치값을 저장
    imageController.setScrollOffset(_scrollController.offset);

    // 100 단위로 scroll 될때마다 확인
    if (offset != _currentOffset) {
      _currentOffset = offset;

      if (imageController.isLoading == false) {
        double reloadOffset =
            _scrollController.position.maxScrollExtent - (((MediaQuery.of(context).size.width - 40) / 2) * 8);

        // 현재 scroll 위치가 전체 scroll 에서 사진 8 개의 높이 이하로 왔을 때: 동일 검색어로 다음 PageIndex 의 사진을 조회한다.
        if (offset >= reloadOffset) {
          if (imageController.isEndPage == false) {
            debugPrint("load more!!!!");
            await imageController.getImages(_searchEditController.text);
          }
        }
      }
    }
  }

  Widget buildSearchEdit() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _searchEditController,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    // 검색창을 지우고 조회시 초기화하게 처리
                    // if (_searchEditController.text.isEmpty) {
                    //   return;
                    // }

                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();

                    Get.find<ImageController>().getImages(_searchEditController.text);
                  },
                  child: const Icon(CupertinoIcons.search, color: Color(0xFF307BFF)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                hintText: "검색어를 입력하세요",
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF979797),
                  height: 1.4,
                ),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF307BFF),
                    width: 1.0,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF307BFF),
                    width: 2.0,
                  ),
                ),
              ),
              onFieldSubmitted: (value) {
                // 검색창을 지우고 조회시 초기화하게 처리
                // if (value.isEmpty) {
                //   return;
                // }

                Get.find<ImageController>().getImages(value);
              },
            ),
          ),
          const SizedBox(width: 8),
          GetBuilder<SettingController>(
            init: Get.find<SettingController>(),
            builder: (controller) {
              return GestureDetector(
                onTap: () {
                  controller.setGridMode(!controller.isGridMode);
                },
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.rectangle_3_offgrid, size: 24),
                    const SizedBox(width: 6),
                    Image.asset(
                      controller.isGridMode ? 'assets/images/switch_on.png' : 'assets/images/switch_off.png',
                      width: 36,
                      fit: BoxFit.fitWidth,
                    ),
                    const SizedBox(width: 6),
                    const Icon(CupertinoIcons.rectangle_grid_2x2, size: 24)
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSearchEdit(),
        Expanded(
          child: GetBuilder<ImageController>(
            init: Get.find<ImageController>(),
            builder: (controller) {
              debugPrint("GridMode: ${Get.find<SettingController>().isGridMode}");
              List<ImageItem> imageList = controller.imageList;
              List<ArrangedImageItem> arrangedItemList = controller.arrangedItemList;

              return (controller.isNoItem == false && controller.imageList.isEmpty)
                  ? const Center(
                      child: Text(
                        "검색어를 입력하세요",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : controller.isNoItem
                      ? const Center(
                          child: Text(
                            "검색 결과가 없습니다",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Stack(
                          children: [
                            GetBuilder<SettingController>(
                              init: Get.find<SettingController>(),
                              builder: (controller) {
                                return controller.isGridMode
                                    ? ImageListView(
                                        imageList: imageList,
                                        scrollController: _scrollController,
                                      )
                                    : ImageListViewEx(
                                        imageList: arrangedItemList,
                                        scrollController: _scrollController,
                                      );
                              },
                            ),
                            if (controller.isLoading)
                              const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF407BFF)),
                                ),
                              ),
                          ],
                        );
            },
          ),
        ),
      ],
    );
  }
}
