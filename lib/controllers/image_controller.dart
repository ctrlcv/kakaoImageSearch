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

  List<ImageItem> get imageList => _imageList;
  int get totalImageCount => _totalImageCount;
  int get pageableCount => _pageableCount;
  int get pageIndex => _pageIndex;
  bool get isEndPage => _isEnd;
  bool get isLoading => _isLoading;
  bool get isNoItem => _isNoItem;
  String get searchWord => _searchWord;
  double get scrollOffset => _scrollOffset;

  Future getImages(String searchWord) async {
    // 검색어가 비어 있을 경우: 상태값을 초기화한다.
    if (searchWord.isEmpty) {
      initialVariables();
      update();
      return;
    }

    if (_isEnd) {
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
      }

      debugPrint("ImageController.getImages() _totalImageCount $_totalImageCount _pageIndex $_pageIndex");
    }

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
  }
}
