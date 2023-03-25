// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageItemAdapter extends TypeAdapter<ImageItem> {
  @override
  final int typeId = 0;

  @override
  ImageItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageItem(
      hashKey: fields[0] as String,
      collections: fields[1] as String,
      thumbnailUrl: fields[2] as String,
      imageUrl: fields[3] as String,
      width: fields[4] as int,
      height: fields[5] as int,
      displaySiteName: fields[6] as String,
      docUrl: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ImageItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.hashKey)
      ..writeByte(1)
      ..write(obj.collections)
      ..writeByte(2)
      ..write(obj.thumbnailUrl)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.width)
      ..writeByte(5)
      ..write(obj.height)
      ..writeByte(6)
      ..write(obj.displaySiteName)
      ..writeByte(7)
      ..write(obj.docUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
