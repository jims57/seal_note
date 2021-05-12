import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:seal_note/data/appstate/LoadingWidgetChangeNotifier.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/event/webView/WebViewLoadedEventHandler.dart';
import 'package:seal_note/model/ImageSyncItem.dart';
import 'package:seal_note/model/NoteWithProgressTotal.dart';
import 'package:seal_note/model/ReusablePage/ReusablePageModel.dart';
import 'package:seal_note/model/tcbModels/TCBSystemInfoModel.dart';
import 'package:seal_note/ui/FolderListPage.dart';
import 'package:seal_note/ui/FolderListWidget.dart';
import 'package:seal_note/ui/MasterDetailPage.dart';
import 'package:seal_note/ui/NoteDetailWidget.dart';
import 'package:seal_note/ui/NoteListWidgetForToday.dart';
import 'package:seal_note/ui/authentications/LoginPage.dart';
import 'package:seal_note/ui/common/pages/reusablePages/ReusablePageStackWidget.dart';
import 'package:seal_note/ui/common/appBars/AppBarWidget.dart';
import 'package:seal_note/ui/common/SelectFolderWidget.dart';
import 'package:seal_note/ui/reviewPlans/ReviewPlanSecondSubPage.dart';
import 'package:seal_note/ui/reviewPlans/ReviewPlanWidget.dart';
import 'package:seal_note/util/updates/AppUpdateHandler.dart';
import 'package:stack/stack.dart' as stackData show Stack;

import 'AlertDialogHeightChangeNotifier.dart';
import 'AppState.dart';
import 'DetailPageState.dart';
import 'ReusablePageChangeNotifier.dart';
import 'ReusablePageOpenOrCloseNotifier.dart';
import 'ReusablePageWidthChangeNotifier.dart';
import 'SelectedNoteModel.dart';
import 'ViewAgreementPageChangeNotifier.dart';

class GlobalState with ChangeNotifier {
  static final GlobalState _singleton = GlobalState._internal();

  factory GlobalState() => _singleton;

  GlobalState._internal();

  // Variable for deployment // deployment variable
  static double appVersion = 1.0;
  static int systemInfoVersion = 1; // See: systemInfoVersion.json

  // For configuration // app basic info // app basic variable info
  static int noteListTitleMaxLength = 50;
  static int noteListAbstractMaxLength = 50;
  static int incrementalStepToUseRegex = 100;
  static const int minLengthToTriggerRefreshForNoteListPage = 0;
  static String iOSAppId = '1371947588';
  static String androidAppId = 'zcootong.zcoonet.com.gpb';
  static String downloadLinkForIOS =
      'https://itunes.apple.com/cn/app/yuan-zhang-tou-tiao/id$iOSAppId';
  static String downloadLinkForAndroid =
      'http://a.app.qq.com/o/simple.jsp?pkgname=$androidAppId';

  // TCB configuration
  static String tcbEnvironment = 'seal-note-app-env-8ei8de6728d969';
  static String tcbAppAccessKey = 'a20825658ec31142f31c91ee7d18f5ad';
  static String tcbAppAccessVersion = '1';

  // TCB variables
  static CloudBaseCore tcbCloudBaseCore;
  static CloudBaseAuth tcbCloudBaseAuth;
  static CloudBaseAuthState tcbCloudBaseAuthState;
  static CloudBaseDatabase tcbCloudBaseDatabase;
  static Command tcbCommand;
  static String tcbAccessToken;
  static String tcbRefreshToken;
  static CloudBaseUserInfo cloudBaseUserInfo;
  static bool isAnonymousLogin =
      false; // false = Anonymous login, true = WX login

  // WX variables
  static String wxAppId = 'wx559b1bda805a875b';
  static String wxUniLink = 'https://t.zcoo.net/sealsite/';

  // TCB collection data
  static TCBSystemInfoModel tcbSystemInfo;

  // app current info // app status // app status info
  // app info variable
  static bool isAppFirstTimeToLaunch = false;
  static bool isAppInitialized = false;

  // Notice: Before invoke hasLoginTCB() method, isLoggedIn variable will be false.
  // Please make sure to call hasLoginTCB() method, before using isLoggedIn variable to check the user's login status
  static bool isLoggedIn = false;

  static bool shouldShowLoginPage = false;
  static bool hasNetwork = true;
  static bool isReviewApp =
      false; // Tell the current version of app is under view by Apple

  static Future<bool> checkIfReviewApp({
    bool forceToSetIsReviewAppVar = true,
  }) async {
    var isReview = false;

    if (forceToSetIsReviewAppVar) {
      isReviewApp = isReview;
    }

    return isReview;
  }

  // Default variables
  static const double defaultItemCaptionHeight = 25.0;
  static const double defaultItemHeight = 60.0;
  static const double defaultHorizontalMarginBetweenItems = 5.0;
  static const double defaultVerticalMarginBetweenItems = 10.0;
  static const double defaultLeftAndRightPadding = 15.0;
  static const double defaultLeftAndRightMarginBetweenParentBoarderAndPanel =
      15.0;
  static const double defaultRoundCornerPanelBottomMargin = 15.0;

  // Future // Future builder // FutureBuilder

  // db // database
  static String dbNameForMobilePlatform = 'sealMobile.sqlite';
  static final int retryTimesToSaveDb =
      7; // How many times it will retry if it fails to save data to db

  // Colors
  static const Color themeBlackColor = Color(0xff000000);
  static const Color themeBlackColorForFont = Color(0xff000000);
  static const Color themeBlueColor = Color(0xff2b98f0);
  static const Color themeBlueColorForSelectedItemBackground =
      Color(0xffb4d8fd);
  static const Color themeGreenColorAtiOSTodo = Color(0xff67d844);
  static const Color themeGreenColorAtWeChat = Color(0xff20bf64);
  static const Color themeLightBlueColor07 = Color.fromRGBO(43, 152, 240, 0.7);
  static const Color themeLightBlueColor02 = Color.fromRGBO(43, 152, 240, 0.2);
  static const Color themeGreyColor = Color(0xffecedee);
  static const Color themeGreyColorAtiOSTodo = Color(0xffbbbbc0);
  static const Color themeGreyColorForDisabled = themeGreyColorAtiOSTodo;
  static const Color themeGreyColorAtiOSTodoForFolderGroupBackground =
      Color(0xff898a8e);
  static const Color themeGreyColorAtiOSTodoForBackground = Color(0xfff1f2f6);
  static Color themeGrey350Color = Colors.grey[350];
  static Color themeGrey700Color = Colors.grey[700];
  static const Color themeGreyColorAtiOSTodoForBlockIconBackground =
      Color(0xff8e8e93);
  static const Color themeWhiteColorAtiOSTodo = Color(0xffffffff);
  static const Color themeBlackColor87ForFontForeColor = Colors.black87;
  static const Color themeOrangeColorAtiOSTodo = Color(0xfffa9426);
  static const Color themeBrownColorAtiOSTodo = Color(0xff9a8565);
  static const Color themeLightBlueColorAtiOSTodo = Color(0xff2aaff5);

  // Font
  static double defaultTitleFontSizeForItem = 18.0;
  static double defaultNormalFontSizeForItem = 16.0;
  static const double appBarTitleDefaultFontSize = 18.0;
  static Color greyFontColor = Colors.grey[600];
  static FontWeight defaultBoldFontWeightForItem = FontWeight.w400;

  // Update dialog // Update
  static UpdateAppOption updateAppOption = UpdateAppOption.NoUpdate;

  // FlushBar
  static const int defaultFlushBarDuration = 2500;

  // Icon
  static const double defaultIconSize = 25.0;

  // TextStyle
  static TextStyle defaultCaptionTextStyle = TextStyle(
    color: GlobalState.themeBlackColor87ForFontForeColor,
    fontSize: GlobalState.appBarTitleDefaultFontSize,
    fontWeight: GlobalState.defaultBoldFontWeightForItem,
  );
  static TextStyle defaultNormalTextTextStyle = TextStyle(
    color: GlobalState.themeBlackColor87ForFontForeColor,
    fontSize: GlobalState.defaultNormalFontSizeForItem,
  );
  static TextStyle remarkTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w200);

  // Borders
  static const double defaultBorderRadius = 10.0;
  static const double borderRadius10 = 10.0;
  static const double borderRadius15 = 15.0;
  static const double borderRadius40 = 40.0;

  // Database
  static Database database;

  // Device basic info
  static int
      screenType; // 1 = small screen, 2 = medium screen, 3 = large screen
  static double screenWidth;
  static double screenHeight;
  static double appBarHeight;
  static double defaultAppBarHeight = 56.0;
  static double webViewHeight;

  // static int rotatedTimes;

  // Keyboard related
  static double keyboardHeight = 0.0;
  static double bottomPanelHeight = 0.0;
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

  // Reusable page
  static String firstReusablePageTitle = '';
  static Widget firstReusablePageChild;
  static bool isHandlingReusablePage = false;
  static bool isUpcomingReusablePageMovingToLeft =
      true; // Move left or right, it is moving to left by default
  static List<ReusablePageModel> reusablePageWidgetList = <ReusablePageModel>[];

  // Review plan
  static double reviewPlanItemHeight = defaultItemHeight;
  static bool isReviewPlanPageTriggeredByFolderOption = false;

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
  static double currentReusablePageWidth = 0.0;

  // Contexts
  static BuildContext myAppContext;
  static BuildContext masterDetailPageContext;
  static BuildContext noteListPageContext;
  static BuildContext folderOptionItemListPanelContext;
  static BuildContext noteDetailWidgetContext;
  static BuildContext myWebViewPluginContext;
  static BuildContext currentShowingDialogContext;

  // Selected note related
  static NoteWithProgressTotal firstNoteToBeSelected;
  static NoteWithProgressTotal selectedNoteModel =
      NoteWithProgressTotal(); // When the user clicks on the note list item, we store the note model to this variable for the sake of future usage to update these values shown on the note list
  static NoteWithProgressTotal lastSelectedNoteModel = NoteWithProgressTotal();
  static String defaultTitleForNewNote = '新笔记';
  static String defaultTitleWhenNoteHasNoTitle = '无标题';
  static String emptyNoteEncodedContentWithBr = '&lt;p&gt;&lt;br&gt;&lt;/p&gt;';
  static String emptyNoteEncodedContentWithoutChild = '&lt;p&gt;&lt;/p&gt;';
  static int selectedFolderIdByDefault =
      3; // The user folder id by default, since default folders can save notes actually, we need a user folder to store notes when creating a new note from a default folder
  static int selectedFolderIdCurrently =
      selectedFolderIdByDefault; // The current selected folder id the user clicks on folder list page
  static int targetFolderIdNoteIsMovingTo = 0;
  static String selectedFolderNameCurrently = '';

  static int
      selectedFolderReviewPlanId; // null means the folder hasn't a review plan
  static int
      reviewPlanIdOfDefaultSelectedFolder; // The review plan id of the default selected folder, that is the review plan id for selectedFolderIdByDefault
  static String
      noteContentEncodedInDb; // The note encoded content which is saved in db currently
  static bool isNewNoteBeingSaved =
      false; // Indicate if a new note is being saved, avoiding duplicate notes being created
  static bool shouldSetBackgroundColorToFirstNoteAutomatically = false;

  // State objects
  static GlobalKey<MasterDetailPageState> masterDetailPageState;
  static GlobalKey<AppBarWidgetState> appBarWidgetState;
  static GlobalKey<FolderListPageState> folderListPageState;
  static GlobalKey<FolderListWidgetState> folderListWidgetState;
  static GlobalKey<NoteListWidgetForTodayState> noteListWidgetForTodayState;
  static GlobalKey<SelectFolderWidgetState> selectFolderWidgetState =
      GlobalKey<SelectFolderWidgetState>();
  static GlobalKey<NoteDetailWidgetState> noteDetailWidgetState =
      GlobalKey<NoteDetailWidgetState>();
  static GlobalKey<ReusablePageStackWidgetState> reusablePageStackWidgetState =
      GlobalKey<ReusablePageStackWidgetState>();

  static GlobalKey<ReviewPlanWidgetState> reviewPlanWidgetState =
      GlobalKey<ReviewPlanWidgetState>();
  static GlobalKey<ReviewPlanSecondSubPageState> reviewPlanSecondSubPageState =
      GlobalKey<ReviewPlanSecondSubPageState>();
  static GlobalKey<LoginPageState> loginPageState = GlobalKey<LoginPageState>();

  // Dialog // Alert dialog
  static bool shouldContinueActionForShowDialog = false;
  static bool isAlertDialogBeingShown = false;
  static bool isMoveNoteAlertDialogBeingShown = false;
  static String
      remarkForWhenNoteWillBecomeReviewFinishedAfterMovingToTargetFolder =
      '根据此笔记的复习进度，移动后，此笔记会被视为『复习完成』（不再复习）!\n原因：目标文件夹，所需复习次数更少。';
  static String remarkForMovingNoteToFolderWithoutReviewPlan =
      '因为目标文件夹，没有复习计划。移动后，此笔记将不再复习！';

  // Overlay
  static OverlayEntry overlayEntry;

  // Change Notifier
  static AppState appState;
  static SelectedNoteModel noteModelForConsumer;
  static DetailPageChangeNotifier detailPageChangeNotifier;
  static ReusablePageOpenOrCloseNotifier reusablePageOpenOrCloseNotifier;
  static ReusablePageChangeNotifier reusablePageChangeNotifier;
  static ReusablePageWidthChangeNotifier reusablePageWidthChangeNotifier;
  static AlertDialogHeightChangeNotifier alertDialogHeightChangeNotifier;
  static ViewAgreementPageChangeNotifier viewAgreementPageChangeNotifier;
  static LoadingWidgetChangeNotifier loadingWidgetChangeNotifier;

  // Event // Listener
  static WebViewLoadedEventHandler webViewLoadedEventHandler =
      WebViewLoadedEventHandler();

  // Folder related
  static bool isDefaultFolderSelected = false; // For default folder
  static bool isReviewFolderSelected = false; // For review folder

  // Folder selection
  static double folderListItemHeightForFolderSelection = 50.0;

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
  static List<int> defaultFolderIndexList = <int>[];

  // Folder Options
  static double folderOptionItemHeight = 40.0;

  // Setting page

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
  static const int millisecondToSyncWithWebView = 200;
  static bool shouldHideWebView = false;

  // Quill editor
  static bool isQuillReadOnly = true;
  static bool isEditingOrCreatingNote =
      false; // Indicating if the user is creating a new note
  static bool pickerIsBeingShown =
      false; // Font color and background color pick in the tool bar of the Quill

  // Photo Views
  static List<ImageSyncItem> imageSyncItemList = <ImageSyncItem>[];

  // Check Box
  static double defaultCheckBoxWidth = 50.0;

  // Testing
  static int hitTimes = 0;
  static String imageId;
}
