class GalleryItem {
  GalleryItem(id, image) {
    this._id = id;
    this._image = image;
  }

  int _id;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String _image;

  String get image => _image;

  set image(String value) {
    _image = value;
  }
}
