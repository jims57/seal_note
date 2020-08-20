import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/GalleryItem.dart';

class PhotoViewWidget extends StatefulWidget {
  PhotoViewWidget({Key key, @required this.firstPageIndex = 0})
      : super(key: key);

  final int firstPageIndex;

  @override
  _PhotoViewWidgetState createState() => _PhotoViewWidgetState();
}

class _PhotoViewWidgetState extends State<PhotoViewWidget> {
  int _currentImageNo = 1;
  int _imageTotalCount = 1;
  bool _showToolBar = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentImageNo = widget.firstPageIndex+1;
  }

  @override
  Widget build(BuildContext context) {
    _imageTotalCount = GlobalState.imageDataList.length;

    PageController _pageController = PageController(initialPage: widget.firstPageIndex);

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
                heroAttributes:
                    PhotoViewHeroAttributes(tag: index),
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
}
