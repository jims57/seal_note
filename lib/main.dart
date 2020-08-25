// Import packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/converter/ImageConverter.dart';

// Import custom files
import 'data/appstate/AppState.dart';
import 'data/appstate/SelectedNoteModel.dart';
import 'data/database/database.dart';
import 'data/database/dbHelper/shared.dart';

// Import widgets
import 'package:seal_note/ui/MasterDetailPage.dart';

import 'model/ImageSyncItem.dart';
import 'dart:convert';
import 'dart:typed_data';

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

//    String str = 'Hello';
//    String str2 = '';
//    print(str.isEmpty);
//    print(str2.isEmpty);

//    ImageConverter.convertUint8ListToBase64(uint8List);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MasterDetailPage(),
    );
  }
}

class Tag {
  String name;
  int quantity;

  Tag(this.name, this.quantity);

  factory Tag.fromJson(dynamic json) {
    return Tag(json['name'] as String, json['quantity'] as int);
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.quantity} }';
  }
}
