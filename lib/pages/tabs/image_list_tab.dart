import 'package:extended_image/extended_image.dart' as Extended;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:threedotthree/apis/kakao_apis.dart';

import '../../models/image_item.dart';
import '../image_view_page.dart';

class ImageListTab extends StatefulWidget {
  const ImageListTab({Key? key}) : super(key: key);

  @override
  State<ImageListTab> createState() => _ImageListTabState();
}

class _ImageListTabState extends State<ImageListTab> {
  final TextEditingController _searchEditController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _hiveBox = Hive.box<ImageItem>('favorite');

  bool _isLoading = false;
  List<ImageItem> _imageList = [];
  int _totalCount = 0;
  int _pageableCount = 0;
  int _pageIndex = 1;
  bool _isEnd = false;
  double _currentOffset = 0;
  String _searchKeyword = "";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    _searchEditController.dispose();
    super.dispose();
  }

  void scrollListener() async {
    double offset = ((_scrollController.offset) / 100).floor() * 100;

    if (offset != _currentOffset) {
      _currentOffset = offset;

      if (_isLoading == false) {
        double reloadOffset =
            _scrollController.position.maxScrollExtent - (((MediaQuery.of(context).size.width - 40) / 2) * 8);

        debugPrint("offset $offset reloadOffset $reloadOffset, max ${_scrollController.position.maxScrollExtent}");

        if (offset >= reloadOffset) {
          if (_isEnd == false) {
            _pageIndex++;
            await getImageSearch();
          }
        }
      }
    }
  }

  Future getImageSearch() async {
    if (_searchEditController.text.isEmpty) {
      return;
    }

    if (_isEnd) {
      return;
    }

    if (_searchKeyword != _searchEditController.text) {
      _pageIndex = 1;
      _isEnd = false;
      _imageList.clear();
      _searchKeyword = _searchEditController.text;
    }

    _isLoading = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> params = {};
    params['query'] = _searchEditController.text;
    params['page'] = _pageIndex.toString();

    ImageSearchResponse? imageSearchResponse = await KakaoApis().getImageItems(params);
    if (imageSearchResponse != null) {
      _totalCount = imageSearchResponse.meta!.totalCount!;
      _pageableCount = imageSearchResponse.meta!.pageableCount!;
      _isEnd = imageSearchResponse.meta!.isEnd ?? false;

      if (imageSearchResponse.documents!.isNotEmpty) {
        _imageList.addAll(imageSearchResponse.documents!);
      }

      debugPrint("$_imageList");
    }

    debugPrint(
        "_totalCount $_totalCount, _pageableCount $_pageableCount, _isEnd $_isEnd, _imageList.length ${_imageList.length}");

    _isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSearchEdit(),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 6),
            itemCount: (_imageList.length / 2).ceil(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    buildImageItem(_imageList[(index * 2)], (index * 2)),
                    if ((index * 2) <= (_imageList.length - 1))
                      buildImageItem(_imageList[(index * 2) + 1], (index * 2) + 1),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildImageItem(ImageItem item, int index) {
    double imageWidth = (MediaQuery.of(context).size.width - 40) / 2;
    double imageHeight = imageWidth;
    ImageItem? favoriteItem = _hiveBox.get(item.hashKey);

    return GestureDetector(
      onTap: () {
        Map<String, dynamic> params = {};
        params['_imageItemList'] = _imageList;
        params['_imageIndex'] = index;

        Get.toNamed(ImageViewPage.routeName, arguments: params);
      },
      child: Container(
        width: imageWidth,
        height: imageHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E2E2), width: 2),
          image: DecorationImage(
            image: Extended.ExtendedNetworkImageProvider(item.thumbnailUrl!, cache: true),
            fit: BoxFit.cover,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () async {
                    if (favoriteItem == null) {
                      _hiveBox.put(item.hashKey, item);
                    } else {
                      _hiveBox.delete(item.hashKey);
                    }

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: Container(
                    height: 24,
                    width: 24,
                    alignment: Alignment.center,
                    color: Colors.brown,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      (favoriteItem == null) ? CupertinoIcons.star : CupertinoIcons.star_fill,
                      size: 24,
                      color: (favoriteItem == null) ? Colors.grey : Colors.yellowAccent,
                    ),
                  ),
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
                    item.displaySiteName ?? "없음",
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
                    item.displaySiteName ?? "",
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

  Widget buildSearchEdit() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TextFormField(
        controller: _searchEditController,
        decoration: const InputDecoration(
          suffixIcon: Icon(CupertinoIcons.search, color: Color(0xFF307BFF)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          hintText: "검색어를 입력하세요",
          hintStyle: TextStyle(
            fontSize: 14,
            color: Color(0xFF979797),
            height: 1.4,
          ),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF307BFF),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF307BFF),
              width: 2.0,
            ),
          ),
        ),
        onFieldSubmitted: (value) {
          if (value.isEmpty) {
            return;
          }

          _pageIndex = 1;
          getImageSearch();
        },
      ),
    );
  }
}
