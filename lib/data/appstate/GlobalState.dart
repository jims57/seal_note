import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/model/ImageSyncItem.dart';
import 'package:seal_note/ui/MasterDetailPage.dart';

import 'AppState.dart';
import 'DetailPageState.dart';
import 'SelectedNoteModel.dart';

class GlobalState with ChangeNotifier {
  static final GlobalState _singleton = GlobalState._internal();

  factory GlobalState() => _singleton;

  GlobalState._internal();

  // Theme
  static Color themeColor;

  // Database
  static Database database;

  // Device basic info
  static int
      screenType; // 1 = small screen, 2 = medium screen, 3 = large screen
  static double screenWidth;
  static double screenHeight;

  // Pages
  static final double folderPageDefaultFromDx = -1.0;
  static final double folderPageDefaultToDx = -1.0;
  static bool isHandlingFolderPage = false;
  static bool isInFolderPage = false;

  static final double noteDetailPageDefaultFromDx = 1.0;
  static final double noteDetailPageDefaultToDx = 1.0;
  static bool isInNoteDetailPage = false;
  static bool isHandlingNoteDetailPage = false;

  static bool shouldTriggerPageTransitionAnimation = true;
  static const int pageTransitionAnimationDurationMilliseconds = 200;

  // Pages' width
  // Note: The following default values for the width are as far as large screen(screenType = 3) is concerned
  static final double folderPageDefaultWidth = 250.0;
  static final double noteListPageDefaultWidth = 270.0;
  static final double noteDetailPageDefaultWidth = 200.0;

  // Contexts
  static BuildContext myAppContext;
  static BuildContext masterDetailPageContext;
  static BuildContext noteListPageContext;
  static BuildContext folderOptionItemListPanelContext;

//  static BuildContext noteDetailPageContext;
  static BuildContext noteDetailWidgetContext;
  static BuildContext myWebViewPluginContext;

  // Models
  static SelectedNoteModel selectedNoteModel;

  // State objects
  static GlobalKey<MasterDetailPageState> masterDetailPageState;

  // Change Notifier
  static AppState appState;
  static DetailPageChangeNotifier detailPageChangeNotifier;

  // Folder Options
  static double folderOptionItemHeight = 40.0;

  // WebView
  static String htmlString = '';
  static bool isClickingNoteListItem = false;

  // static bool isInDetailPage = false;

  // TODO: Testing
  static String htmlString2 = '<div>jims57</div>';
  static int rotationCounter = 0;
  static bool isInNoteDetailPageInsideScreenType1 = false;
  static FlutterWebviewPlugin flutterWebviewPlugin;

  // static FlutterWebviewPlugin flutterWebviewPlugin2;
  static WebviewScaffold webViewScaffold;

  // static WebviewScaffold webViewScaffold2;
  static bool needRefreshWebView = false;

  // Quill editor
  static bool isQuillReadOnly = true;
  static bool isCreatingNote =
      false; // Indicating if the user is creating a new note

  // Photo Views
  static List<ImageSyncItem> imageSyncItemList = List<ImageSyncItem>();

  // Testing
  static String imageId;
}
