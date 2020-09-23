import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:after_layout/after_layout.dart';

import 'FolderListWidget.dart';

class FolderListPage extends StatefulWidget {
  FolderListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FolderListPageState();
}

class FolderListPageState extends State<FolderListPage> {
  // with AfterLayoutMixin<FolderListPage> {
  // bool _canPop = false;

  @override
  Widget build(BuildContext context) {
    // ScrollController _scrollController = ScrollController();

    // return Scaffold(
    //   body: Column(
    //     children: [
    //       Container(
    //         height: GlobalState.screenHeight -
    //             GlobalState.folderPageBottomContainerHeight,
    //         color: Colors.red,
    //         child: CustomScrollView(
    //           slivers: [
    //             SliverAppBar(
    //               title: Text("文件夹"),
    //               // collapsedHeight: 70,
    //               // expandedHeight: 90.0,
    //             ),
    //             // FolderListWidget()
    //             SliverList(
    //               delegate: SliverChildListDelegate(
    //                 getFolderItemList()
    //
    //                   // [Container(height: 500,child: FolderListWidget(),)]),
    //                   // [Container(height: 500,color: Colors.yellow,)],
    //                   ),
    //             )
    //           ],
    //         ),
    //       ),
    //       Container(
    //         height: GlobalState.folderPageBottomContainerHeight,
    //         color: Colors.green,
    //       )
    //     ],
    //   ),
    // );

    // return Scaffold(body: Container(color: Colors.red,height: 500,),);

    return Scaffold(
      body: Container(
        height: GlobalState.screenHeight,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                height: GlobalState.folderPageTopContainerHeight,
                // color: Colors.red,
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        '文件夹',
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.w500),
                      ),
                      width: GlobalState.currentFolderPageWidth / 2,
                      padding: EdgeInsets.only(left: 15.0),
                      color: Colors.blue,
                    ),
                    Container(
                      color: Colors.red,
                      width: GlobalState.currentFolderPageWidth / 2,
                    )
                  ],
                )),
            FolderListWidget(),
            Container(
              height: GlobalState.folderPageBottomContainerHeight,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  // List<GestureDetector> getFolderItemList() {
  //   List<GestureDetector> childrenWidgetList = List.generate(100, (index) {
  //     return GestureDetector(
  //       key: Key('$index'),
  //       child: ListTile(
  //         title: Center(child: Text('index=>$index')),
  //       ),
  //       onTap: () {
  //         GlobalState.isHandlingFolderPage = true;
  //         GlobalState.isInFolderPage = false;
  //         GlobalState.masterDetailPageState.currentState
  //             .updatePageShowAndHide(shouldTriggerSetState: true);
  //       },
  //     );
  //   });
  //
  //   return childrenWidgetList;

    // List<ListTile> folderItemList = List<ListTile>();
    //
    // folderItemList.add(ListTile(
    //   leading: Icon(Icons.volume_off),
    //   title: Text("Volume Off"),
    // ));
    //
    // folderItemList.add(ListTile(
    //   leading: Icon(Icons.volume_off),
    //   title: Text("Volume Off"),
    // ));
    //
    // return folderItemList;
  // }

  // @override
  // void afterFirstLayout(BuildContext context) {
  //   if (GlobalState.screenType == 3) {
  //     _canPop = Navigator.canPop(GlobalState.noteListPageContext);
  //     if (_canPop) Navigator.pop(GlobalState.noteListPageContext);
  //   }
  // }

  void triggerSetState() {
    setState(() {});
  }
}
