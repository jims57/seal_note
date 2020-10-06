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
    // var d = double.negativeInfinity;
    // var b = (d<0);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MasterDetailPage(
        key: GlobalState.masterDetailPageState,
      ),
    );
  }
}
