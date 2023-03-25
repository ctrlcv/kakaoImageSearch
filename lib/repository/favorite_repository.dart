import 'package:hive/hive.dart';

import '../models/image_item.dart';

class FavoriteRepository {
  final _hiveBox = Hive.box<ImageItem>('favorite');

  List<ImageItem> getFavoriteImageList() {
    List<ImageItem> result = [];

    for (int i = 0; i < _hiveBox.length; i++) {
      if (_hiveBox.getAt(i) == null) {
        continue;
      }
      result.add(_hiveBox.getAt(i)!);
    }

    return result;
  }

  void addFavorite(ImageItem item) {
    _hiveBox.put(item.hashKey, item);
  }

  void deleteFavorite(String hashKey) {
    _hiveBox.delete(hashKey);
  }

  bool isFavoriteItem(String hashKey) {
    ImageItem? favoriteItem = _hiveBox.get(hashKey);
    return (favoriteItem != null);
  }
}
