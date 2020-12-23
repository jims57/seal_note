import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
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
  double _folderOptionCaptionSize = 16.0;
  double _folderOptionCaptionTitleHeight = 40.0;

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
      color: Colors.white,
      // height: GlobalState.folderOptionItemHeight * 7,
      // height: 20,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SafeArea(
                  child: Container(
                    // height: GlobalState.folderOptionItemHeight + 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:  BorderRadius.only(
                          topLeft:  Radius.circular(GlobalState.borderRadius15),
                          topRight:  Radius.circular(GlobalState.borderRadius15)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // Line on caption container
                          margin: const EdgeInsets.only(top: 5.0, bottom: 0.0),
                          width: 35.0,
                          height: 4.0,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:  BorderRadius.all(
                              Radius.circular(GlobalState.borderRadius15),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              // Folder option caption left button
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  child: Consumer<AppState>(
                                    builder: (ctx, appState, child) {
                                      if (appState.isInFolderOptionSubPanel) {
                                        return Container(
                                            alignment: Alignment.centerLeft,
                                            height: _folderOptionCaptionTitleHeight,
                                            color: Colors.transparent,
                                            // color: Colors.yellow,
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: Icon(
                                              Icons.keyboard_arrow_left,
                                              color: GlobalState.themeBlueColor,
                                            ));
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  onTap: () {
                                    GlobalState.appState.isInFolderOptionSubPanel = false;

                                    Navigator.pop(
                                        GlobalState.folderOptionItemListPanelContext);
                                  },
                                ),
                              ),
                              // Folder option caption
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: _folderOptionCaptionTitleHeight,
                                  child: Center(
                                      child: SizedBox(
                                        // width: 160,
                                        child: Text(
                                          '文件夹选项',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: _folderOptionCaptionSize,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                              // Folder option caption finish button
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  child: Container(
                                    color: Colors.transparent,
                                    height: _folderOptionCaptionTitleHeight,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Text(
                                      '完成',
                                      style: TextStyle(color: GlobalState.themeBlueColor),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(GlobalState.noteListPageContext);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black12,
                          height: 1,
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
                        )
                      ],
                    ),
                  ),
                ),
                // Review plan option
                GestureDetector(
                  child: Container(
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
                  onTap: () {
                    var s ='s';
                  },
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

                    Navigator.of(
                        GlobalState.folderOptionItemListPanelContext)
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

    return Column(
      children: [
        Container(
          height: GlobalState.folderOptionItemHeight + 10,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:  BorderRadius.only(
                topLeft:  Radius.circular(GlobalState.borderRadius15),
                topRight:  Radius.circular(GlobalState.borderRadius15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // Line on caption container
                margin: const EdgeInsets.only(top: 5.0, bottom: 0.0),
                width: 35.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius:  BorderRadius.all(
                     Radius.circular(GlobalState.borderRadius15),
                  ),
                ),
              ),
              Row(
                children: [
                  // Folder option caption left button
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      child: Consumer<AppState>(
                        builder: (ctx, appState, child) {
                          if (appState.isInFolderOptionSubPanel) {
                            return Container(
                                alignment: Alignment.centerLeft,
                                height: _folderOptionCaptionTitleHeight,
                                color: Colors.transparent,
                                // color: Colors.yellow,
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Icon(
                                  Icons.keyboard_arrow_left,
                                  color: GlobalState.themeBlueColor,
                                ));
                          } else {
                            return Container();
                          }
                        },
                      ),
                      onTap: () {
                        GlobalState.appState.isInFolderOptionSubPanel = false;

                        Navigator.pop(
                            GlobalState.folderOptionItemListPanelContext);
                      },
                    ),
                  ),
                  // Folder option caption
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: _folderOptionCaptionTitleHeight,
                      child: Center(
                          child: SizedBox(
                        // width: 160,
                        child: Text(
                          '文件夹选项',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: _folderOptionCaptionSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )),
                    ),
                  ),
                  // Folder option caption finish button
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      child: Container(
                        color: Colors.transparent,
                        height: _folderOptionCaptionTitleHeight,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Text(
                          '完成',
                          style: TextStyle(color: GlobalState.themeBlueColor),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(GlobalState.noteListPageContext);
                      },
                    ),
                  )
                ],
              ),
              Divider(
                color: Colors.black12,
                height: 1,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              )
            ],
          ),
        ),
        Container(
          color: Colors.white,
          height: GlobalState.folderOptionItemHeight * 5,
          // height: 20,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    // Review plan option
                    GestureDetector(
                      child: Container(
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
                      onTap: () {
                        var s ='s';
                      },
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

                        Navigator.of(
                                GlobalState.folderOptionItemListPanelContext)
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
        )
      ],
    );
  }
}
