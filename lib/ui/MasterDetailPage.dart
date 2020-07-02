import 'package:flutter/material.dart';
import 'package:seal_note/ui/Detail/DetailWidget.dart';
import 'package:seal_note/ui/ItemListWidget.dart';

import 'Common/AppBarWidget.dart';
import 'Detail/DetailPage.dart';

class MasterDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MasterDetailPageState();
}

class _MasterDetailPageState extends State<MasterDetailPage> {
  bool _isLargeScreen = false;
  double _screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBarWidget(
        leadingChildren: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          Text(
            '文件夹',
            style: TextStyle(fontSize: 14.0),
          ),
        ],
        tailChildren: [
          IconButton(
              icon: Icon(
            Icons.more_horiz,
            color: Colors.white,
          )),
        ],
//        title: '英语知识英语知识',
        title: '英语知识',
        leadingWidth: 90,
        tailWidth: 40,
      ),
      body: OrientationBuilder(
        builder: (c, o) {
          _screenWidth = MediaQuery.of(context).size.width;
          if (_screenWidth > 600) {
            _isLargeScreen = true;
          } else {
            _isLargeScreen = false;
          }

          return Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ItemListWidget(
                    itemCount: 60,
                    onItemSelected: () {
                      // When it is a small screen
                      if (!_isLargeScreen) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return DetailPage();
                        }));
                      }
                    }),
              ),
              (_isLargeScreen
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
