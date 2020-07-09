import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';

import 'NoteDetailPage.dart';

class NoteListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 60,
        itemBuilder: (cxt, idx) {
          int currentIndex = idx;

          return Consumer<SelectedNoteModel>(
            builder: (context, note, child) => GestureDetector(
              child: Text('I am text $currentIndex'),
              onTap: () {
                GlobalState.selectedNoteModel.id = currentIndex;

                if (GlobalState.screenType == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NoteDetailPage()),
                  );
                }
              },
            ),
          );
        });
  }
}
