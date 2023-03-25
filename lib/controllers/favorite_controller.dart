import 'package:get/get.dart';

import '../models/image_item.dart';
import '../repository/favorite_repository.dart';

class FavoriteController extends GetxController {
  bool _isLoading = false;
  List<ImageItem> _favoriteImageList = [];

  List<ImageItem> get favoriteImageList => _favoriteImageList;
  bool get isLoading => _isLoading;

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

    _isLoading = false;
    update();
  }

  void addFavorite(ImageItem item) {
    FavoriteRepository().addFavorite(item);
    _favoriteImageList.add(item);
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
    update();
  }

  bool isFavoriteItem(String hashKey) {
    return FavoriteRepository().isFavoriteItem(hashKey);
  }
}
