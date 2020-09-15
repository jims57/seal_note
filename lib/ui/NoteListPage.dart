import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:seal_note/ui/NoteDetailPage.dart';
import 'package:seal_note/ui/NoteDetailWidget.dart';
import 'package:seal_note/ui/common/AppBarWidget.dart';
import 'package:seal_note/util/route/SlideRightRoute.dart';

import 'FolderListPage.dart';
import 'folderOption/FolderOptionListWidget.dart';
import 'NoteListWidget.dart';

typedef void ItemSelectedCallback();

class NoteListPage extends StatefulWidget {
  NoteListPage({Key key, this.itemCount, this.onItemSelected})
      : super(key: key);

  final int itemCount;
  final ItemSelectedCallback onItemSelected;

  @override
  State<StatefulWidget> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  final GlobalKey<NoteListWidgetState> _noteListWidgetState =
      GlobalKey<NoteListWidgetState>();

  // Database _database;

  // Folder option items
  double _folderOptionCaptionSize = 16.0;
  double _folderOptionCaptionTitleHeight = 40.0;

  @override
  void initState() {
    GlobalState.noteListPageContext = context;
    // _database = Provider.of<Database>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        leadingChildren: [
          (GlobalState.screenType == 3
              ? Container()
              : IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              GlobalState.isHandlingFolderPage = true;
              GlobalState.isInFolderPage = true;
              GlobalState.masterDetailPageState.currentState.updatePageShowAndHide(shouldTriggerSetState: true);
              // Navigator.push(
              //     context, SlideRightRoute(page: FolderListPage()));
            },
          )),
          (GlobalState.screenType == 2
              ? Container()
              : Text(
            '文件夹',
            style: TextStyle(fontSize: 14.0),
          )),
        ],
        tailChildren: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            onPressed: () {
              GlobalState.appState.isInFolderOptionSubPanel = false;

              showModalBottomSheet<void>(
                barrierColor: Colors.black12,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 5.0, bottom: 0.0),
                                width: 35.0,
                                height: 4.0,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(5),
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
                                          if (appState
                                              .isInFolderOptionSubPanel) {
                                            return Container(
                                                alignment: Alignment.centerLeft,
                                                height:
                                                _folderOptionCaptionTitleHeight,
                                                color: Colors.transparent,
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Icon(
                                                  Icons.keyboard_arrow_left,
                                                  color: GlobalState.themeColor,
                                                ));
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                      onTap: () {
                                        GlobalState.appState
                                            .isInFolderOptionSubPanel = false;

                                        Navigator.pop(GlobalState
                                            .folderOptionItemListPanelContext);
                                      },
                                    ),
                                  ),
                                  // Folder option caption
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: _folderOptionCaptionTitleHeight,
                                      child: Center(
                                          child: Text(
                                            '文件夹选项',
                                            style: TextStyle(
                                                fontSize: _folderOptionCaptionSize,
                                                fontWeight: FontWeight.w400),
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
                                        padding:
                                        const EdgeInsets.only(right: 15.0),
                                        child: Text(
                                          '完成',
                                          style: TextStyle(
                                              color: GlobalState.themeColor),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
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
                        SizedBox(
                            height: GlobalState.folderOptionItemHeight * 5,
                            width: double.infinity,
                            child: MaterialApp(
                              debugShowCheckedModeBanner: false,
                              home: Scaffold(
                                body: FolderOptionListWidget(),
                              ),
                            )),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
        title: Text('英语知识'),
        leadingWidth: 90,
        tailWidth: 40,
      ),
      body: NoteListWidget(
        key: _noteListWidgetState,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          GlobalState.appState.detailPageStatus = 3;
          GlobalState.isQuillReadOnly = false;
          GlobalState.isCreatingNote = true;

          setState(() {
            GlobalState.rotationCounter += 1;
          });

          if (GlobalState.screenType == 1) {
            Navigator.of(GlobalState.noteListPageContext)
                .push(MaterialPageRoute(builder: (ctx) {
//              return NoteDetailWidget();
              return NoteDetailWidget();
            }));
          } else {}

//          _database.deleteAllNotes().then((value) {
//            _noteListWidgetState
//                .currentState.noteListWidgetForTodayState.currentState
//                .resetLoadingConfigsAfterUpdatingSqlite();
//          });
        },
      ),
    );
  }
}
