import 'package:get/get.dart';

import '../models/image_item.dart';
import '../repository/favorite_repository.dart';

class FavoriteController extends GetxController {
  bool _isLoading = false;
  List<ImageItem> _favoriteImageList = [];
  double _scrollOffset = 0;
  List<ArrangedImageItem> _arrangedItemList = [];

  List<ImageItem> get favoriteImageList => _favoriteImageList;
  bool get isLoading => _isLoading;
  double get scrollOffset => _scrollOffset;
  List<ArrangedImageItem> get arrangedItemList => _arrangedItemList;

  @override
  void onInit() {
    super.onInit();

    _isLoading = false;
    _favoriteImageList = [];
    loadFavoriteImages();
  }

  Future loadFavoriteImages() async {
    _isLoading = true;
    update();

    _favoriteImageList = FavoriteRepository().getFavoriteImageList();
    makeArrangedItemList();

    _isLoading = false;
    update();
  }

  void addFavorite(ImageItem item) {
    FavoriteRepository().addFavorite(item);
    _favoriteImageList.add(item);
    makeArrangedItemList();
    update();
  }

  void deleteFavorite(String hashKey) {
    FavoriteRepository().deleteFavorite(hashKey);

    for (int i = 0; i < _favoriteImageList.length; i++) {
      if (_favoriteImageList[i].hashKey == hashKey) {
        _favoriteImageList.removeAt(i);
        break;
      }
    }

    makeArrangedItemList();
    update();
  }

  bool isFavoriteItem(String hashKey) {
    return FavoriteRepository().isFavoriteItem(hashKey);
  }

  void setScrollOffset(double offset) {
    _scrollOffset = offset;
  }

  void makeArrangedItemList() {
    // debugPrint("makeArrangedItemList() start");

    double screenWidth = Get.width;
    int imageIndex = 0;
    _arrangedItemList = [];

    const double minImageHeight = 100;
    const double maxImageHeight = 300;
    const double fixedImageHeight = 300;

    while (imageIndex < _favoriteImageList.length) {
      int image1stWidth = _favoriteImageList[imageIndex].width;
      int image1stHeight = _favoriteImageList[imageIndex].height;

      if (image1stWidth > image1stHeight) {
        double calcImageHeight = (image1stHeight * (screenWidth - 8)) / image1stWidth;
        if (calcImageHeight >= minImageHeight && calcImageHeight <= maxImageHeight) {
          List<ImageItem> imageItems = [];
          imageItems.add(_favoriteImageList[imageIndex]);
          _arrangedItemList.add(ArrangedImageItem(isFilled: true, imageHeight: calcImageHeight, items: imageItems));

          imageIndex++;
          continue;
        }
      }

      if (imageIndex + 1 >= _favoriteImageList.length) {
        List<ImageItem> imageItems = [];
        imageItems.add(_favoriteImageList[imageIndex]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: false, imageHeight: fixedImageHeight, items: imageItems));
        break;
      }

      int image2ndWidth = _favoriteImageList[imageIndex + 1].width;
      int image2ndHeight = _favoriteImageList[imageIndex + 1].height;

      double calcImage2ndWidth = (image1stHeight * image2ndWidth) / image2ndHeight;
      double calcImageHeight = (image1stHeight * (screenWidth - 16)) / (image1stWidth + calcImage2ndWidth);

      if (calcImageHeight >= minImageHeight && calcImageHeight <= maxImageHeight) {
        List<ImageItem> imageItems = [];
        imageItems.add(_favoriteImageList[imageIndex]);
        imageItems.add(_favoriteImageList[imageIndex + 1]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: true, imageHeight: calcImageHeight, items: imageItems));
        imageIndex += 2;
        continue;
      }

      if (imageIndex + 2 >= _favoriteImageList.length) {
        List<ImageItem> imageItems = [];
        imageItems.add(_favoriteImageList[imageIndex]);
        imageItems.add(_favoriteImageList[imageIndex + 1]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: false, imageHeight: fixedImageHeight, items: imageItems));
        break;
      }

      int image3rdWidth = _favoriteImageList[imageIndex + 2].width;
      int image3rdHeight = _favoriteImageList[imageIndex + 2].height;

      calcImage2ndWidth = (image1stHeight * image2ndWidth) / image2ndHeight;
      double calcImage3rdWidth = (image1stHeight * image3rdWidth) / image3rdHeight;
      calcImageHeight = (image1stHeight * (screenWidth - 24)) / (image1stWidth + calcImage2ndWidth + calcImage3rdWidth);

      if (calcImageHeight >= minImageHeight && calcImageHeight <= maxImageHeight) {
        List<ImageItem> imageItems = [];
        imageItems.add(_favoriteImageList[imageIndex]);
        imageItems.add(_favoriteImageList[imageIndex + 1]);
        imageItems.add(_favoriteImageList[imageIndex + 2]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: true, imageHeight: calcImageHeight, items: imageItems));
        imageIndex += 3;
        continue;
      }

      if (imageIndex + 3 >= _favoriteImageList.length) {
        List<ImageItem> imageItems = [];
        imageItems.add(_favoriteImageList[imageIndex]);
        imageItems.add(_favoriteImageList[imageIndex + 1]);
        imageItems.add(_favoriteImageList[imageIndex + 2]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: false, imageHeight: fixedImageHeight, items: imageItems));
        break;
      }

      int image4thWidth = _favoriteImageList[imageIndex + 3].width;
      int image4thHeight = _favoriteImageList[imageIndex + 3].height;

      calcImage2ndWidth = (image1stHeight * image2ndWidth) / image2ndHeight;
      calcImage3rdWidth = (image1stHeight * image3rdWidth) / image3rdHeight;
      double calcImage4thWidth = (image1stHeight * image4thWidth) / image4thHeight;
      calcImageHeight = (image1stHeight * (screenWidth - 32)) /
          (image1stWidth + calcImage2ndWidth + calcImage3rdWidth + calcImage4thWidth);

      if (calcImageHeight >= minImageHeight && calcImageHeight <= maxImageHeight) {
        List<ImageItem> imageItems = [];
        imageItems.add(_favoriteImageList[imageIndex]);
        imageItems.add(_favoriteImageList[imageIndex + 1]);
        imageItems.add(_favoriteImageList[imageIndex + 2]);
        imageItems.add(_favoriteImageList[imageIndex + 3]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: true, imageHeight: calcImageHeight, items: imageItems));

        imageIndex += 4;
        continue;
      }

      if (imageIndex + 4 >= _favoriteImageList.length) {
        List<ImageItem> imageItems = [];
        imageItems.add(_favoriteImageList[imageIndex]);
        imageItems.add(_favoriteImageList[imageIndex + 1]);
        imageItems.add(_favoriteImageList[imageIndex + 2]);
        imageItems.add(_favoriteImageList[imageIndex + 3]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: false, imageHeight: fixedImageHeight, items: imageItems));
        break;
      }

      int image5thWidth = _favoriteImageList[imageIndex + 4].width;
      int image5thHeight = _favoriteImageList[imageIndex + 4].height;

      calcImage2ndWidth = (image1stHeight * image2ndWidth) / image2ndHeight;
      calcImage3rdWidth = (image1stHeight * image3rdWidth) / image3rdHeight;
      calcImage4thWidth = (image1stHeight * image4thWidth) / image4thHeight;
      double calcImage5thWidth = (image1stHeight * image5thWidth) / image5thHeight;

      calcImageHeight = (image1stHeight * (screenWidth - 40)) /
          (image1stWidth + calcImage2ndWidth + calcImage3rdWidth + calcImage4thWidth + calcImage5thWidth);

      if (calcImageHeight >= minImageHeight && calcImageHeight <= maxImageHeight) {
        List<ImageItem> imageItems = [];
        imageItems.add(_favoriteImageList[imageIndex]);
        imageItems.add(_favoriteImageList[imageIndex + 1]);
        imageItems.add(_favoriteImageList[imageIndex + 2]);
        imageItems.add(_favoriteImageList[imageIndex + 3]);
        imageItems.add(_favoriteImageList[imageIndex + 4]);
        _arrangedItemList.add(ArrangedImageItem(isFilled: true, imageHeight: calcImageHeight, items: imageItems));
        imageIndex += 5;
        continue;
      }

      List<ImageItem> imageItems = [];
      imageItems.add(_favoriteImageList[imageIndex]);

      calcImageHeight = (image1stHeight * (screenWidth - 8)) / image1stWidth;

      _arrangedItemList.add(ArrangedImageItem(isFilled: true, imageHeight: calcImageHeight, items: imageItems));

      imageIndex++;
      continue;
    }
    // debugPrint("makeArrangedItemList() end");
  }
}
