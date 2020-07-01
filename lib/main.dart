// Import packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import custom files
import 'data/appstate/EditingNoteModel.dart';
import 'data/database/database.dart';
import 'data/database/dbHelper/shared.dart';

// Import widgets
import 'package:seal_note/ui/MasterDetailPage.dart';

void main() => runApp(MultiProvider(
      providers: [
        Provider<Database>(
          create: (context) => constructDb(),
          dispose: (context, db) => db.close(),
        ),
        ChangeNotifierProvider<EditingNoteModel>(
          create: (context) => EditingNoteModel(),
        ),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MasterDetailPage(),
    );
  }
}
