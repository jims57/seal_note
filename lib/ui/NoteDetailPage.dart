import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/DetailPageState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';

import 'NoteDetailWidget.dart';

class NoteDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  @override
  void initState() {
    super.initState();

//    GlobalState.noteDetailPageContext = context;
  }

  @override
  Widget build(BuildContext context) {
    // return NoteDetailWidget();
    // if(GlobalState.webViewScaffold ==null) {
    //   return NoteDetailWidget();
    // } else {
    //   return GlobalState.webViewScaffold;
    // }

    return Scaffold(
//      appBar: AppBar(
//        title: Text('Detail page'),
//        actions: [IconButton(icon: Icon(Icons.edit), onPressed: () {
//          GlobalState.appState.detailPageStatus = 2;
//        })],
//      ),
      body: Consumer<DetailPageChangeNotifier>(
        builder: (ctx, detailPageChangeNotifier, child) {
          if (GlobalState.webViewScaffold != null) {
            // return GlobalState.webViewScaffold;
            return NoteDetailWidget();
          } else {
            return NoteDetailWidget();
          }
          // return NoteDetailWidget();
        },
      ),
//       body: Consumer<AppState>(
//         builder: (ctx, appState, child) {
//           switch (appState.detailPageStatus) {
//             case 1:
//               {
//                 if (GlobalState.webViewScaffold != null) {
//                   // return GlobalState.webViewScaffold;
//                   // return Text('old note in read mode with webViewScaffold');
//                   return NoteDetailWidget();
//                 } else {
//                   // return Text('old note in read mode');
//                   return NoteDetailWidget();
//                 }
//                 // old note in read mode
//
//               }
//               break;
//
//             case 2:
//               {
//                 // old note in edit mode
//                 return Text('old note in edit mode');
//               }
//               break;
//
//             default:
//               {
//                 // creating a new note
//                 return Text('creating a new note');
//               }
//               break;
//           }
//         },
//       ),
    );

//    return Scaffold(
////      body: NoteDetailWidget(),
//      body: Text('detail'),
//    );
  }
}
