import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' as m;
import 'package:provider/provider.dart';

import 'data/database/database.dart';
import 'data/database/dbHelper/shared.dart';

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
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: ParentWidget(),
      ),
    );
  }
}

class ParentWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ParentWidgetState();
}

class ParentWidgetState extends State<ParentWidget> {
  String result = '';
  int id = 1;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Consumer<Database>(
        builder: (ctx, db, child) {
          return Row(
            children: [
              RaisedButton(
                child: Text('Add todo'),
                onPressed: () {
                  id += 1;

                  setState(() {
                    String d = 'd';
                    //>>moor add data>>moor insert data
                    NotesCompanion todoEntry = NotesCompanion(
                        title: m.Value('title$id'),
                        content: m.Value('content$id'));
                    db.createTodoEntry(todoEntry);

                    //>>moor get data>>moor list all data>>moor get all data
                    _getAllTodos(db);
                  });
                },
              ),
              RaisedButton(
                child: Text('Clear data'),
                onPressed: () {
                  setState(() {
                    db.deleteAllTodo();
                    _getAllTodos(db);
                  });
                },
              ),
            ],
          );
        },
      ),
      Text(result),
    ]);
  }

  void _getAllTodos(Database db) async {
    List<NoteEntry> allTodos = await db.getAllTodoEntries;

    result = '';

    allTodos.forEach((e) {
      result += 'title: ${e.title}, content: ${e.content}\n';
    });
  }
}
