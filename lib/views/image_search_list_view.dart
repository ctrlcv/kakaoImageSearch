import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threedotthree/controllers/image_controller.dart';

import 'image_list_view.dart';

class ImageSearchListView extends StatefulWidget {
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
      final imageController = Get.find<ImageController>();
      _searchEditController.text = imageController.searchWord;
      _scrollController.jumpTo(imageController.scrollOffset);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void scrollListener() async {
    final imageController = Get.find<ImageController>();

    double offset = ((_scrollController.offset) / 100).floor() * 100;
    imageController.setScrollOffset(_scrollController.offset);

    if (offset != _currentOffset) {
      _currentOffset = offset;

      if (imageController.isLoading == false) {
        double reloadOffset =
            _scrollController.position.maxScrollExtent - (((MediaQuery.of(context).size.width - 40) / 2) * 8);

        // debugPrint("offset $offset reloadOffset $reloadOffset, max ${_scrollController.position.maxScrollExtent}");

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
      child: TextFormField(
        controller: _searchEditController,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
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
          // if (value.isEmpty) {
          //   return;
          // }

          Get.find<ImageController>().getImages(value);
        },
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
              return ImageListView(
                imageList: controller.imageList,
                scrollController: _scrollController,
              );
            },
          ),
        ),
      ],
    );
  }
}
