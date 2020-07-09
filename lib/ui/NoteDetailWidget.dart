import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';

class NoteDetailWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoteDetailWidgetState();
}

class _NoteDetailWidgetState extends State<NoteDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedNoteModel>(
      builder: (context, note, child) {
        return Container(
          child: Text(
              'I am detail widget!\nid=>${note.id}\ntitle=>${note.title}\ncontent=>${note.content}'),
          color: Colors.green,
        );
      },
    );
  }
}
