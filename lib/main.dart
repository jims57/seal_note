//Import packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'data/appstate/AlertDialogHeightChangeNotifier.dart';
import 'data/appstate/AppState.dart';
import 'data/appstate/DetailPageState.dart';
import 'data/appstate/LoadingWidgetChangeNotifier.dart';
import 'data/appstate/ReusablePageChangeNotifier.dart';
import 'data/appstate/ReusablePageOpenOrCloseNotifier.dart';
import 'data/appstate/ReusablePageWidthChangeNotifier.dart';
import 'data/appstate/SelectedNoteModel.dart';
import 'data/appstate/ViewAgreementPageChangeNotifier.dart';
import 'data/database/database.dart';
import 'data/database/dbHelper/shared.dart';
import 'package:seal_note/ui/MasterDetailPage.dart';

import 'model/errorCodes/ErrorCodeModel.dart';

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
      ChangeNotifierProvider<LoadingWidgetChangeNotifier>(
        create: (context) => LoadingWidgetChangeNotifier(),
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
    // init tables // init app data // initialize data
    GlobalState.database.isDbInitialized().then((isDbInitialized) async {
      if (!isDbInitialized) {
        // If the db isn't initialized, we need to insert basic data
        // var now = TimeHandler.getNowForLocal();
        ResponseModel response;

        // Initialize users // init users
        var usersCompanionList = <UsersCompanion>[];
        usersCompanionList.add(
          UsersCompanion(
            id: Value(GlobalState.currentUserId),
            userName: Value('user'),
          ),
        );
        usersCompanionList.add(
          UsersCompanion(
            id: Value(GlobalState.beginIdForUserOperationInDB),
            userName: Value('xxxx'),
          ),
        );
        response = await GlobalState.database
            .upsertUsersInBatch(usersCompanionList: usersCompanionList);

        // Initialize folders // init folders
        if (response.code == ErrorCodeModel.SUCCESS_CODE) {
          var foldersCompanionList = <FoldersCompanion>[];
          foldersCompanionList.add(
            FoldersCompanion(
              id: Value(GlobalState.defaultFolderIdForToday),
              name: Value(GlobalState.defaultFolderNameForToday),
              order: Value(1),
              isDefaultFolder: Value(true),
            ),
          );
          foldersCompanionList.add(
            FoldersCompanion(
              id: Value(GlobalState.defaultFolderIdForAllNotes),
              name: Value(GlobalState.defaultFolderNameForAllNotes),
              order: Value(2),
              isDefaultFolder: Value(true),
            ),
          );
          foldersCompanionList.add(
            FoldersCompanion(
              id: Value(GlobalState.defaultFolderIdForDeletedFolder),
              name: Value(GlobalState.defaultFolderNameForDeletedFolder),
              order: Value(GlobalState.defaultOrderForDeletedFolder),
              isDefaultFolder: Value(true),
            ),
          );
          foldersCompanionList.add(
            FoldersCompanion(
              id: Value(GlobalState.defaultUserFolderIdForMyNotes),
              name: Value(GlobalState.defaultUserFolderNameForMyNotes),
              order: Value(3),
              isDefaultFolder: Value(false),
            ),
          );
          foldersCompanionList.add(
            FoldersCompanion(
              id: Value(GlobalState.beginIdForUserOperationInDB),
              name: Value('xxxx'),
              order: Value(3),
              isDefaultFolder: Value(false),
            ),
          );

          response = await GlobalState.database
              .upsertFoldersInBatch(foldersCompanionList: foldersCompanionList);
        }

        // Initialize notes // init notes
        if (response.code == ErrorCodeModel.SUCCESS_CODE) {
          var notesCompanionList = <NotesCompanion>[];
          notesCompanionList.add(
            NotesCompanion(
              id: Value(1),
              folderId: Value(GlobalState.defaultUserFolderIdForMyNotes),
              content: Value(
                  '&lt;p&gt;【海豚笔记介绍和使用方法】&lt;br&gt;主是图1：&lt;img id=&quot;d9ddb2824e1053b4ed1c8a3633477a07-5bf3d-001&quot; image-index=&quot;0&quot; style=&quot;width: 90%;&quot; image-extension=&quot;png&quot;&gt;&lt;br&gt;这是说明1。&lt;br&gt;这是说明2。&lt;/p&gt;'),
            ),
          );
          notesCompanionList.add(
            NotesCompanion(
              id: Value(GlobalState.beginIdForUserOperationInDB),
              folderId: Value(GlobalState.defaultUserFolderIdForMyNotes),
              content: Value('xxxx'),
            ),
          );

          response = await GlobalState.database
              .upsertNotesInBatch(notesCompanionList: notesCompanionList);
        }

        // Initialize review plans // init review plans
        if (response.code == ErrorCodeModel.SUCCESS_CODE) {
          var reviewPlansCompanionList = <ReviewPlansCompanion>[];
          reviewPlansCompanionList.add(
            ReviewPlansCompanion(
              id: Value(1),
              name: Value('五段式'),
              introduction: Value('五段式简介'),
            ),
          );
          reviewPlansCompanionList.add(
            ReviewPlansCompanion(
              id: Value(2),
              name: Value('艾宾浩斯'),
              introduction: Value('艾宾浩斯简介'),
            ),
          );
          reviewPlansCompanionList.add(
            ReviewPlansCompanion(
              id: Value(GlobalState.beginIdForUserOperationInDB),
              name: Value('xxxx'),
              introduction: Value('xxxx'),
            ),
          );

          response = await GlobalState.database.upsertReviewPlansInBatch(
              reviewPlansCompanionList: reviewPlansCompanionList);
        }

        // Initialize review plan configs // init review plan configs
        if (response.code == ErrorCodeModel.SUCCESS_CODE) {
          var reviewPlanConfigsCompanionList = <ReviewPlanConfigsCompanion>[];
          // Unit for the value. { 1 = minute, 2 = hour, 3 = day, 4 = week, 5 = month, 6 = year }
          reviewPlanConfigsCompanionList.add(
            ReviewPlanConfigsCompanion(
              id: Value(1),
              reviewPlanId: Value(1),
              order: Value(1),
              value: Value(30),
              unit: Value(1),
            ),
          );
          reviewPlanConfigsCompanionList.add(
            ReviewPlanConfigsCompanion(
              id: Value(2),
              reviewPlanId: Value(1),
              order: Value(2),
              value: Value(12),
              unit: Value(2),
            ),
          );
          reviewPlanConfigsCompanionList.add(
            ReviewPlanConfigsCompanion(
              id: Value(3),
              reviewPlanId: Value(1),
              order: Value(3),
              value: Value(3),
              unit: Value(3),
            ),
          );
          reviewPlanConfigsCompanionList.add(
            ReviewPlanConfigsCompanion(
              id: Value(4),
              reviewPlanId: Value(2),
              order: Value(1),
              value: Value(15),
              unit: Value(1),
            ),
          );
          reviewPlanConfigsCompanionList.add(
            ReviewPlanConfigsCompanion(
              id: Value(5),
              reviewPlanId: Value(2),
              order: Value(2),
              value: Value(3),
              unit: Value(2),
            ),
          );
          reviewPlanConfigsCompanionList.add(
            ReviewPlanConfigsCompanion(
              id: Value(GlobalState.beginIdForUserOperationInDB),
              reviewPlanId: Value(1),
              order: Value(1),
              value: Value(1),
              unit: Value(1),
            ),
          );

          response = await GlobalState.database.upsertReviewPlanConfigsInBatch(
              reviewPlanConfigsCompanionList: reviewPlanConfigsCompanionList);
        }

        // Initialize system infos
        if (response.code == ErrorCodeModel.SUCCESS_CODE) {
          var systemInfosCompanionList = <SystemInfosCompanion>[];
          systemInfosCompanionList.add(
            SystemInfosCompanion(
              id: Value(1),
              key: Value(GlobalState.systemInfoKeyNameForDataVersion),
              value: Value('0'),
            ),
          );
          systemInfosCompanionList.add(
            SystemInfosCompanion(
              id: Value(GlobalState.beginIdForUserOperationInDB),
              key: Value('xxxx'),
              value: Value('xxxx'),
            ),
          );

          response = await GlobalState.database.upsertSystemInfosInBatch(
              systemInfosCompanionList: systemInfosCompanionList);

          // Delete all records with begin Id
          _deleteAllRecordsWithBeginId();
        }

        // Record default folder id

        // Trigger folder list page to refresh so that the initialized folder list can be shown properly
        if (GlobalState.isFolderListPageLoaded) {
          GlobalState.noteListWidgetForTodayState.currentState.triggerSetState(
            forceToRefreshNoteListByDb: true,
          );

          GlobalState.masterDetailPageState.currentState.triggerSetState();
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

    GlobalState.loadingWidgetChangeNotifier =
        Provider.of<LoadingWidgetChangeNotifier>(context, listen: false);
  }

  void _deleteAllRecordsWithBeginId() async {
    GlobalState.database
        .deleteUser(userId: GlobalState.beginIdForUserOperationInDB);

    GlobalState.database
        .deleteFolder(folderId: GlobalState.beginIdForUserOperationInDB);

    GlobalState.database.deleteNote(GlobalState.beginIdForUserOperationInDB);

    GlobalState.database.deleteReviewPlan(
        reviewPlanId: GlobalState.beginIdForUserOperationInDB);

    GlobalState.database.deleteReviewPlanConfig(
        reviewPlanConfigId: GlobalState.beginIdForUserOperationInDB);

    GlobalState.database.deleteSystemInfo(
        systemInfoId: GlobalState.beginIdForUserOperationInDB);
  }
}

// // Test main
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
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
//         body: ParentWidget(),
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
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       CupertinoButton(
//         child: Text('Click Me'),
//         color: Colors.blue,
//         onPressed: () {},
//       )
//     ]);
//   }
// }
