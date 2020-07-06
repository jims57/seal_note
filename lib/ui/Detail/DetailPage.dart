import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/EditingNoteModel.dart';

import 'DetailWidget.dart';

class DetailPage extends StatefulWidget {
  String remark = 'remark1';

  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<EditingNoteModel>(
          builder: (context, note, child) => Text('Node${note.id} Detail'),
        ),
      ),
      body: DetailWidget(),
    );
  }
}
