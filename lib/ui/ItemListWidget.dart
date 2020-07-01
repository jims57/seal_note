import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/EditingNoteModel.dart';

typedef void ItemSelectedCallback();

class ItemListWidget extends StatefulWidget {
  ItemListWidget(
      {Key key, @required this.itemCount, @required this.onItemSelected})
      : super(key: key);

  final int itemCount;
  final ItemSelectedCallback onItemSelected;

  @override
  State<StatefulWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.itemCount,
        itemBuilder: (cxt, idx) {
          int currentIndex = idx;

          return Consumer<EditingNoteModel>(
            builder: (context, note, child) => GestureDetector(
              child: Text('I am text $currentIndex'),
              onTap: () {
                note.id = currentIndex;
                note.title = 'title $currentIndex';
                note.content = 'title $currentIndex content';
                widget.onItemSelected();
              },
            ),
          );
        });
  }
}
