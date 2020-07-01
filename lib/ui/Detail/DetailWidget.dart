import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/EditingNoteModel.dart';

class DetailWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EditingNoteModel>(
      builder: (context, note, child) {
        return Text(
            'I am detail widget!\nid=>${note.id}\ntitle=>${note.title}\ncontent=>${note.content}');
      },
    );
  }
}
