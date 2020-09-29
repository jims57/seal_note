// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(),
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
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: 60,
//           width: 10,
//           color: Colors.red,
//           child: Text('Line 1'),
//         ),
//         AddIconButtonWidget(),
//       ],
//     );
//   }
// }
//
// class AddIconButtonWidget extends StatefulWidget {
//   @override
//   _AddIconButtonWidgetState createState() => _AddIconButtonWidgetState();
// }
//
// class _AddIconButtonWidgetState extends State<AddIconButtonWidget> {
//   OverlayEntry _overlayEntry;
//   double dValue = 5.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 100,
//       width: 200,
//       child: IconButton(
//           icon: Icon(Icons.add),
//           onPressed: () {
//             if (this._overlayEntry != null) {
//               this._overlayEntry.remove();
//             }
//
//             dValue += 5.0;
//
//             this._overlayEntry = this._createOverlayEntry();
//             Overlay.of(context).insert(this._overlayEntry);
//           }),
//     );
//   }
//
//   OverlayEntry _createOverlayEntry() {
//     RenderBox renderBox = context.findRenderObject();
//     var size = renderBox.size;
//     var offset = renderBox.localToGlobal(Offset.zero);
//
//     return OverlayEntry(
//         // builder: (context) => Container(
//         builder: (context) => Positioned(
//               height: 200,
//               width: 100,
//               top: offset.dy + size.height,
//               left: offset.dx + size.width / 2 + dValue,
//               child: Material(
//                 elevation: 4.0,
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   shrinkWrap: true,
//                   children: <Widget>[
//                     ListTile(
//                       title: Text('Syria'),
//                     ),
//                     ListTile(
//                       title: Text('Lebanon'),
//                     )
//                   ],
//                 ),
//               ),
//             ));
//   }
// }

//Import packages
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
