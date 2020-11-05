import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/model/ImageSyncItem.dart';
import 'package:seal_note/model/NoteWithProgressTotal.dart';
import 'package:seal_note/ui/FolderListPage.dart';
import 'package:seal_note/ui/FolderListWidget.dart';
import 'package:seal_note/ui/MasterDetailPage.dart';
import 'package:seal_note/ui/NoteListWidgetForToday.dart';
import 'package:seal_note/ui/common/AppBarWidget.dart';

import 'AppState.dart';
import 'DetailPageState.dart';
import 'SelectedNoteModel.dart';

class GlobalState with ChangeNotifier {
  static final GlobalState _singleton = GlobalState._internal();

  factory GlobalState() => _singleton;

  GlobalState._internal();

  // db // database
  static String dbNameForMobilePlatform = 'sealMobile.sqlite';

  // Colors
  static const Color themeBlackColor = Color(0xff000000);
  static const Color themeBlackColorForFont = Color(0xff000000);
  static const Color themeBlueColor = Color(0xff2b98f0);
  static const Color themeGreenColorAtiOSTodo = Color(0xff67d844);
  static const Color themeLightBlueColor07 = Color.fromRGBO(43, 152, 240, 0.7);
  static const Color themeLightBlueColor02 = Color.fromRGBO(43, 152, 240, 0.2);
  static const Color themeGreyColor = Color(0xffecedee);
  static const Color themeGreyColorAtiOSTodo = Color(0xffbbbbc0);
  static const Color themeGreyColorAtiOSTodoForFolderGroupBackground =
      Color(0xff898a8e);
  static const Color themeGreyColorAtiOSTodoForBackground = Color(0xfff1f2f6);
  static Color themeGrey350Color = Colors.grey[350];
  static const Color themeGreyColorAtiOSTodoForBlockIconBackground =
      Color(0xff8e8e93);
  static const Color themeWhiteColorAtiOSTodo = Color(0xffffffff);
  static const Color themeBlackColor87ForFontForeColor = Colors.black87;
  static const Color themeOrangeColorAtiOSTodo = Color(0xfffa9426);
  static const Color themeBrownColorAtiOSTodo = Color(0xff9a8565);
  static const Color themeLightBlueColorAtiOSTodo = Color(0xff2aaff5);

  // Borders
  static double borderRadius15 = 15.0;
  static double borderRadius40 = 40.0;

  // Database
  static Database database;

  // Device basic info
  static int
      screenType; // 1 = small screen, 2 = medium screen, 3 = large screen
  static double screenWidth;
  static double screenHeight;
  static double appBarHeight;
  static double webViewHeight;
  static int rotatedTimes;

  // Keyboard related
  static double keyboardHeight = 0.0;
  static bool isKeyboardEventHandling = false;

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

  // Title String
  static final String defaultFolderNameForToday = '今天';
  static final String defaultFolderNameForAllNotes = '全部笔记';
  static final String defaultFolderNameForDeletion = '删除笔记';
  static final String defaultUserFolderNameForMyNotes = '我的笔记';
  static final String titleForReviewFinished = '复习完成';

  // Pages' width
  // Note: The following default values for the width are as far as large screen(screenType = 3) is concerned
  static final double folderPageDefaultWidth = 250.0;
  static double currentFolderPageWidth = 250.0;
  static final double noteListPageDefaultWidth = 270.0;
  static double currentNoteListPageWidth = 270.0;
  static final double noteDetailPageDefaultWidth = 200.0;
  static double currentNoteDetailPageWidth = 200.0;

  // Contexts
  static BuildContext myAppContext;
  static BuildContext masterDetailPageContext;
  static BuildContext noteListPageContext;
  static BuildContext folderOptionItemListPanelContext;
  static BuildContext noteDetailWidgetContext;
  static BuildContext myWebViewPluginContext;

  // Selected note related
  static NoteWithProgressTotal
      selectedNoteModel; // When the user clicks on the note list item, we store the note model to this variable for the sake of future usage to update these values shown on the note list
  static bool isDefaultFolderSelected = false; // For default folder
  static bool isReviewFolderSelected = false; // For review folder
  static int defaultFolderId =
      3; // The default folder id to be used when user creates a note from default folders.
  static int selectedFolderId =
      defaultFolderId; // The current selected folder id the user clicks on folder list page
  // static int folderIdNoteBelongsTo =
  //     defaultFolderId; // This is the folder id the note belongs to, note that it isn't the same folder id as the selected folder id if the user is clicking a note from a default folder, i.e. Today folder
  static String selectedFolderName = defaultUserFolderNameForMyNotes;
  // static int selectedNoteId =
  //     0; // If the selected note id ==0 , meaning it is a new note
  static String
      oldNoteContentEncoded; // The old note content which is saved in db currently
  static String
      newNoteContentEncoded; // The new note content which is encoded, and is going to be saved to db

  static SelectedNoteModel noteModelForConsumer;

  // State objects
  static GlobalKey<MasterDetailPageState> masterDetailPageState;
  static GlobalKey<AppBarWidgetState> appBarWidgetState;
  static GlobalKey<FolderListPageState> folderListPageState;
  static GlobalKey<FolderListWidgetState> folderListWidgetState;
  static GlobalKey<NoteListWidgetForTodayState> noteListWidgetForTodayState;

  // Overlay
  static OverlayEntry overlayEntry;

  // Change Notifier
  static AppState appState;
  static DetailPageChangeNotifier detailPageChangeNotifier;

  // Folder page
  static double folderPageTopContainerHeight = 40.0;
  static double folderPageBottomContainerHeight = 40.0;
  static double folderListItemHeight = 60.0;
  static bool shouldReorderFolderListItem = false;
  static bool isPointerDown = false;
  static bool isPointerMoving = false;
  static bool isAfterLongPress = false;
  static bool shouldMakeDefaultFoldersGrey = false;
  static bool isFolderListPageLoaded =
      false; // Indicate if the folder list page is loaded

  // Folder total
  static int userFolderTotal = 0;
  static int allFolderTotal = 0; // All folder including default folders

  // Default folders
  static List<int> defaultFolderIndexList = List<int>();

  // Folder Options
  static double folderOptionItemHeight = 40.0;

  // User info
  static final int adminUserId = 1;
  static int currentUserId = 1;

  // User folder available dy
  static double userFolderListItemMinAvailableDy = double.negativeInfinity;
  static double userFolderListItemMaxAvailableDy = double.infinity;

  // WebView
  static String htmlString = '';
  static bool isClickingNoteListItem = false;
  static bool hasWebViewLoaded = false; // Check if the WebView is loaded or not
  static bool isInNoteDetailPageInsideScreenType1 = false;
  static FlutterWebviewPlugin flutterWebviewPlugin;
  static WebviewScaffold webViewScaffold;
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
