//Import packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Import database files
import 'data/database/database.dart';
import 'data/database/dbHelper/shared.dart';

//Import widgets
import 'package:seal_note/ui/MasterDetailPage.dart';

void main() => runApp(
      Provider<Database>(
        create: (context) => constructDb(),
        child: MyApp(),
        dispose: (context, db) => db.close(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MasterDetailPage(),
    );
  }
}

