// Import packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/appTools/RestartWidget.dart';
import 'package:seal_note/util/converter/ImageConverter.dart';
import 'package:seal_note/util/crypto/CryptoHandler.dart';
import 'package:seal_note/util/file/FileHandler.dart';

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
    GlobalState.myAppContext = context;
    GlobalState.masterDetailPageState = GlobalKey<MasterDetailPageState>();

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

// class MyApp extends StatelessWidget  {
//
//   @override
//   Widget build(BuildContext context) {
//     GlobalState.myAppContext = context;
//
//     // TODO: For Debug
//
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MasterDetailPage(),
//     );
//   }
// }
