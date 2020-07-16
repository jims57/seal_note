// Import packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/FolderListPage.dart';
import 'package:seal_note/ui/FolderListWidget.dart';
import 'package:seal_note/ui/NoteDetailPage.dart';
import 'package:seal_note/ui/NoteDetailWidget.dart';
import 'package:seal_note/ui/NoteListPage.dart';
import 'package:seal_note/ui/NoteListWidget.dart';

// Import custom files
import 'data/appstate/SelectedNoteModel.dart';
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
        ChangeNotifierProvider<GlobalState>(
          create: (context) => GlobalState(),
        ),
        ChangeNotifierProvider<SelectedNoteModel>(
          create: (context) => SelectedNoteModel(),
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
