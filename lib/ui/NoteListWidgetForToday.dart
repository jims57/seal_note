import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

import 'NoteDetailPage.dart';

class NoteListWidgetForToday extends StatefulWidget {
  @override
  _NoteListWidgetForTodayState createState() => _NoteListWidgetForTodayState();
}

class _NoteListWidgetForTodayState extends State<NoteListWidgetForToday> {
  GlobalKey _refreshKey = GlobalKey<RefreshIndicatorState>();
  List<String> _noteList = List.generate(20, (index) {
    return '香港国安法落地${index + 1}';
  });
//  List<String> _noteList = List();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getRefresh,
      child: (_noteList.length == 0 ? ListView.builder(itemCount: 1,itemBuilder: (context,index)=>Text('No Data')): ListView.builder(
//        key: _refreshKey,
        itemCount: _noteList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(top: 5.0, left: 8.0, right: 8.0),
              child: Container(
                child: Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.only(
                        top: 15.0, bottom: 15, left: 10.0, right: 10.0),
                    title: Text(
//                      '香港国安法落地施行以来，众多香港市民感到振奋，认为这部法律定能带领香港社会从暴乱失序回到发展正轨。全国政协委员、香港新活力青年智库总监杨志红在接受光明日报记者采访时说：“香港国安法符合香港市民根本利益，有利于香港社会重建秩序、重启信心，是对香港长治久安、繁荣稳定的坚强护佑。',
//                        '香港国安法落地',
                        _noteList[index],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w400)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '自2019年发生“修例风波”以来，香港各行各业深受其害，很多家庭收入锐减，都盼着尽快止暴制乱。杨志红痛心地说：“这一年的社会风波，暴露出香港在维护国家安全上存在巨大风险，使‘一国两制’香港实践遭遇前所未有的严峻挑战。',
//                        '自2019年发生“修例风波”以来',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '应30分钟前复习',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 10.0),
                              ),
                              Text(
                                /**/
                                '进度：4/7',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 10.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 1.1,
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            onTap: () {
              GlobalState.selectedNoteModel.id = index;

              if (GlobalState.screenType == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoteDetailPage()),
                );
              }
            },
          );
        },
      )),
    );
  }

  Future<Null> _getRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    Random random = Random();

    setState(() {
      var _newNoteList = List.generate(
          random.nextInt(5),
              (i) =>
          "【新加载】香港国安法落地$i "); //>>list generate>>list generate item>>generate item>>random get data

//      _noteList.insertAll(0, _newNoteList);
      _noteList = _newNoteList;
    });
  }
}
