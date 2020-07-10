import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/ui/NoteListWidgetForToday.dart';

class NoteListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  @override
  Widget build(BuildContext context) {
    return NoteListWidgetForToday();
  }
}
