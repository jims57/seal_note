import 'package:flutter/material.dart';
import 'package:seal_note/function/checkScreenType.dart';
import 'package:seal_note/ui/NoteListWidget.dart';

import 'Common/AppBarWidget.dart';
import 'Detail/DetailPage.dart';

class MasterDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MasterDetailPageState();
}

class _MasterDetailPageState extends State<MasterDetailPage> {
  int _screenType = 1; // 1 = Small, 2 = Medium, 3 = Large
  double _screenWidth = 0;
  double _screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _screenType = checkScreenType(_screenWidth);

    return Scaffold(
//      appBar: AppBarWidget(
//      leadingChildren: [
//        IconButton(
//          icon: Icon(
//            Icons.arrow_back_ios,
//            color: Colors.white,
//          ),
//        ),
//        Text(
//          '文件夹',
//          style: TextStyle(fontSize: 14.0),
//        ),
//      ],
//      tailChildren: [
//        IconButton(
//            icon: Icon(
//              Icons.more_horiz,
//              color: Colors.white,
//            )),
//      ],
////        title: '英语知识英语知识',
//      title: '$_screenWidth',
//      leadingWidth: 90,
//      tailWidth: 40,
//    ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Row(
            children: [
              Container(
                child: (_screenType == 3
                    ? Container(
                        width: 195,
                        height: _screenHeight,
                        color: Colors.red,
                        child: Text('C1'),
                      )
                    : Container()),
              ),
              Container(
                width: (_screenType == 1 ? _screenWidth : 220),
                height: _screenHeight,
                color: Colors.green,
                child: NoteListWidget(
                  itemCount: 60,
                ),
              ),
              Expanded(
                child: (_screenType == 1
                    ? Container()
                    : Container(
                        height: _screenHeight,
                        child: Container(
                          color: Colors.blue,
                          child: Text('C3'),
                        ),
                      )),
              )
            ],
          );
        },
      ),
    );
  }
}
