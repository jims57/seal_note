class ImageSyncItem {
  String imageId;
  int imageIndex;
  String base64 = '';
  int syncId;

  ImageSyncItem(this.imageId, this.imageIndex, this.base64, this.syncId);

  factory ImageSyncItem.fromJson(dynamic json) {
    return ImageSyncItem(json['imageId'] as String, json['imageIndex'] as int,json['base64'] as String, json['syncId'] as int);
  }

  @override
  String toString() {
    return '{ ${this.imageId}, ${this.imageIndex}, ${this.base64}, ${this.syncId} }';
  }
}
