import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/download/DownloadHandler.dart';
import 'package:seal_note/util/enums/EnumHandler.dart';
import 'package:seal_note/util/file/FileHandler.dart';
import 'package:seal_note/util/images/ImageHandler.dart';

class PhotoViewWidget extends StatefulWidget {
  @override
  _PhotoViewWidgetState createState() => _PhotoViewWidgetState();
}

class _PhotoViewWidgetState extends State<PhotoViewWidget> {
  int _firstImageIndex = 0;
  int _currentImageNo = 1;
  int _imageTotalCount = 1;
  bool _showToolBar = true;
  PageController _pageController;
  double _photoViewScale = 1;

  @override
  void initState() {
    super.initState();

    _initPhotoView();
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
                      imageProvider: _showImageForPhotoView(index),
                      initialScale: _setInitialScale(index),
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
                      _checkAndGetCurrentImageUint8List(newImageIndex);
                      _currentImageNo = newImageIndex + 1;
                    });
                  },
                  backgroundDecoration: BoxDecoration(color: Colors.black),
                  pageController: _pageController,
                  // loadFailedChild: Text('No image'),
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              // height: 56,
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    width: 100,
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    width: 100,
                    child: Text(
                      '$_currentImageNo/$_imageTotalCount',
                      style: TextStyle(
                          color: (_showToolBar
                              ? Colors.white
                              : Colors.transparent),
                          fontSize: 18),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      width: 100,
                      child: Text(
                        // photo view finish button
                        '完成',
                        style: TextStyle(
                            color: (_showToolBar
                                ? Colors.white
                                : Colors.transparent),
                            fontSize: 18),
                      ),
                    ),
                    onTap: () {
                      // photo view finish button event

                      setState(() {
                        GlobalState.noteDetailWidgetState.currentState
                            .showWebView();

                        GlobalState.appState.widgetNo = 2;

                        GlobalState.shouldTriggerPageTransitionAnimation =
                            false;
                        // GlobalState.masterDetailPageState.currentState.updatePageShowAndHide(shouldTriggerSetState: false, hasAnimation: false);

                        Navigator.pop(GlobalState.noteDetailWidgetContext);
                      });
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Private methods
  void _initPhotoView() {
    _firstImageIndex = GlobalState.appState.firstImageIndex;
    _currentImageNo = _firstImageIndex + 1;

    _imageTotalCount = GlobalState.imageSyncItemList.length;

    _pageController = PageController(initialPage: _firstImageIndex);

    _sortImageSyncItemListByAsc();

    _checkAndGetCurrentImageUint8List(_firstImageIndex);
  }

  ImageProvider<Object> _showImageForPhotoView(index) {
    var _currentImageSyncItem = GlobalState.imageSyncItemList[index];

    if (_currentImageSyncItem.byteData == null) {
      return AssetImage("assets/appImages/loading.gif");
    } else {
      return MemoryImage(_currentImageSyncItem.byteData);
    }
  }

  dynamic _setInitialScale(index) {
    var _currentImageSyncItem = GlobalState.imageSyncItemList[index];

    if (_currentImageSyncItem.byteData == null) {
      return PhotoViewComputedScale.contained * _photoViewScale;
    } else {
      return PhotoViewComputedScale.contained * _photoViewScale;
    }
  }

  void _sortImageSyncItemListByAsc() {
    GlobalState.imageSyncItemList
        .sort((a, b) => a.imageIndex.compareTo(b.imageIndex));
  }

  void _checkAndGetCurrentImageUint8List(newImageIndex) {
    if (GlobalState.imageSyncItemList[newImageIndex].byteData == null) {
      var imageSyncItem = GlobalState.imageSyncItemList[newImageIndex];
      var imageId = imageSyncItem.imageId;
      var imageSrc = imageSyncItem.imageSrc;

      // Get the image Uint8List from file directly
      var imageMd5FileName = ImageHandler.getImageMd5FileNameByImageId(imageId);

      // If imageSrc is null, it is the image which should be at Document Directory or TCB Storage
      // notice: if imageSrc isn't null, it is http image from Internet
      if (imageSrc == null) {
        // When it is the image at Document Directory or TCB Storage

        FileHandler
            .getFileUint8ListFromDocumentDirectoryByFileNameWithoutExtension(
          fileNameWithoutExtension: imageMd5FileName,
        ).then((imageUint8List) {
          _loadImageUint8ListAndRefreshPhotoView(
            imageIndex: newImageIndex,
            imageUint8ListToBeShown: imageUint8List,
          );
        });
      } else {
        // When it is the http image from Internet

        // photo view load http image // photo view show http image
        // show http image // zoom in http image

        // Check if the http image is already at Document Directory
        FileHandler
                .getFileUint8ListFromDocumentDirectoryByFileNameWithoutExtension(
                    fileNameWithoutExtension: imageMd5FileName)
            .then((imageUint8ListFromDocumentDirectory) {
          var imageUint8List;

          // Check if the image is already at Document Directory or not
          if (imageUint8ListFromDocumentDirectory == null) {
            // When the image isn't at Document Directory

            // Download the image by its url to Document Directory
            var imageUrl = imageSrc;
            var imageExtension;

            // Set the right extension for the image.
            // Note: we just need to handle the special extension, such as .png and gif,
            // which have their way to show, like dynamic or transparent image
            var imageExtensionAtImageUrl =
                imageUrl.substring(imageUrl.length - 4);
            switch (imageExtensionAtImageUrl) {
              case '.gif':
                {
                  imageExtension = 'gif';
                }
                break;
              case '.png':
                {
                  imageExtension = 'png';
                }
                break;
              default:
                {
                  imageExtension = 'jpg';
                }
                break;
            }

            DownloadHandler.downloadFileByUrlToDocumentDirectory(
              url: imageUrl,
              extensionName: imageExtension,
              forceToReplaceHttpToHttps: false,
            ).then((downloadedFileModel) {
              if (downloadedFileModel != null) {
                imageUint8List = downloadedFileModel.fileUint8List;

                _loadImageUint8ListAndRefreshPhotoView(
                  imageIndex: newImageIndex,
                  imageUint8ListToBeShown: imageUint8List,
                );
              } else {
                // When downloaded object is null

                // Do nothing currently
              }
            });
          } else {
            // When the image is at Document Directory

            imageUint8List = imageUint8ListFromDocumentDirectory;

            _loadImageUint8ListAndRefreshPhotoView(
              imageIndex: newImageIndex,
              imageUint8ListToBeShown: imageUint8List,
            );
          }
        });

        var s = 's';
      }
    }
  }

  void _loadImageUint8ListAndRefreshPhotoView({
    @required int imageIndex,
    @required Uint8List imageUint8ListToBeShown,
  }) {
    GlobalState.imageSyncItemList[imageIndex].byteData =
        imageUint8ListToBeShown;

    new Timer(const Duration(milliseconds: 500), () {
      GlobalState.appState.firstImageIndex =
          GlobalState.appState.firstImageIndex;
    });
  }
}
