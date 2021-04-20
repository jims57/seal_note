//Import packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/authentications/LoginPage.dart';
import 'package:seal_note/util/time/TimeHandler.dart';

// Import custom files
import 'data/appstate/AlertDialogHeightChangeNotifier.dart';
import 'data/appstate/AppState.dart';
import 'data/appstate/DetailPageState.dart';
import 'data/appstate/ReusablePageChangeNotifier.dart';
import 'data/appstate/ReusablePageOpenOrCloseNotifier.dart';
import 'data/appstate/ReusablePageWidthChangeNotifier.dart';
import 'data/appstate/SelectedNoteModel.dart';
import 'data/appstate/ViewAgreementPageChangeNotifier.dart';
import 'data/database/database.dart';
import 'data/database/dbHelper/shared.dart';

// Import widgets
import 'package:seal_note/ui/MasterDetailPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      Provider<Database>(
        create: (context) => constructDb(),
        dispose: (context, db) => db.close(),
      ),
      ChangeNotifierProvider<SelectedNoteModel>(
        create: (context) => SelectedNoteModel(),
      ),
      ChangeNotifierProvider<AppState>(
        create: (context) => AppState(),
      ),
      ChangeNotifierProvider<DetailPageChangeNotifier>(
        create: (context) => DetailPageChangeNotifier(),
      ),
      ChangeNotifierProvider<ReusablePageOpenOrCloseNotifier>(
        create: (context) => ReusablePageOpenOrCloseNotifier(),
      ),
      ChangeNotifierProvider<ReusablePageChangeNotifier>(
        create: (context) => ReusablePageChangeNotifier(),
      ),
      ChangeNotifierProvider<ReusablePageWidthChangeNotifier>(
        create: (context) => ReusablePageWidthChangeNotifier(),
      ),
      ChangeNotifierProvider<AlertDialogHeightChangeNotifier>(
        create: (context) => AlertDialogHeightChangeNotifier(),
      ),
      ChangeNotifierProvider<ViewAgreementPageChangeNotifier>(
        create: (context) => ViewAgreementPageChangeNotifier(),
      ),

    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _initConsumerNotifier();

    GlobalState.database = Provider.of<Database>(context, listen: false);
    GlobalState.myAppContext = context;
    GlobalState.masterDetailPageState = GlobalKey<MasterDetailPageState>();

    // Check if the db is initialized or not
    // init data // initialization data
    // init tables // init app data
    GlobalState.database.isDbInitialized().then((isDbInitialized) {
      if (!isDbInitialized) {
        // If the db isn't initialized, we need to insert basic data
        var now = TimeHandler.getNowForLocal();

        // Initialize users // init users
        var usersCompanion = UsersCompanion(
            userName: Value('admin'),
            password: Value('123456'),
            created: Value(now));
        GlobalState.database.insertUser(usersCompanion);

        // Initialize folders // init folders
        var folderEntryList = <FolderEntry>[];
        folderEntryList.add(FolderEntry(
            id: null,
            name: '今天',
            order: 1,
            isDefaultFolder: true,
            created: now,
            isDeleted: false,
            createdBy: GlobalState.adminUserId));
        folderEntryList.add(FolderEntry(
            id: null,
            name: '全部笔记',
            order: 2,
            isDefaultFolder: true,
            created: now,
            isDeleted: false,
            createdBy: GlobalState.adminUserId));
        folderEntryList.add(FolderEntry(
            id: null,
            name: '我的笔记',
            order: 3,
            isDefaultFolder: false,
            created: now,
            isDeleted: false,
            createdBy: GlobalState.adminUserId));
        folderEntryList.add(FolderEntry(
            id: null,
            name: '英语知识',
            order: 5,
            isDefaultFolder: false,
            created: now,
            isDeleted: false,
            createdBy: GlobalState.adminUserId));
        folderEntryList.add(FolderEntry(
            id: null,
            name: '编程知识',
            order: 4,
            isDefaultFolder: false,
            created: now,
            isDeleted: false,
            createdBy: GlobalState.adminUserId));
        folderEntryList.add(FolderEntry(
            id: null,
            name: '健身知识',
            order: 6,
            isDefaultFolder: false,
            created: now,
            isDeleted: false,
            createdBy: GlobalState.adminUserId));
        folderEntryList.add(FolderEntry(
            id: null,
            name: '删除笔记',
            order: 7,
            isDefaultFolder: true,
            created: now,
            isDeleted: false,
            createdBy: GlobalState.adminUserId));
        GlobalState.database.upsertFoldersInBatch(folderEntryList);

        // Initialize review plans // init review plans
        var reviewPlanEntryList = <ReviewPlanEntry>[];
        reviewPlanEntryList.add(ReviewPlanEntry(
            id: null,
            name: '五段式',
            introduction: '五段式简介',
            createdBy: GlobalState.adminUserId));
        reviewPlanEntryList.add(ReviewPlanEntry(
            id: null,
            name: '艾宾浩斯',
            introduction: '艾宾浩斯简介',
            createdBy: GlobalState.adminUserId));
        GlobalState.database.upsertReviewPlansInBatch(reviewPlanEntryList);

        // Initialize review plan configs // init review plan configs
        var reviewPlanConfigEntryList = <ReviewPlanConfigEntry>[];
        // Unit for the value. { 1 = minute, 2 = hour, 3 = day, 4 = week, 5 = month, 6 = year }
        // For Five-Part Form
        reviewPlanConfigEntryList.add(ReviewPlanConfigEntry(
            id: null,
            reviewPlanId: 1,
            order: 1,
            value: 30,
            unit: 1,
            createdBy: GlobalState.adminUserId));
        reviewPlanConfigEntryList.add(ReviewPlanConfigEntry(
            id: null,
            reviewPlanId: 1,
            order: 2,
            value: 12,
            unit: 2,
            createdBy: GlobalState.adminUserId));
        reviewPlanConfigEntryList.add(ReviewPlanConfigEntry(
            id: null,
            reviewPlanId: 1,
            order: 3,
            value: 3,
            unit: 3,
            createdBy: GlobalState.adminUserId));

        // For Ebbinghaus
        reviewPlanConfigEntryList.add(ReviewPlanConfigEntry(
            id: null,
            reviewPlanId: 2,
            order: 1,
            value: 15,
            unit: 1,
            createdBy: GlobalState.adminUserId));
        reviewPlanConfigEntryList.add(ReviewPlanConfigEntry(
            id: null,
            reviewPlanId: 2,
            order: 2,
            value: 3,
            unit: 2,
            createdBy: GlobalState.adminUserId));
        GlobalState.database
            .upsertReviewPlanConfigsInBatch(reviewPlanConfigEntryList);

        // Trigger folder list page to refresh so that the initialized folder list can be shown properly
        if (GlobalState.isFolderListPageLoaded) {
          GlobalState.folderListWidgetState.currentState
              .triggerSetState(forceToFetchFoldersFromDb: true);
        }
      } else {
        // When db is initialized

        // Check if the selected folder is a review folder or not asynchronously
        GlobalState.database
            .isReviewFolder(GlobalState.selectedFolderIdCurrently)
            .then((isReviewFolderSelected) {
          GlobalState.isReviewFolderSelected = isReviewFolderSelected;

          // Won't trigger the note list widget to refresh until the default selected folder is a review folder
          if (GlobalState.isReviewFolderSelected) {
            GlobalState.noteListWidgetForTodayState.currentState
                .triggerSetState();
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MasterDetailPage(
        key: GlobalState.masterDetailPageState,
      ),
      // home: LoginPage(),
    );
  }

  // Private methods
  void _initConsumerNotifier() {
    // init notifier // init consumer notifier

    GlobalState.viewAgreementPageChangeNotifier =
        Provider.of<ViewAgreementPageChangeNotifier>(context, listen: false);

    GlobalState.appState = Provider.of<AppState>(context, listen: false);

    GlobalState.noteModelForConsumer =
        Provider.of<SelectedNoteModel>(context, listen: false);

    GlobalState.detailPageChangeNotifier =
        Provider.of<DetailPageChangeNotifier>(context, listen: false);

    GlobalState.reusablePageOpenOrCloseNotifier =
        Provider.of<ReusablePageOpenOrCloseNotifier>(context, listen: false);

    GlobalState.reusablePageChangeNotifier =
        Provider.of<ReusablePageChangeNotifier>(context, listen: false);

    GlobalState.reusablePageWidthChangeNotifier =
        Provider.of<ReusablePageWidthChangeNotifier>(context, listen: false);

    GlobalState.alertDialogHeightChangeNotifier =
        Provider.of<AlertDialogHeightChangeNotifier>(context, listen: false);


  }
}




// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:seal_note/ui/common/checkboxs/RoundCheckBoxWidget.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Welcome to Flutter'),
//         ),
//         // body: RoundCheckBoxWidget(
//         //   onChanged: (value) {
//         //     var v = value;
//         //   },
//         // ),
//
//         body: ParentWidget(),
//         // body:Checkbox(value: false,onChanged: (v){},),
//       ),
//     );
//   }
// }
//
// class ParentWidget extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => ParentWidgetState();
// }
//
// class ParentWidgetState extends State<ParentWidget> {
//   var _first = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(color: Colors.red,width: 200,height: 200,);
//
//     // return WebBrowser(
//     //   initialUrl: 'https://flutter.cn/',
//     //   javascriptEnabled: true,
//     // );
//
//
//     // final Completer<WebViewController> _webViewController =
//     // Completer<WebViewController>();
//     //
//     // return Scaffold(
//     //   appBar: AppBar(
//     //     title: Text('Welcome to Flutter2'),
//     //   ),
//     //   body: WebView(
//     //     initialUrl: 'https://www.xiaoe-tech.com',
//     //     javascriptMode: JavascriptMode.unrestricted,
//     //     onWebViewCreated: (webViewController) {
//     //       _webViewController.complete(webViewController);//>>completer example>>how to use completer
//     //     },
//     //   ),
//     //   floatingActionButton: FutureBuilder<WebViewController>(
//     //     future: _webViewController.future,
//     //     builder: (ctx, webViewController) {
//     //       if (webViewController.hasData) {
//     //         return FloatingActionButton(
//     //           child: Icon(Icons.add),
//     //           onPressed: () {
//     //             webViewController.data.loadUrl('http://www.baidu.com');
//     //           },
//     //         );
//     //       }
//     //
//     //       return Container();
//     //     },
//     //   ),
//     // );
//
//     // return Column(children: [
//     //   CupertinoButton(
//     //     child: Text('Click Me'),
//     //     color: Colors.blue,
//     //     onPressed: () {
//     //       setState(() {
//     //         if (_first) {
//     //           _first = false;
//     //         } else {
//     //           _first = true;
//     //         }
//     //       });
//     //     },
//     //   ),
//     //   Container(
//     //     child: AnimatedCrossFade(
//     //       crossFadeState:
//     //           _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
//     //       duration: const Duration(milliseconds: 500),
//     //       firstChild: Container(
//     //         child: Text('I am first'),
//     //       ),
//     //       secondChild: Container(
//     //         child: Text('I am second'),
//     //       ),
//     //     ),
//     //   ),
//     // ]);
//   }
// }
