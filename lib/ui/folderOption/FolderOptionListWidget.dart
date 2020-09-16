import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

import '../NoteDetailPage.dart';

class FolderOptionListWidget extends StatefulWidget {
  @override
  _FolderOptionSliverChildListDelegateState createState() =>
      _FolderOptionSliverChildListDelegateState();
}

class _FolderOptionSliverChildListDelegateState
    extends State<FolderOptionListWidget> {
  // Folder option items
  double _folderOptionIconSize = 18.0;
  double _folderOptionFontSize = 14.0;
  Color _folderOptionColor = Colors.black;
  Color _folderOptionColorForDelete = Colors.red;

  @override
  void initState() {
    GlobalState.folderOptionItemListPanelContext = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Review plan option
                GestureDetector(
                  child: Container(
                    // color: Colors.transparent,
                    // color: Colors.red,
                    color: Colors.white,
                    height: GlobalState.folderOptionItemHeight,
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(children: [
                            Icon(
                              Icons.calendar_today,
                              color: _folderOptionColor,
                              size: _folderOptionIconSize,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '复习计划',
                                style: TextStyle(
                                    color: _folderOptionColor,
                                    fontSize: _folderOptionFontSize),
                              ),
                            )
                          ]),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 14.0,
                        )
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
                // Order option
                GestureDetector(
                  child: Container(
                    // color: Colors.transparent,
                    color: Colors.white,
                    height: GlobalState.folderOptionItemHeight,
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(children: [
                            Icon(
                              Icons.sort_by_alpha,
                              color: _folderOptionColor,
                              size: _folderOptionIconSize,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '排序',
                                style: TextStyle(
                                    color: _folderOptionColor,
                                    fontSize: _folderOptionFontSize),
                              ),
                            )
                          ]),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 14.0,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    GlobalState.appState.isInFolderOptionSubPanel = true;

                    Navigator.of(GlobalState.folderOptionItemListPanelContext)
                        .push(MaterialPageRoute(builder: (c1) {
                      return NoteDetailPage();
                    }));
                  },
                ),
                // Rename option
                GestureDetector(
                  child: Container(
                    // color: Colors.transparent,
                    color: Colors.white,
                    height: GlobalState.folderOptionItemHeight,
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(children: [
                            Icon(
                              Icons.credit_card,
                              color: _folderOptionColor,
                              size: _folderOptionIconSize,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '重新命名',
                                style: TextStyle(
                                    color: _folderOptionColor,
                                    fontSize: _folderOptionFontSize),
                              ),
                            )
                          ]),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 14.0,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
                // Edit option
                GestureDetector(
                  child: Container(
                    // color: Colors.transparent,
                    color: Colors.white,
                    height: GlobalState.folderOptionItemHeight,
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(children: [
                            Icon(
                              Icons.edit,
                              color: _folderOptionColor,
                              size: _folderOptionIconSize,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '编辑',
                                style: TextStyle(
                                    color: _folderOptionColor,
                                    fontSize: _folderOptionFontSize),
                              ),
                            )
                          ]),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 14.0,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                  ),
                  onTap: () {},
                ),

                // Delete folder option
                GestureDetector(
                  child: Container(
                    // color: Colors.transparent,
                    color: Colors.white,
                    height: GlobalState.folderOptionItemHeight,
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(children: [
                            Icon(
                              Icons.delete_outline,
                              color: _folderOptionColorForDelete,
                              size: _folderOptionIconSize,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '删除文件夹',
                                style: TextStyle(
                                    color: _folderOptionColorForDelete,
                                    fontSize: _folderOptionFontSize),
                              ),
                            )
                          ]),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 14.0,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
