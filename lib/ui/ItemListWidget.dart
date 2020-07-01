import 'package:flutter/material.dart';

typedef void ItemSelectedCallback(int index);

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

          return GestureDetector(
            child: Text('I am text $currentIndex'),
            onTap: () {
              widget.onItemSelected(currentIndex);
            },
          );
        });
  }
}
