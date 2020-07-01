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
  double _screenWidth = 0;
  double _leadingWidth = 110;
  double _tailWidth = 30;
  double _offsetToLeft = 80;

  @override
  Widget build(BuildContext context) {
//    double _offsetToLeft = (_leadingWidth-_tailWidth);
    _screenWidth = MediaQuery.of(context).size.width;

    double _titleWidth =
        _getAppBarTitleWidth(_screenWidth, _leadingWidth, _tailWidth);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: _leadingWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  Text('文件夹'),
                ],
              ),
            ),
            Container(
              color: Colors.green,
              width: _titleWidth,
              padding: const EdgeInsets.only(left: 5.0, right: 5),
              child: Container(
//                alignment: Alignment.center,
//                width: _titleWidth,
                padding: EdgeInsets.only(right: _offsetToLeft),
                color: Colors.deepPurpleAccent,
                child: Center(
                  child: Text(
//                    '英语知识英语知识英语知识英语知识英语知识英语知识英语知识英语知识英语知识英语知识英语知识英语知识知识英语知识英语知识英语知识英语知识知识英语知识英语知识英语知识英语知识知识英语知识英语知识英语知识英语知识'),
                      '英语知识'),
                ),
              ),
            ),
            Container(
              color: Colors.amber,
              width: _tailWidth,
              child: Icon(Icons.more_horiz),
            )
          ],
        ),
        titleSpacing: 0.0,
//        centerTitle: true, //>>center title>>center appbar title
      ),
      body: OrientationBuilder(
        builder: (c, o) {
          _screenWidth = MediaQuery.of(context).size.width;
          if (_screenWidth > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }

          return Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ItemListWidget(
                    itemCount: 60,
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

double _getAppBarTitleWidth(
    double screenWidth, double leadingWidth, double tailWidth) {
  return (screenWidth - leadingWidth - tailWidth);
}
