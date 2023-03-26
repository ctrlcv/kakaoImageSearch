import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threedotthree/repository/image_repository.dart';

import '../models/image_item.dart';

class ImageController extends GetxController {
  List<ImageItem> _imageList = [];
  int _totalImageCount = 0;
  int _pageableCount = 0;
  int _pageIndex = 0;
  bool _isEnd = false;
  bool _isLoading = false;
  bool _isNoItem = false;
  String _searchWord = "";
  double _scrollOffset = 0;
  List<ArrangedImageItem> _arrangedItemList = [];

  List<ImageItem> get imageList => _imageList;
  int get totalImageCount => _totalImageCount;
  int get pageableCount => _pageableCount;
  int get pageIndex => _pageIndex;
  bool get isEndPage => _isEnd;
  bool get isLoading => _isLoading;
  bool get isNoItem => _isNoItem;
  String get searchWord => _searchWord;
  double get scrollOffset => _scrollOffset;
  List<ArrangedImageItem> get arrangedItemList => _arrangedItemList;

  Future getImages(String searchWord) async {
    // 검색어가 비어 있을 경우: 상태값을 초기화한다.
    if (searchWord.isEmpty) {
      initialVariables();
      update();
      return;
    }

    if (_isEnd && _searchWord == searchWord) {
      return;
    }

    _isLoading = true;
    update();

    // 검색어가 변경되었을 때: 상태값을 초기화한다.
    if (_searchWord != searchWord) {
      initialVariables();
      _searchWord = searchWord;
    }

    _pageIndex++;

    Map<String, dynamic> params = {};
    params['query'] = searchWord;
    params['page'] = _pageIndex.toString();

    ImageSearchResponse? imageSearchResponse = await ImageRepository().getImageItems(params);
    if (imageSearchResponse != null) {
      _totalImageCount = imageSearchResponse.meta!.totalCount!;
      _pageableCount = imageSearchResponse.meta!.pageableCount!;
      _isEnd = imageSearchResponse.meta!.isEnd ?? false;

      if (imageSearchResponse.documents!.isNotEmpty) {
        _imageList.addAll(imageSearchResponse.documents!);
        makeArrangedItemList();
      }
    }

    debugPrint("ImageController.getImages() _totalImageCount $_totalImageCount _pageIndex $_pageIndex");

    _isNoItem = (_totalImageCount == 0);
    _isLoading = false;
    update();
  }

  void setScrollOffset(double offset) {
    _scrollOffset = offset;
  }

  void initialVariables() {
    _totalImageCount = 0;
    _pageableCount = 0;
    _pageIndex = 0;
    _scrollOffset = 0.0;
    _isEnd = false;
    _isLoading = false;
    _isNoItem = false;

    _imageList = [];
    _searchWord = "";
    _arrangedItemList = [];
  }

  void makeArrangedItemList() {
    int startIndex = 0;
    String lastItemHashKey = "";

    if (_imageList.isNotEmpty && _arrangedItemList.isNotEmpty) {
      ArrangedImageItem lastArrangedItem = _arrangedItemList[_arrangedItemList.length - 1];

      if (lastArrangedItem.isFilled != true) {
        _arrangedItemList.removeAt(_arrangedItemList.length - 1);
      }

      lastItemHashKey = lastArrangedItem.items[lastArrangedItem.items.length - 1].hashKey;
    }

    debugPrint("makeArrangedItemList() lastItemHashKey $lastItemHashKey");

    if (lastItemHashKey.isNotEmpty) {
      for (int i = 0; i < _imageList.length; i++) {
        if (_imageList[i].hashKey == lastItemHashKey) {
          startIndex = i + 1;
          break;
        }
      }
    }

    if (startIndex >= _imageList.length) {
      debugPrint("makeArrangedItemList() something wrong...startIndex set 0");
      startIndex = 0;
    }

    // debugPrint("makeArrangedItemList() startIndex $startIndex");

    double screenWidth = Get.width;
    int imageIndex = startIndex;

    const double minImageHeight = 100;
    const double maxImageHeight = 300;
    const double fixedImageHeight = 300;

    while (imageIndex < _imageList.length) {
      int image1stWidth = _imageList[imageIndex].width;
      int image1stHeight = _imageList[imageIndex].height;

      if (image1stWidth > image1stHeight) {
        double calcImageHeight = (image1stHeight * (screenWidth - 8)) / image1stWidth;
        if (calcImageHeight >= minImageHeight && calcImageHeight <= maxImageHeight) {
          List<ImageItem> imageItems = [];
          imageItems.add(_imageList[imageIndex]);
          _arrangedItemList.add(ArrangedImageItem(isFilled: true, imageHeight: calcImageHeight, items: imageItems));

          imageIndex++;
          continue;
        }
      }

      if (imageIndex + 1 >= _imageList.length) {
        List<ImageItem> imageItems = [];
        imageItems.add(_imageList[imageIndex]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: false, imageHeight: fixedImageHeight, items: imageItems));
        break;
      }

      int image2ndWidth = _imageList[imageIndex + 1].width;
      int image2ndHeight = _imageList[imageIndex + 1].height;

      double calcImage2ndWidth = (image1stHeight * image2ndWidth) / image2ndHeight;
      double calcImageHeight = (image1stHeight * (screenWidth - 16)) / (image1stWidth + calcImage2ndWidth);

      if (calcImageHeight >= minImageHeight && calcImageHeight <= maxImageHeight) {
        List<ImageItem> imageItems = [];
        imageItems.add(_imageList[imageIndex]);
        imageItems.add(_imageList[imageIndex + 1]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: true, imageHeight: calcImageHeight, items: imageItems));
        imageIndex += 2;
        continue;
      }

      if (imageIndex + 2 >= _imageList.length) {
        List<ImageItem> imageItems = [];
        imageItems.add(_imageList[imageIndex]);
        imageItems.add(_imageList[imageIndex + 1]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: false, imageHeight: fixedImageHeight, items: imageItems));
        break;
      }

      int image3rdWidth = _imageList[imageIndex + 2].width;
      int image3rdHeight = _imageList[imageIndex + 2].height;

      calcImage2ndWidth = (image1stHeight * image2ndWidth) / image2ndHeight;
      double calcImage3rdWidth = (image1stHeight * image3rdWidth) / image3rdHeight;
      calcImageHeight = (image1stHeight * (screenWidth - 24)) / (image1stWidth + calcImage2ndWidth + calcImage3rdWidth);

      if (calcImageHeight >= minImageHeight && calcImageHeight <= maxImageHeight) {
        List<ImageItem> imageItems = [];
        imageItems.add(_imageList[imageIndex]);
        imageItems.add(_imageList[imageIndex + 1]);
        imageItems.add(_imageList[imageIndex + 2]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: true, imageHeight: calcImageHeight, items: imageItems));
        imageIndex += 3;
        continue;
      }

      if (imageIndex + 3 >= _imageList.length) {
        List<ImageItem> imageItems = [];
        imageItems.add(_imageList[imageIndex]);
        imageItems.add(_imageList[imageIndex + 1]);
        imageItems.add(_imageList[imageIndex + 2]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: false, imageHeight: fixedImageHeight, items: imageItems));
        break;
      }

      int image4thWidth = _imageList[imageIndex + 3].width;
      int image4thHeight = _imageList[imageIndex + 3].height;

      calcImage2ndWidth = (image1stHeight * image2ndWidth) / image2ndHeight;
      calcImage3rdWidth = (image1stHeight * image3rdWidth) / image3rdHeight;
      double calcImage4thWidth = (image1stHeight * image4thWidth) / image4thHeight;
      calcImageHeight = (image1stHeight * (screenWidth - 32)) /
          (image1stWidth + calcImage2ndWidth + calcImage3rdWidth + calcImage4thWidth);

      if (calcImageHeight >= minImageHeight && calcImageHeight <= maxImageHeight) {
        List<ImageItem> imageItems = [];
        imageItems.add(_imageList[imageIndex]);
        imageItems.add(_imageList[imageIndex + 1]);
        imageItems.add(_imageList[imageIndex + 2]);
        imageItems.add(_imageList[imageIndex + 3]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: true, imageHeight: calcImageHeight, items: imageItems));

        imageIndex += 4;
        continue;
      }

      if (imageIndex + 4 >= _imageList.length) {
        List<ImageItem> imageItems = [];
        imageItems.add(_imageList[imageIndex]);
        imageItems.add(_imageList[imageIndex + 1]);
        imageItems.add(_imageList[imageIndex + 2]);
        imageItems.add(_imageList[imageIndex + 3]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: false, imageHeight: fixedImageHeight, items: imageItems));
        break;
      }

      int image5thWidth = _imageList[imageIndex + 4].width;
      int image5thHeight = _imageList[imageIndex + 4].height;

      calcImage2ndWidth = (image1stHeight * image2ndWidth) / image2ndHeight;
      calcImage3rdWidth = (image1stHeight * image3rdWidth) / image3rdHeight;
      calcImage4thWidth = (image1stHeight * image4thWidth) / image4thHeight;
      double calcImage5thWidth = (image1stHeight * image5thWidth) / image5thHeight;

      calcImageHeight = (image1stHeight * (screenWidth - 40)) /
          (image1stWidth + calcImage2ndWidth + calcImage3rdWidth + calcImage4thWidth + calcImage5thWidth);

      if (calcImageHeight >= minImageHeight && calcImageHeight <= maxImageHeight) {
        List<ImageItem> imageItems = [];
        imageItems.add(_imageList[imageIndex]);
        imageItems.add(_imageList[imageIndex + 1]);
        imageItems.add(_imageList[imageIndex + 2]);
        imageItems.add(_imageList[imageIndex + 3]);
        imageItems.add(_imageList[imageIndex + 4]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: true, imageHeight: calcImageHeight, items: imageItems));
        imageIndex += 5;
        continue;
      }

      List<ImageItem> imageItems = [];
      imageItems.add(_imageList[imageIndex]);

      calcImageHeight = (image1stHeight * (screenWidth - 8)) / image1stWidth;

      _arrangedItemList.add(ArrangedImageItem(isFilled: true, imageHeight: calcImageHeight, items: imageItems));

      imageIndex++;
      continue;
    }

    // debugPrint("makeArrangedItemList() end");
  }
}
