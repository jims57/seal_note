import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';
import 'package:seal_note/ui/NoteListWidgetForToday.dart';

class NoteListWidget extends StatefulWidget {
  NoteListWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NoteListWidgetState();
}

class NoteListWidgetState extends State<NoteListWidget> {
  GlobalKey<NoteListWidgetForTodayState> noteListWidgetForTodayState;
  SelectedNoteModel _selectedNoteModel;

  @override
  void initState() {
    noteListWidgetForTodayState = GlobalKey<NoteListWidgetForTodayState>();
    _selectedNoteModel = Provider.of<SelectedNoteModel>(context, listen: false);
    _selectedNoteModel.noteListWidgetForTodayState =
        noteListWidgetForTodayState;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NoteListWidgetForToday(
      key: noteListWidgetForTodayState,
    );
  }
}
