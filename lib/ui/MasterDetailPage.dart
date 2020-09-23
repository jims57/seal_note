import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/DetailPageState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';
import 'package:seal_note/mixin/check_device.dart';
import 'package:seal_note/ui/FolderListPage.dart';
import 'package:seal_note/ui/NoteListPage.dart';
import 'package:after_layout/after_layout.dart';

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

  double folderPageWidth = GlobalState.folderPageDefaultWidth;
  double noteListPageWidth = GlobalState.noteListPageDefaultWidth;
  double noteDetailPageWidth = GlobalState.noteDetailPageDefaultWidth;

  @override
  void initState() {
    GlobalState.flutterWebviewPlugin = FlutterWebviewPlugin();

    GlobalState.masterDetailPageContext = context;

    // Models
    GlobalState.selectedNoteModel =
        Provider.of<SelectedNoteModel>(context, listen: false);

    // Change notifier
    GlobalState.appState = Provider.of<AppState>(context, listen: false);
    GlobalState.detailPageChangeNotifier =
        Provider.of<DetailPageChangeNotifier>(context, listen: false);

    // States
    GlobalState.folderListPageState = GlobalKey<FolderListPageState>();

    rootBundle.loadString('assets/QuillEditor.html').then((htmlString) {
      GlobalState.htmlString = htmlString;
      GlobalState.appState.widgetNo = 2;
      GlobalState.detailPageChangeNotifier.refreshDetailPage();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // Record rotation times
    if (GlobalState.rotatedTimes == null) {
      GlobalState.rotatedTimes = 0;
    } else {
      GlobalState.rotatedTimes += 1;
    }

    GlobalState.screenHeight = getScreenHeight(context);
    GlobalState.screenWidth = getScreenWidth(context);
    GlobalState.screenType = checkScreenType(GlobalState.screenWidth);

    GlobalState.themeColor = Theme.of(context).primaryColor;

    updatePageShowAndHide(
        shouldTriggerSetState: false,
        resetFolderAndDetailPageToDefaultDx: isFirstLoad);

    // Check if it is the first load, sometimes, the subsequent performance will be ommitted
    if (isFirstLoad) {
      isFirstLoad = false;
    } else {
      // Get app bar height after rotation
      // after rotation
      Timer(const Duration(milliseconds: 200), () {
        var newAppBarHeight =
            GlobalState.appBarWidgetState.currentState.getAppBarHeight();

        // Update the app bar's height on the folder list page
        refreshFolderListPageAppBarHeight();

        //
        // // Update folder page app bar and trigger setState()
        // GlobalState.folderPageTopContainerHeight = newAppBarHeight;
        // GlobalState.folderListPageState.currentState.triggerSetState();

        // Check if it is rotating // check if rotation // check rotation action
        if (GlobalState.appBarHeight != newAppBarHeight) {
          GlobalState.appBarHeight = newAppBarHeight;
          var newWebViewScreenHeight =
              GlobalState.screenHeight - GlobalState.appBarHeight;
          var showToolbar = false;

          // Check if it should show the toolbar
          if (!GlobalState.isQuillReadOnly) {
            // If it is in edit mode
            showToolbar = true;
          }

          // GlobalState.flutterWebviewPlugin.evalJavascript("javascript:setEditorHeightWithNewWebViewScreenHeight($newWebViewScreenHeight, 0, false);");
          GlobalState.flutterWebviewPlugin.evalJavascript(
              "javascript:setEditorHeightWithNewWebViewScreenHeight($newWebViewScreenHeight, ${GlobalState.keyboardHeight}, $showToolbar);");

          print(GlobalState.appBarHeight);
        }
      });

      // Adjust the height of the Quill accordingly after rotation
      if (GlobalState.hasWebViewLoaded &&
          !GlobalState.isKeyboardEventHandling) {
        // GlobalState.flutterWebviewPlugin
        //     .evalJavascript("javascript:updateScreenHeight(${GlobalState.webViewHeight},${GlobalState.keyboardHeight},true);");
      }

      GlobalState.isKeyboardEventHandling = false;
    }

    super.didChangeDependencies();
  }

  Animation<Offset> getAnimation(
      {double fromDx = -1.0,
      double toDx = 0.0,
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
      begin: Offset(fromDx, 0.0),
      end: Offset(toDx, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));

    return _animation;
  }

  @override
  Widget build(BuildContext context) {
    // master detail build method
    var scaffold = Scaffold(
      body: Stack(
        children: [
          Container(
            // Note list page
            margin: getNoteListPageLeftEdgeInset(),
            width: noteListPageWidth,
            // color: Colors.red,
            // child: NoteListPage(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: NoteListPage(),
            ),
          ), // Note list page
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
          ), // Folder page
          SlideTransition(
            // Note detail page
            position: getAnimation(
                fromDx: noteDetailPageFromDx, toDx: noteDetailPageToDx),
            // position: getAnimation(fromDx: 1.0, toDx: 0.0),
            transformHitTests: true,
            textDirection: TextDirection.ltr,
            child: Container(
                // Note detail page
                margin: getNoteDetailPageLeftEdgeInset(),
                width: noteDetailPageWidth,
                color: Colors.blue,
                child: NoteDetailWidget()),
          ),
          // Note detail page
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

  // Handle Page show and hide
  void updatePageShowAndHide(
      {@required bool shouldTriggerSetState,
      bool resetFolderAndDetailPageToDefaultDx = false,
      bool hasAnimation = true}) {
    // If you resetFolderAndDetailPageToDefaultDx = false, we will position the folder and note detail page with animation to the right place,
    // Or we will set it back to their default positions, folder page is on the left of the note list page,
    // whereas the note detail page is on the right of the note list page

    if (GlobalState.screenType == 1) {
      // Set width
      folderPageWidth = GlobalState.screenWidth;
      noteListPageWidth = GlobalState.screenWidth;
      noteDetailPageWidth = GlobalState.screenWidth;

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
          folderPageFromDx = folderPageToDx;
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
      } else {}
    }

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
    var s = 's';
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

  // Public methods
  void refreshFolderListPageAppBarHeight() {
    // Update folder page app bar and trigger setState()
    GlobalState.folderPageTopContainerHeight =
        GlobalState.appBarWidgetState.currentState.getAppBarHeight();
    GlobalState.folderListPageState.currentState.triggerSetState();
  }
}
