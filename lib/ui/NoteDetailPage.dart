import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';

import 'NoteDetailWidget.dart';

class NoteDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          ),
        ],
        title: Consumer<SelectedNoteModel>(
          builder: (ctx, note, child) {
            return Text('detail id=> ${note.id}');
          },
        ),
      ),
      body: NoteDetailWidget(),
    );
  }
}
