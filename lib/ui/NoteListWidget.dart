import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/ui/NoteListWidgetForToday.dart';

class NoteListWidget extends StatefulWidget {
  NoteListWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NoteListWidgetState();
}

class NoteListWidgetState extends State<NoteListWidget> {
  final GlobalKey<NoteListWidgetForTodayState> noteListWidgetForTodayState =
      GlobalKey<NoteListWidgetForTodayState>();

  @override
  Widget build(BuildContext context) {
    return NoteListWidgetForToday(
      key: noteListWidgetForTodayState,
    );
  }
}
