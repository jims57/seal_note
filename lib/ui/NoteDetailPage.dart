import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';

import 'NoteDetailWidget.dart';

class NoteDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  _NoteDetailPageState() {
    String s = 's';
  }

  SelectedNoteModel _selectedNoteModel;

  @override
  void initState() {

    _selectedNoteModel = Provider.of<SelectedNoteModel>(context,listen: false);
    String s = 'a';
  }

  @override
  Widget build(BuildContext context) {
//    return Text('NoteD');

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
          builder: (context, note, child) => Text('Node${note.id} Detail'),
        ),
//      title: Text('title=>${_selectedNoteModel.id}'),
      ),
      body: DetailWidget(),
    );
  }
}
