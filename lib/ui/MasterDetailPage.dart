import 'package:flutter/material.dart';
import 'package:seal_note/ui/Detail/DetailWidget.dart';
import 'package:seal_note/ui/ItemListWidget.dart';

import 'Detail/DetailPage.dart';

class MasterDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MasterDetailPageState();
}

class _MasterDetailPageState extends State<MasterDetailPage> {
  bool isLargeScreen = false;

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
                    onItemSelected: () {
                      // When it is a small screen
                      if (!isLargeScreen) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return DetailPage();
                        }));
                      }
                    }),
              ),
              (isLargeScreen
                  ? Expanded(
                      flex: 2,
                      child: DetailWidget(),
                    )
                  : Container()),
            ],
          );
        },
      ),
    );
  }
}
