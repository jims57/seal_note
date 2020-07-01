import 'package:flutter/material.dart';
import 'package:seal_note/ui/ItemListWidget.dart';

class MasterDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MasterDetailPageState();
}

class _MasterDetailPageState extends State<MasterDetailPage> {
  bool isLargeScreen = false;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('海豚笔记')),
      ),
      body: OrientationBuilder(
        builder: (c, o) {
          if (MediaQuery.of(context).size.width > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }

          return Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ItemListWidget(
                    itemCount: 10,
                    onItemSelected: (idx) {
                      setState(() {
                        selectedIndex = idx;
                      });
                    }),
              ),
              (isLargeScreen
                  ? Expanded(
                      flex: 2,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.green,
                        child: Text('Selected index is: $selectedIndex'),
                      ),
                    )
                  : Container()),
            ],
          );
        },
      ),
    );
  }
}
