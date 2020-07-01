import 'package:flutter/material.dart';

import 'DetailWidget.dart';

class DetailPage extends StatefulWidget {
  DetailPage(this.selectedIndex);

  final int selectedIndex;

  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Note${widget.selectedIndex} detail'),),
      body: DetailWidget(widget.selectedIndex),
    );
  }
}
