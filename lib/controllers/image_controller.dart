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
  String _searchWord = "";
  double _scrollOffset = 0;

  List<ImageItem> get imageList => _imageList;
  int get totalImageCount => _totalImageCount;
  int get pageableCount => _pageableCount;
  int get pageIndex => _pageIndex;
  bool get isEndPage => _isEnd;
  bool get isLoading => _isLoading;
  String get searchWord => _searchWord;
  double get scrollOffset => _scrollOffset;

  Future getImages(String searchWord) async {
    if (searchWord.isEmpty) {
      _totalImageCount = 0;
      _pageableCount = 0;
      _pageIndex = 0;
      _isEnd = false;

      _imageList = [];
      _searchWord = "";
      update();
      return;
    }

    if (_isEnd) {
      return;
    }

    _isLoading = true;
    update();

    if (_searchWord != searchWord) {
      _totalImageCount = 0;
      _pageableCount = 0;
      _pageIndex = 0;
      _isEnd = false;

      _imageList = [];
      _searchWord = searchWord;
    }

    _pageIndex++;

    debugPrint("ImageController.getImages()");

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
    }

    _isLoading = false;
    update();
  }

  void setScrollOffset(double offset) {
    _scrollOffset = offset;
  }
}
