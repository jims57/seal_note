import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class TestPageWidget extends StatefulWidget {
  @override
  _TestPageWidgetState createState() => _TestPageWidgetState();
}

class _TestPageWidgetState extends State<TestPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                GlobalState.isInNoteDetailPage = false;
              })
        ],
      ),
      body: Text('I am Test page'),
    );
  }
}
