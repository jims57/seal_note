import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/ReusablePageOpenOrCloseNotifier.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:seal_note/mixin/check_device.dart';
import 'package:seal_note/ui/FolderListPage.dart';
import 'package:seal_note/ui/NoteListPage.dart';
import 'package:after_layout/after_layout.dart';
import 'package:seal_note/ui/authentications/LoginPage.dart';
import 'package:seal_note/ui/common/pages/reusablePages/ReusablePageStackWidget.dart';
import 'package:seal_note/ui/reviewPlans/ReviewPlanWidget.dart';
import 'package:seal_note/util/dialog/AlertDialogHandler.dart';
import 'package:seal_note/util/networks/NetworkHandler.dart';
import 'package:seal_note/util/robustness/RetryHandler.dart';
import 'package:seal_note/util/tcb/TCBLoginHandler.dart';
import 'package:seal_note/util/updates/AppUpdateHandler.dart';
import 'dart:io' show Platform;
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

import 'NoteDetailWidget.dart';

class MasterDetailPage extends StatefulWidget {
  MasterDetailPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MasterDetailPageState();
}

class MasterDetailPageState extends State<MasterDetailPage>
    with
        CheckDeviceMixin,
        TickerProviderStateMixin,
        AfterLayoutMixin<MasterDetailPage> {
  bool isFirstLoad = true;

  double folderPageFromDx = -1.0;
  double folderPageToDx = 0.0;
  double noteDetailPageFromDx = -1.0;
  double noteDetailPageToDx = 0.0;
  double loginPageFromDx = 0.0;
  double loginPageToDx = 0.0;

  double folderPageWidth = GlobalState.folderPageDefaultWidth;
  double noteListPageWidth = GlobalState.noteListPageDefaultWidth;
  double noteDetailPageWidth = GlobalState.noteDetailPageDefaultWidth;

  // Reusable page related
  var reusablePageFromDx = 1.0;
  var reusablePageToDx = 0.0;
  Future<bool> loginPageFutureBuilder;

  @override
  void initState() {
    loginPageFutureBuilder = _checkIfShowLoginPageOrNot();

    GlobalState.flutterWebviewPlugin = FlutterWebviewPlugin();

    GlobalState.masterDetailPageContext = context;

    // Models
    GlobalState.noteModelForConsumer =
        Provider.of<SelectedNoteModel>(context, listen: false);

    // States
    GlobalState.folderListPageState = GlobalKey<FolderListPageState>();

    // Load file for Quill according to the release or debug mode
    var quillEditorHtmlFile = 'assets/QuillEditor.html';

    rootBundle.loadString(quillEditorHtmlFile).then((htmlString) {
      GlobalState.htmlString = htmlString;
      GlobalState.appState.widgetNo = 2;
      GlobalState.detailPageChangeNotifier.refreshDetailPage();
    });

    super.initState();

    // Show update dialog if the user has logged in
    TCBLoginHandler.hasLoginTCB().then((hasLoginTCB) async {
      // Check if the user has logged in, we only show the update dialog after logging in
      // show update dialog

      // Make sure has network
      var hasNetwork = await NetworkHandler.hasNetworkConnection();

      if (hasLoginTCB && hasNetwork) {
        // Don't show update dialog before login
        GlobalState.webViewLoadedEventHandler.onWebViewLoaded
            .listen((hasWebViewLoaded) async {
          // listen webview loaded event // listen to webview loaded event
          // listen webview load event // listen to webview load event

          if (hasWebViewLoaded) {
            await checkIfShowUpdateDialogOrNot(forceToGetUpdateAppOption: true);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    GlobalState.screenHeight = getScreenHeight(context);
    GlobalState.screenWidth = getScreenWidth(context);
    GlobalState.screenType = checkScreenType(GlobalState.screenWidth);

    updatePageShowAndHide(
        shouldTriggerSetState: false,
        resetFolderAndDetailPageToDefaultDx: isFirstLoad);

    // Check if it is the first load, sometimes, the subsequent performance will be omitted
    if (isFirstLoad) {
      // When the app's first launch
      // first load // it is first load
      // app launch event // app start event
      // start app event // launc app event

      isFirstLoad = false;
    } else {
      // When not the app's first launch
      // rotation event // rotate device event
      // device rotation

      // Get app bar height after rotation

      // Check if it is handling the reusable page
      if (GlobalState.isHandlingReusablePage) {
        GlobalState.reusablePageWidthChangeNotifier
            .notifyReusablePageWidthChange();

        // Check if the web view is in edit mode, set it to read only if yes
        if (!GlobalState.isQuillReadOnly && GlobalState.screenType == 1) {
          GlobalState.noteDetailWidgetState.currentState
              .setWebViewToReadOnlyMode(
            keepNoteDetailPageOpen: false,
            forceToSaveNoteToDbIfAnyUpdates: true,
          );
        }
      }

      // Reset the View Agreement Note to load for the first time, avoiding trigger transition effect during rotation
      GlobalState.viewAgreementPageChangeNotifier.shouldAvoidTransitionEffect =
          true;

      // If Login Page is being shown, hide the WebView forcibly
      if (GlobalState.shouldShowLoginPage) {
        GlobalState.noteDetailWidgetState.currentState.hideWebView(
          forceToSyncWithShouldHideWebViewVar: false,
          retryTimes: 10,
        );
      }

      Timer(const Duration(milliseconds: 700), () {
        // Update the app bar's height on the folder list page
        refreshFolderListPageAppBarHeight();

        // Always to refresh the folder page, making sure the selected item's background will be shown properly
        if (GlobalState.screenType == 3) {
          GlobalState.folderListWidgetState.currentState
              .triggerSetState(forceToFetchFoldersFromDb: false);
        }

        // Refresh the note list page after rotation
        if (GlobalState.screenType != 1) {
          // Specific logic for the small screen, considering the WebView
          // When it isn't the small screen, the WebView will show by default,
          // So we need to take further action to handle it in order to avoid the WebView to block any widget,
          // such as Alert Dialog

          if (GlobalState.selectedNoteModel.id == null) {
            GlobalState.noteListWidgetForTodayState.currentState
                .triggerToClickOnNoteListItem(
                    theNote: GlobalState.firstNoteToBeSelected,
                    forceToSaveNoteToDbIfAnyUpdates: true,
                    forceToSetBackgroundColorToFirstNoteWhenBackgroundNeeded:
                        false);
          }
        }

        // Check if it is rotating // check if rotation
        // after rotation // after rotation event
        // after rotating event // check rotation action
        // Check if the editor is in edit mode or not, only it won't go to the cursor position unless it is in edit mode
        var goToCursorPosition = false;
        // if (!GlobalState.isQuillReadOnly && GlobalState.keyboardHeight > 0.0) {
        if (!GlobalState.isQuillReadOnly) {
          // When the editor is in edit mode, force it to navigate to the cursor position
          goToCursorPosition = true;
        }

        GlobalState.noteDetailWidgetState.currentState
            .triggerEditorToAutoFitScreen(
                goToCursorPosition: goToCursorPosition);

        // Check if the move note alert dialog is being shown
        if (GlobalState.isAlertDialogBeingShown) {
          GlobalState.noteDetailWidgetState.currentState
              .hideWebView(forceToSyncWithShouldHideWebViewVar: false);

          // When there is an alert dialog being shown, try to notify to change its height
          GlobalState.alertDialogHeightChangeNotifier
              .notifyAlertDialogToChangeHeight();
        }
      });

      GlobalState.isKeyboardEventHandling = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // master detail build method
    var scaffold = Scaffold(
      body: Stack(
        children: [
          // Note list page
          Container(
            // Note list page
            margin: getNoteListPageLeftEdgeInset(),
            width: noteListPageWidth,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: NoteListPage(),
            ),
          ),

          // Folder page
          SlideTransition(
            // Folder page
            position:
                getAnimation(fromDx: folderPageFromDx, toDx: folderPageToDx),
            transformHitTests: true,
            textDirection: TextDirection.ltr,
            child: Container(
              // Folder page
              margin: getFolderPageLeftEdgeInset(),
              width: folderPageWidth,
              color: Colors.green,
              // child: FolderListWidget(),
              child: FolderListPage(
                key: GlobalState.folderListPageState,
              ),
            ),
          ),

          // Reusable page
          Consumer<ReusablePageOpenOrCloseNotifier>(
              builder: (cxt, reusablePageOpenOrCloseNotifier, child) {
            // show reusable page // reusable page
            // build reusable page // reusable page consumer

            if (GlobalState.isHandlingReusablePage) {
              if (GlobalState.screenType == 1) {
                GlobalState.noteDetailWidgetState.currentState
                    .hideWebView(forceToSyncWithShouldHideWebViewVar: false);
              }

              _updateReusablePageFromDxAndToDx();

              // Check if we should mark it is handling the reusable page or not
              if (GlobalState
                      .reusablePageChangeNotifier.upcomingReusablePageIndex >=
                  0) {
                GlobalState.isHandlingReusablePage = true;
              } else {
                GlobalState.isHandlingReusablePage = false;
              }

              return SlideTransition(
                position: GlobalState.masterDetailPageState.currentState
                    .getAnimation(
                        fromDx: reusablePageFromDx, toDx: reusablePageToDx),
                child: ReusablePageStackWidget(
                  key: GlobalState.reusablePageStackWidgetState,
                  firstReusablePageTitle:
                      '${GlobalState.firstReusablePageTitle}',
                  child: GlobalState.firstReusablePageChild,
                ),
              );
            } else {
              return Container();
            }
          }),

          // Note detail page
          SlideTransition(
            // Note detail page
            position: getAnimation(
                fromDx: noteDetailPageFromDx, toDx: noteDetailPageToDx),
            transformHitTests: true,
            textDirection: TextDirection.ltr,
            child: Container(
                // Note detail page
                margin: getNoteDetailPageLeftEdgeInset(),
                width: noteDetailPageWidth,
                // color: Colors.red,
                child: NoteDetailWidget(
                  key: GlobalState.noteDetailWidgetState,
                )),
          ),

          // Login page
          FutureBuilder<bool>(
              future: loginPageFutureBuilder,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var shouldShow = false;

                  if (!snapshot.data) {
                    // Shouldn't show the login page
                    shouldShow = false;
                  } else {
                    // Should show the login page
                    shouldShow = true;
                  }

                  // Should show the login page // show login page
                  return LoginPage(
                    key: GlobalState.loginPageState,
                    shouldShow: shouldShow,
                  );
                } else {
                  return Container();
                }
              }),
          // LoginPage(key: GlobalState.loginPageState),
        ],
      ),
    );

    // Anyway we set it back to the default(true)
    GlobalState.shouldTriggerPageTransitionAnimation = true;

    return scaffold;
  }

  void triggerSetState() {
    setState(() {});
  }

  void updatePageShowAndHide({
    @required bool shouldTriggerSetState,
    bool resetFolderAndDetailPageToDefaultDx = false,
    bool hasAnimation = true,
    bool hideWebViewInSmallScreenWhenReusablePageBeingShown = true,
  }) {
    // update page show and hide // set page show and hide
    // If you resetFolderAndDetailPageToDefaultDx = false, we will position the folder and note detail page with animation to the right place,
    // Or we will set it back to their default positions, folder page is on the left of the note list page,
    // whereas the note detail page is on the right of the note list page

    if (GlobalState.screenType == 1) {
      // Set width
      folderPageWidth = GlobalState.screenWidth;
      noteListPageWidth = GlobalState.screenWidth;

      if (hideWebViewInSmallScreenWhenReusablePageBeingShown &&
          GlobalState.isHandlingReusablePage) {
        noteDetailPageWidth = 0.0;
      } else {
        noteDetailPageWidth = GlobalState.screenWidth;
      }

      if (resetFolderAndDetailPageToDefaultDx) {
        folderPageFromDx = GlobalState.folderPageDefaultFromDx;
        folderPageToDx = GlobalState.folderPageDefaultToDx;
        noteDetailPageFromDx = GlobalState.noteDetailPageDefaultFromDx;
        noteDetailPageToDx = GlobalState.noteDetailPageDefaultToDx;
      } else {
        // It will only check it when the action is for the folder page
        if (GlobalState.isHandlingFolderPage) {
          GlobalState.isHandlingFolderPage = false;

          // Check if it is in the folder page
          _setFolderPageAnimation(hasAnimation: hasAnimation);
        } else {
          folderPageFromDx = folderPageToDx;
        }

        // It will only check it when the action is for the note detail page
        if (GlobalState.isHandlingNoteDetailPage) {
          GlobalState.isHandlingNoteDetailPage =
              false; // Immediately set it back to false

          // Check if it is in the note detail page
          _setNoteDetailPageAnimation(hasAnimation: hasAnimation);
        } else {
          // Make sure the note detail page is being open, or we don't show it
          if (GlobalState.isInNoteDetailPage) {
            // The note detail page should be shown
            noteDetailPageFromDx = noteDetailPageToDx;
          } else {
            // Don't show the note detail page
            noteDetailPageFromDx = 1.0;
            noteDetailPageToDx = 1.0;
          }
        }
      }
    } else if (GlobalState.screenType == 2) {
      // Set pages's width
      folderPageWidth = GlobalState.noteListPageDefaultWidth;
      noteListPageWidth = GlobalState.noteListPageDefaultWidth;
      noteDetailPageWidth =
          GlobalState.screenWidth - GlobalState.noteDetailPageDefaultWidth;

      if (resetFolderAndDetailPageToDefaultDx) {
        folderPageFromDx = GlobalState.folderPageDefaultFromDx;
        folderPageToDx = GlobalState.folderPageDefaultToDx;
        noteDetailPageFromDx = 0.0;
        noteDetailPageToDx = 0.0;
      } else {
        // It will only check it when the action is for the folder page
        if (GlobalState.isHandlingFolderPage) {
          GlobalState.isHandlingFolderPage = false;

          _setFolderPageAnimation(hasAnimation: hasAnimation);
        } else {
          // Check if it should show the folder page
          if (GlobalState.isInFolderPage) {
            folderPageFromDx = folderPageToDx;
          } else {
            folderPageFromDx = -1.0;
            folderPageToDx = -1.0;
          }
        }

        // It will only check it when the action is for the note detail page
        if (GlobalState.isHandlingNoteDetailPage) {
          GlobalState.isHandlingNoteDetailPage = false;

          // Check if it is in the note detail page
          _setNoteDetailPageAnimation(hasAnimation: hasAnimation);
        } else {
          // noteDetailPageFromDx = noteDetailPageToDx;
          noteDetailPageFromDx = 0.0;
          noteDetailPageToDx = 0.0;
        }
      }
    } else {
      // When it is large screen(screenType = 3)
      // Set pages's width
      folderPageWidth = GlobalState.folderPageDefaultWidth;
      noteListPageWidth = GlobalState.noteListPageDefaultWidth;
      noteDetailPageWidth =
          GlobalState.screenWidth - GlobalState.noteDetailPageDefaultWidth;

      if (resetFolderAndDetailPageToDefaultDx) {
        folderPageFromDx = 0.0;
        folderPageToDx = 0.0;
        noteDetailPageFromDx = 0.0;
        noteDetailPageToDx = 0.0;
      } else {
        // Handle the large screen
        folderPageFromDx = 0.0;
        folderPageToDx = 0.0;
        noteDetailPageFromDx = 0.0;
        noteDetailPageToDx = 0.0;
      }
    }

    // Update the current width for pages
    GlobalState.currentFolderPageWidth = folderPageWidth;
    GlobalState.currentNoteListPageWidth = noteListPageWidth;
    GlobalState.currentNoteDetailPageWidth = noteDetailPageWidth;

    if (shouldTriggerSetState) triggerSetState();
  }

  EdgeInsets getFolderPageLeftEdgeInset() {
    return EdgeInsets.only(left: 0.0);
  }

  EdgeInsets getNoteListPageLeftEdgeInset() {
    if (GlobalState.screenType == 3) {
      return EdgeInsets.only(left: GlobalState.folderPageDefaultWidth);
    } else {
      return EdgeInsets.only(left: 0.0);
    }
  }

  EdgeInsets getNoteDetailPageLeftEdgeInset() {
    if (GlobalState.screenType == 1) {
      return EdgeInsets.only(left: 0.0);
    } else if (GlobalState.screenType == 2) {
      return EdgeInsets.only(left: GlobalState.noteListPageDefaultWidth);
    } else {
      return EdgeInsets.only(
          left: GlobalState.folderPageDefaultWidth +
              GlobalState.noteListPageDefaultWidth);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    print('Screen height:${GlobalState.screenHeight}');
    print('Screen width:${GlobalState.screenWidth}');
  }

  // Private methods
  void _setFolderPageAnimation({bool hasAnimation = true}) {
    // Check if it is in the folder page
    if (GlobalState.isInFolderPage) {
      folderPageFromDx = -1.0;
      folderPageToDx = 0.0;
      if (!hasAnimation) folderPageFromDx = folderPageToDx;
    } else {
      folderPageFromDx = 0.0;
      folderPageToDx = -1.0;
      if (!hasAnimation) folderPageFromDx = folderPageToDx;
    }
  }

  void _setNoteDetailPageAnimation({bool hasAnimation = true}) {
    if (GlobalState.isInNoteDetailPage) {
      noteDetailPageFromDx = 1.0;
      noteDetailPageToDx = 0.0;
      if (!hasAnimation) noteDetailPageFromDx = noteDetailPageToDx;
    } else {
      noteDetailPageFromDx = 0.0;
      noteDetailPageToDx = 1.0;
      if (!hasAnimation) noteDetailPageFromDx = noteDetailPageToDx;
    }
  }

  void _updateReusablePageFromDxAndToDx() {
    if (GlobalState.reusablePageOpenOrCloseNotifier.isGoingToOpenReusablePage) {
      // When it is expanding the reusable page
      reusablePageFromDx = 1.0;
      reusablePageToDx = 0.0;
    } else {
      // When it is collapsing the reusable page
      reusablePageFromDx = 0.0;
      reusablePageToDx = 1.0;
    }
  }

  Future<bool> _checkIfShowLoginPageOrNot() async {
    // show login page or not // check if show login page or not
    // check show login page or not // check show login page or not
    // whether to show login page

    // bool shouldShowLoginPage;

    if (await GlobalState.checkIfReviewApp(
      forceToSetIsReviewAppVar: true,
    )) {
      // Review app
      GlobalState.shouldShowLoginPage = false;
    } else {
      // Not review app

      if (!await NetworkHandler.hasNetworkConnection()) {
        // shouldShowLoginPage = true;
        GlobalState.shouldShowLoginPage = true;
      } else if (!await TCBLoginHandler.hasLoginTCB()) {
        // shouldShowLoginPage = true;
        GlobalState.shouldShowLoginPage = true;
        // } else if (await TCBLoginHandler.isLoginExpired()) {
        //   shouldShowLoginPage = true;
      } else {
        // shouldShowLoginPage = false;
        GlobalState.shouldShowLoginPage = false;
      }
    }

    // return shouldShowLoginPage;
    return GlobalState.shouldShowLoginPage;
  }

  // Public methods
  void triggerToShowReusablePage({String title = '', @required Widget child}) {
    // trigger to show reusable page // show reusable page method

    GlobalState.reusablePageChangeNotifier.upcomingReusablePageIndex = 0;
    GlobalState.firstReusablePageTitle = title;
    GlobalState.firstReusablePageChild = child;
    GlobalState.isHandlingReusablePage = true;
    GlobalState.reusablePageOpenOrCloseNotifier.isGoingToOpenReusablePage =
        true;
  }

  void triggerToHideReusablePage() {
    // hide reusable page method // trigger to hide reusable page

    GlobalState.isHandlingReusablePage = true;
    GlobalState.reusablePageOpenOrCloseNotifier.isGoingToOpenReusablePage =
        false;
  }

  Animation<Offset> getAnimation(
      {double fromDx = -1.0,
      double toDx = 0.0,
      double fromDy = 0.0,
      double toDy = 0.0,
      int durationMilliseconds =
          GlobalState.pageTransitionAnimationDurationMilliseconds}) {
    AnimationController _controller = AnimationController(
      duration: Duration(milliseconds: durationMilliseconds),
      vsync: this,
    )..forward();

    // Check we should show the page transition animation, sometimes, we don't need the animation,
    // although we are still using the getAnimation() to build the MasterDetailPage
    if (!GlobalState.shouldTriggerPageTransitionAnimation) fromDx = toDx;

    Animation<Offset> _animation = Tween<Offset>(
      begin: Offset(fromDx, fromDy),
      end: Offset(toDx, toDy),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));

    return _animation;
  }

  void refreshFolderListPageAppBarHeight() {
    // Update folder page app bar and trigger setState()
    GlobalState.folderPageTopContainerHeight =
        GlobalState.appBarWidgetState.currentState.getAppBarHeight();
    GlobalState.folderListPageState.currentState.triggerSetState();
  }

  Future<void> showReviewPlanPage({
    @required int folderId,
    bool triggeredByFolderOption = false,
  }) async {
    GlobalState.isReviewPlanPageTriggeredByFolderOption =
        triggeredByFolderOption;

    // Get the review plan for the current folder
    GetFolderReviewPlanByFolderIdResult getFolderReviewPlanByFolderIdResult =
        await GlobalState.database
            .getFolderReviewPlanByFolderId(folderId)
            .getSingle();

    GlobalState.masterDetailPageState.currentState.triggerToShowReusablePage(
      title: '选择复习计划',
      child: ReviewPlanWidget(
        key: GlobalState.reviewPlanWidgetState,
        folderId: folderId,
        getFolderReviewPlanByFolderIdResult:
            getFolderReviewPlanByFolderIdResult,
      ),
    );
  }

  Future<void> checkIfShowUpdateDialogOrNot({
    // forceToGetUpdateAppOption: if true, we will set GlobalState.updateAppOption forcibly again,
    // rather than keep using the one in memory.
    bool forceToGetUpdateAppOption = true,
  }) async {
    // check show update dialog or not // show update dialog or not
    // whether to show update dialog

    if (forceToGetUpdateAppOption) {
      GlobalState.updateAppOption = await AppUpdateHandler.getUpdateAppOption();
    }

    if (GlobalState.updateAppOption == UpdateAppOption.HasError) {
      // When it has error, when fetching update app option

      GlobalState.loginPageState.currentState.showLoginPage(
        errorInfo: '获取更新信息时失败，请检查网络',
        autoHideErrorInfo: false,
      );
    } else {
      if (GlobalState.updateAppOption == UpdateAppOption.NoUpdate) {
        // When no error, and it has no update

        // Do nothing currently, if no update for now
        var s = 's';
      } else {
        // When no error, and it has update found

        // Hide the webView first before showing update dialog, prevent it from being blocked
        if (GlobalState.screenType != 1) {
          GlobalState.noteDetailWidgetState.currentState
              .hideWebView(forceToSyncWithShouldHideWebViewVar: false);
        }

        GlobalState.noteDetailWidgetState.currentState
            .executionCallbackToAvoidBeingBlockedByWebView(callback: () async {
          // Variable for alert dialog
          var buttonTextForCancel = '下次提醒';
          var updateTipForImportant = '这是重大更新，请更新';

          // When it is compulsory update, we need to change the cancel button's appearance
          if (GlobalState.updateAppOption == UpdateAppOption.CompulsoryUpdate) {
            buttonTextForCancel = '不想更新';
          }

          var shouldGoToUpdateApp = await AlertDialogHandler().showAlertDialog(
            // update dialog // update app tip // show update dialog
            parentContext: context,
            captionText: '发现新版本',
            remark: '1、修改大量bugs；\n'
                '2、用户能自主创建复习计划；\n'
                '3、其他重大更新。',
            child: Container(
              padding: EdgeInsets.only(
                left: GlobalState.defaultLeftAndRightPadding,
                right: GlobalState.defaultLeftAndRightPadding,
              ),
              child: Text(
                '注：$updateTipForImportant!',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.red,
                ),
              ),
            ),
            buttonTextForOK: '马上更新',
            buttonTextForCancel: buttonTextForCancel,
            buttonColorForCancel: GlobalState.themeGreyColorAtiOSTodo,
            restoreWebViewToShowIfNeeded: true,
            expandRemarkToMaxFinite: false,
            barrierDismissible: false,
          );

          if (shouldGoToUpdateApp) {
            // Update the app

            if (Platform.isIOS) {
              // go to app store // go to ios app store
              await StoreRedirect.redirect(
                  androidAppId: GlobalState.androidAppId,
                  iOSAppId: GlobalState.iOSAppId);
            } else if (Platform.isAndroid) {
              var url = GlobalState.downloadLinkForAndroid;
              await canLaunch(url)
                  ? await launch(url)
                  : throw 'Could not launch $url';
            } else {
              var s = 's';
            }
          } else {
            // Don't update the app
            var ss = 's';
          }

          // If it is a compulsory update, navigating to the login page anyway
          if (GlobalState.updateAppOption == UpdateAppOption.CompulsoryUpdate) {
            var errorInfoForLoginPage = updateTipForImportant;

            if (shouldGoToUpdateApp) {
              errorInfoForLoginPage = '请更新后，再继续使用';
            }

            GlobalState.loginPageState.currentState.showLoginPage(
              errorInfo: errorInfoForLoginPage,
              autoHideErrorInfo: false,
            );
          }
        });
      }
    }
  }
}
