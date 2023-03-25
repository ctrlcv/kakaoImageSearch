import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';

part 'image_item.g.dart';

@HiveType(typeId: 0)
class ImageItem {
  @HiveField(0)
  String hashKey;

  @HiveField(1)
  String collections;

  @HiveField(2)
  String thumbnailUrl;

  @HiveField(3)
  String imageUrl;

  @HiveField(4)
  int width;

  @HiveField(5)
  int height;

  @HiveField(6)
  String displaySiteName;

  @HiveField(7)
  String docUrl;

  ImageItem({
    required this.hashKey,
    required this.collections,
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.displaySiteName,
    required this.docUrl,
  });

  @override
  String toString() {
    return 'ImageItem{hashKey: $hashKey, collections: $collections, thumbnailUrl: $thumbnailUrl, imageUrl: $imageUrl, width: $width, height: $height, displaySiteName: $displaySiteName, docUrl: $docUrl}';
  }

  factory ImageItem.fromJson(Map<String, dynamic> parsedJson) {
    String thumbnailUrl = parsedJson['thumbnail_url'] ?? "";
    List<int> bytes = utf8.encode(thumbnailUrl);
    List<int> hash = sha256.convert(bytes).bytes;
    List<int> uniqueBytes = hash.sublist(0, 8);
    String uniqueValue = base64Url.encode(uniqueBytes);

    return ImageItem(
      hashKey: uniqueValue,
      collections: parsedJson['collection'] ?? "",
      thumbnailUrl: thumbnailUrl,
      imageUrl: parsedJson['image_url'] ?? "",
      width: parsedJson['width'] ?? 0,
      height: parsedJson['height'] ?? 0,
      displaySiteName: parsedJson['display_sitename'] ?? "",
      docUrl: parsedJson['doc_url'] ?? "",
    );
  }
}

class MetaData {
  int? totalCount;
  int? pageableCount;
  bool? isEnd;

  MetaData({this.totalCount, this.pageableCount, this.isEnd});

  factory MetaData.fromJson(Map<String, dynamic> parsedJson) {
    return MetaData(
      totalCount: parsedJson['total_count'] ?? 0,
      pageableCount: parsedJson['pageable_count'] ?? 0,
      isEnd: parsedJson['is_end'] ?? false,
    );
  }
}

class ImageSearchResponse {
  MetaData? meta;
  List<ImageItem>? documents;

  ImageSearchResponse({this.meta, this.documents});

  factory ImageSearchResponse.fromJson(Map<String, dynamic> parsedJson) {
    MetaData? meta = MetaData.fromJson(parsedJson['meta']);
    List<dynamic> items = parsedJson['documents'];
    List<ImageItem>? documents = items.map((e) => ImageItem.fromJson(e)).toList();

    return ImageSearchResponse(
      meta: meta,
      documents: documents,
    );
  }
}
