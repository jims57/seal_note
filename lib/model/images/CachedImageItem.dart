import 'package:moor/moor.dart';

class CachedImageItem {
  String imageMd5FileName;
  Uint8List imageUint8List;

  CachedImageItem({@required this.imageMd5FileName, this.imageUint8List});
}
