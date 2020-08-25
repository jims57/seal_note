import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/GalleryItem.dart';
import 'dart:async';

class PhotoViewWidget extends StatefulWidget {
  PhotoViewWidget({Key key, @required this.firstImageIndex = 0})
      : super(key: key);

  final int firstImageIndex;

  @override
  _PhotoViewWidgetState createState() => _PhotoViewWidgetState();
}

class _PhotoViewWidgetState extends State<PhotoViewWidget> {
  int _currentImageNo = 1;
  int _imageTotalCount = 1;
  bool _showToolBar = true;
  int _firstImageIndex = 0;
  bool _updateFirstImageIndex = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentImageNo = widget.firstImageIndex + 1;

    _updateFirstImageIndex = true;
  }

  @override
  Widget build(BuildContext context) {
    _imageTotalCount = GlobalState.imageDataList.length;
    if (_updateFirstImageIndex) _firstImageIndex = widget.firstImageIndex;

    PageController _pageController =
        PageController(initialPage: _firstImageIndex);

//    var _timer = new Timer(const Duration(seconds: 5), () {
//      setState(() {
////        title = '[updated]';
////        _firstImageIndex = 1;
////        _updateFirstImageIndex = false;
////        _currentImageNo = _firstImageIndex+1;
//        GlobalState.imageDataList[0] = GlobalState.tempImageDataList[0];
//        GlobalState.imageDataList[1] = GlobalState.tempImageDataList[1];
//      });
//    });

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
              child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: MemoryImage(GlobalState.imageDataList[index]),
                initialScale: PhotoViewComputedScale.contained * 1,

//                imageProvider: AssetImage("assets/appImages/loading.gif"),
//                initialScale: PhotoViewComputedScale.contained * 0.2,
                heroAttributes: PhotoViewHeroAttributes(tag: index),
              );
            },
            itemCount: GlobalState.imageDataList.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ),
            enableRotation: false,
            onPageChanged: (newPageIndex) {
              setState(() {
                _currentImageNo = newPageIndex + 1;
              });
            },
            backgroundDecoration: BoxDecoration(color: Colors.black),
            pageController: _pageController,
            loadFailedChild: Text('No image'),
          )),
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

  void sortImageSyncItemListByAsc() {
    GlobalState.imageSyncItemList
        .sort((a, b) => a.imageIndex.compareTo(b.imageIndex));
  }
}
