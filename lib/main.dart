// Import packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

// Import custom files
import 'data/appstate/AppState.dart';
import 'data/appstate/SelectedNoteModel.dart';
import 'data/database/database.dart';
import 'data/database/dbHelper/shared.dart';

// Import widgets
import 'package:seal_note/ui/MasterDetailPage.dart';

import 'model/ImageSyncItem.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      Provider<Database>(
        create: (context) => constructDb(),
        dispose: (context, db) => db.close(),
      ),
//      Provider<GlobalState>(
//        create: (context) => GlobalState(),
//      ),
      ChangeNotifierProvider<SelectedNoteModel>(
        create: (context) => SelectedNoteModel(),
      ),
      ChangeNotifierProvider<AppState>(
        create: (context) => AppState(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<ImageSyncItem> imageSyncItemList = new List<ImageSyncItem>();
    imageSyncItemList.add(ImageSyncItem(imageId: '20',imageIndex: 2,base64: 'b20'));
    imageSyncItemList.add(ImageSyncItem(imageId: '10',imageIndex: 1,base64: 'b10'));
    imageSyncItemList.add(ImageSyncItem(imageId: '30',imageIndex: 3,base64: 'b30'));

    //someObjects.sort((a, b) => a.someProperty.compareTo(b.someProperty));
    imageSyncItemList.sort((a,b) =>a.imageIndex.compareTo(b.imageIndex));

    var s = 's';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MasterDetailPage(),
    );
  }
}
