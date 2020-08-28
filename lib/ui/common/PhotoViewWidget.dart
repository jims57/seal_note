import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
// import 'package:flutter/services.dart' show rootBundle;

class PhotoViewWidget extends StatefulWidget {
  @override
  _PhotoViewWidgetState createState() => _PhotoViewWidgetState();
}

class _PhotoViewWidgetState extends State<PhotoViewWidget> {
  String _firstImageId;
  int _firstImageIndex = 0;
  int _currentImageNo = 1;
  int _imageTotalCount = 1;
  bool _showToolBar = true;
  PageController _pageController;
  double _photoViewScale = 1;

  @override
  void initState() {
    super.initState();

    initPhotoView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            child: Consumer<AppState>(
              builder: (ctx, appState, child) {
                return PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: showImageForPhotView(index),
                      initialScale: setInitialScale(index),
                      heroAttributes: PhotoViewHeroAttributes(tag: index),
                    );
                  },
                  itemCount: _imageTotalCount,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  enableRotation: false,
                  onPageChanged: (newImageIndex) {
                    setState(() {
                      if (GlobalState
                              .imageSyncItemList[newImageIndex].byteData ==
                          null) {
                        var imageId = GlobalState
                            .imageSyncItemList[newImageIndex].imageId;

                        getBase64ByImageId(imageId);
                      }

                      _currentImageNo = newImageIndex + 1;
                    });
                  },
                  backgroundDecoration: BoxDecoration(color: Colors.black),
                  pageController: _pageController,
                  loadFailedChild: Text('No image'),
                );
              },
            ),
          ),
          Container(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.transparent,
                  width: 100,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  color: Colors.transparent,
                  width: 50,
                  child: Text(
                    '$_currentImageNo/$_imageTotalCount',
                    style: TextStyle(
                        color:
                            (_showToolBar ? Colors.white : Colors.transparent),
                        fontSize: 18),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    color: Colors.transparent,
                    width: 100,
                    child: Text(
                      '完成',
                      style: TextStyle(
                          color: (_showToolBar
                              ? Colors.white
                              : Colors.transparent),
                          fontSize: 18),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _currentImageNo = 3;

                      GlobalState.appState.widgetNo = 2;

                      Navigator.pop(GlobalState.noteDetailWidgetContext);

                      GlobalState.flutterWebviewPlugin.show();
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void initPhotoView() {
    _firstImageIndex = GlobalState.appState.firstImageIndex;
    _firstImageId = GlobalState.imageSyncItemList[_firstImageIndex].imageId;
    _currentImageNo = _firstImageIndex + 1;

    _imageTotalCount = GlobalState.imageSyncItemList.length;

    _pageController = PageController(initialPage: _firstImageIndex);

    sortImageSyncItemListByAsc();

    // Check if
    if (GlobalState.imageSyncItemList[_firstImageIndex].byteData == null) {
      getBase64ByImageId(_firstImageId);
    }
  }

  ImageProvider<Object> showImageForPhotView(index) {
    var _currentImageSyncItem = GlobalState.imageSyncItemList[index];

    if (_currentImageSyncItem.byteData == null) {
      return AssetImage("assets/appImages/loading.gif");
      // return MemoryImage();
      // await loadMemoryImage();

      // return MemoryImage(_currentImageSyncItem.byteData);
      // var imageAsset =  Image.asset(
      //   'assets/appImages/loading.gif',
      //   // scale: 2,
      //   width: 50,
      //   height: 50,
      //   // fit: BoxFit.cover,
      // );
      // return imageAsset.image;

    } else {
      return MemoryImage(_currentImageSyncItem.byteData);
    }
  }

  // Future<MemoryImage> loadMemoryImage() async{
  //   rootBundle.load('assets/appImages/loading.gif').then((value) {
  //     var uint8Value = value.buffer.asUint8List();
  //     MemoryImage(uint8Value);
  //   });
  // }

  dynamic setInitialScale(index) {
    var _currentImageSyncItem = GlobalState.imageSyncItemList[index];

    if (_currentImageSyncItem.byteData == null) {
      return PhotoViewComputedScale.contained * _photoViewScale;
    } else {
      return PhotoViewComputedScale.contained * _photoViewScale;
    }
  }

  void sortImageSyncItemListByAsc() {
    GlobalState.imageSyncItemList
        .sort((a, b) => a.imageIndex.compareTo(b.imageIndex));
  }

  void getBase64ByImageId(imageId) {
    GlobalState.flutterWebviewPlugin
        .evalJavascript("javascript:getBase64ByImageId('$imageId', true);");
  }
}
