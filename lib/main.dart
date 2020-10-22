//Import packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/time/TimeHandler.dart';

// Import custom files
import 'data/appstate/AppState.dart';
import 'data/appstate/DetailPageState.dart';
import 'data/appstate/SelectedNoteModel.dart';
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
    GlobalState.database = Provider.of<Database>(context, listen: false);
    GlobalState.appState = Provider.of<AppState>(context, listen: false);
    GlobalState.selectedNoteModel =
        Provider.of<SelectedNoteModel>(context, listen: false);

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
        var folderEntryList = List<FolderEntry>();
        folderEntryList.add(FolderEntry(
            id: null,
            name: '今天',
            order: 1,
            numberToShow: 28,
            isDefaultFolder: true,
            created: now,
            createdBy: GlobalState.adminUserId));
        folderEntryList.add(FolderEntry(
            id: null,
            name: '全部笔记',
            order: 2,
            numberToShow: 99,
            isDefaultFolder: true,
            created: now,
            createdBy: GlobalState.adminUserId));
        folderEntryList.add(FolderEntry(
            id: null,
            name: '我的笔记',
            order: 3,
            numberToShow: 23,
            isDefaultFolder: false,
            created: now,
            createdBy: GlobalState.adminUserId));
        folderEntryList.add(FolderEntry(
            id: null,
            name: '英语知识',
            order: 5,
            numberToShow: 18,
            isDefaultFolder: false,
            created: now,
            createdBy: GlobalState.adminUserId));
        folderEntryList.add(FolderEntry(
            id: null,
            name: '编程知识',
            order: 4,
            numberToShow: 8,
            isDefaultFolder: false,
            created: now,
            createdBy: GlobalState.adminUserId));
        folderEntryList.add(FolderEntry(
            id: null,
            name: '健身知识',
            order: 6,
            numberToShow: 28,
            isDefaultFolder: false,
            created: now,
            createdBy: GlobalState.adminUserId));
        folderEntryList.add(FolderEntry(
            id: null,
            name: '删除笔记',
            order: 7,
            numberToShow: 2,
            isDefaultFolder: true,
            created: now,
            createdBy: GlobalState.adminUserId));
        GlobalState.database.upsertFoldersInBatch(folderEntryList);

        // Initialize review plans // init review plans
        var reviewPlanEntryList = List<ReviewPlanEntry>();
        reviewPlanEntryList.add(ReviewPlanEntry(
            id: null,
            name: '五段式',
            introduction: '五段式简介',
            createdBy: GlobalState.adminUserId));
        GlobalState.database.upsertReviewPlansInBatch(reviewPlanEntryList);

        // Initialize review plan configs // init review plan configs
        var reviewPlanConfigEntryList = List<ReviewPlanConfigEntry>();
        // Unit for the value. { 1 = minute, 2 = hour, 3 = day, 4 = week, 5 = month, 6 = year }
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
        GlobalState.database
            .upsertReviewPlanConfigsInBatch(reviewPlanConfigEntryList);

        // Trigger folder list page to refresh so that the initialized folder list can be shown properly
        if (GlobalState.isFolderListPageLoaded) {
          GlobalState.folderListWidgetState.currentState
              .triggerSetState(forceToFetchFoldersFromDB: true);
        }
      } else {
        // When db is initialized

        // Check if the selected folder is a review folder or not asynchronously
        GlobalState.database
            .isReviewFolder(GlobalState.selectedFolderId)
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
    GlobalState.database.getNotesWithNullChecking(3,0).then((value) {
      var s = value;
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MasterDetailPage(
        key: GlobalState.masterDetailPageState,
      ),
    );
  }
}
