// import 'package:flutter/material.dart';
// import 'dart:async';
//
// void main() {
//   runApp(
//     MaterialApp(
//       home: MyWidget(),
//     ),
//   );
// }
//
// class MyWidget extends StatefulWidget {
//   State createState() => new _MyWidgetState();
// }
//
// class _MyWidgetState extends State<MyWidget> {
//   Timer _timer;
//   int _start = 10;
//
//   void startTimer() {
//     if (_timer != null) {
//       _timer.cancel();
//       _timer = null;
//     } else {
//       _timer = new Timer.periodic(
//         const Duration(milliseconds: 500),
//         (Timer timer) => setState(
//           () {
//             if (_start < 1) {
//               timer.cancel();
//             } else {
//               _start = _start - 1;
//             }
//           },
//         ),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: AppBar(title: Text("Timer test")),
//       body: Column(
//         children: <Widget>[
//           RaisedButton(
//             onPressed: () {
//               startTimer();
//             },
//             child: Text("start"),
//           ),
//           Text("$_start")
//         ],
//       ),
//     );
//   }
// }

//
//Import packages
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

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

    GlobalState.myAppContext = context;
    GlobalState.masterDetailPageState = GlobalKey<MasterDetailPageState>();

    // Check if the db is initialized or not
    GlobalState.database.isDbInitialized().then((isDbInitialized) {
      if (!isDbInitialized) {
        // If the db isn't initialized, we need to insert basic data
        var folderEntryList = List<FolderEntry>();
        folderEntryList.add(FolderEntry(
            id: null,
            name: '今天',
            order: 1,
            numberToShow: 28,
            isDefaultFolder: true,
            created: null));

        folderEntryList.add(FolderEntry(
            id: null,
            name: '全部笔记',
            order: 2,
            numberToShow: 99,
            isDefaultFolder: true,
            created: null));

        folderEntryList.add(FolderEntry(
            id: null,
            name: '我的笔记',
            order: 3,
            numberToShow: 23,
            isDefaultFolder: false,
            created: null));

        folderEntryList.add(FolderEntry(
            id: null,
            name: '英语知识',
            order: 5,
            numberToShow: 18,
            isDefaultFolder: false,
            created: null));

        folderEntryList.add(FolderEntry(
            id: null,
            name: '编程知识',
            order: 4,
            numberToShow: 8,
            isDefaultFolder: false,
            created: null));

        folderEntryList.add(FolderEntry(
            id: null,
            name: '健身知识',
            order: 6,
            numberToShow: 28,
            isDefaultFolder: false,
            created: null));

        folderEntryList.add(FolderEntry(
            id: null,
            name: '删除笔记',
            order: 7,
            numberToShow: 2,
            isDefaultFolder: true,
            created: null));

        GlobalState.database.upsertFoldersInBatch(folderEntryList);

        // Trigger folder list page to refresh so that the initialized folder list can be shown properly
        if (GlobalState.isFolderListPageLoaded) {
          GlobalState.folderListWidgetState.currentState
              .triggerSetState(forceToFetchFoldersFromDB: true);
        }
      }
    });

    // Check if the db exists or not, if not, we need to initialize data for folders
    // FileHandler.checkIfFileExistsOrNot(GlobalState.dbNameForMobilePlatform)
    //     .then((isExisting) {
    //       if(!isExisting){ // When the db doesn't exist, we
    //
    //       }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MasterDetailPage(
        key: GlobalState.masterDetailPageState,
      ),
    );
  }
}
