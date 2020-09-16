import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/NoteDetailWidget.dart';
import 'package:seal_note/ui/common/AppBarBackButtonWidget.dart';
import 'package:seal_note/ui/common/AppBarWidget.dart';
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

  // Folder option items
  double _folderOptionCaptionSize = 16.0;
  double _folderOptionCaptionTitleHeight = 40.0;

  @override
  void initState() {
    GlobalState.noteListPageContext = context;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        // Note list app bar
        leadingChildren: [
          // new app bar back button widget
          AppBarBackButtonWidget(
              textWidth: 50.0,
              title: '文件夹', // Folder back button
              onTap: () {
                GlobalState.isHandlingFolderPage = true;
                GlobalState.isInFolderPage = true;
                GlobalState.masterDetailPageState.currentState
                    .updatePageShowAndHide(shouldTriggerSetState: true);
              }),
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
                // bottom modal window

                barrierColor: Colors.black12,
                // barrierColor: Colors.blue,
                backgroundColor: Colors.transparent,
                context: context,
                // isScrollControlled: true,
                builder: (BuildContext context) {
                  return FractionallySizedBox(
                    heightFactor: (GlobalState.screenType == 1)
                        ? 0.7
                        : ((GlobalState.screenType == 2) ? 1.4 : 0.6),
                    child: Container(
                      // Bottom modal window container
                      // width: 50,
                      // height: 150, // Window height setting
                      // height: GlobalState.folderOptionItemHeight * 5+11, // Window height setting
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // color: Colors.red,

                        borderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15)),
                      ),
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            // Caption container
                            // height: 50,
                            // color: Colors.green,
                            // color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  // Line on caption container
                                  margin: const EdgeInsets.only(
                                      top: 5.0, bottom: 0.0),
                                  width: 35.0,
                                  height: 4.0,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    // color: Colors.yellow,
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height:
                                                      _folderOptionCaptionTitleHeight,
                                                  // color: Colors.transparent,
                                                  color: Colors.yellow,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0),
                                                  child: Icon(
                                                    Icons.keyboard_arrow_left,
                                                    color:
                                                        GlobalState.themeColor,
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
                                            child: SizedBox(
                                          // width: 160,
                                          child: Text(
                                            '文件夹选项',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize:
                                                  _folderOptionCaptionSize,
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
                                          height:
                                              _folderOptionCaptionTitleHeight,
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
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
                            // height: 150,
                            //   height: 10,
                            width: double.infinity,

                            // child: Container(color: Colors.grey,),
                            // child: Container(height: 100,color: Colors.grey,),
                            // child: Text('d'),
                            child: MaterialApp(
                              debugShowCheckedModeBanner: false,
                              home: Scaffold(
                                body: FolderOptionListWidget(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  // return Container( // Bottom modal window container
                  //   // width: 50,
                  //   // height: 150, // Window height setting
                  //   // height: GlobalState.folderOptionItemHeight * 5+11, // Window height setting
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     // color: Colors.red,
                  //
                  //     borderRadius: const BorderRadius.only(
                  //         topLeft: const Radius.circular(15),
                  //         topRight: const Radius.circular(15)),
                  //   ),
                  //   child: Column(
                  //     // mainAxisSize: MainAxisSize.max,
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Container( // Caption container
                  //         // height: 50,
                  //         // color: Colors.green,
                  //         // color: Colors.white,
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Container( // Line on caption container
                  //               margin: const EdgeInsets.only(
                  //                   top: 5.0, bottom: 0.0),
                  //               width: 35.0,
                  //               height: 4.0,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.black12,
                  //                 // color: Colors.yellow,
                  //                 borderRadius: const BorderRadius.all(
                  //                   const Radius.circular(5),
                  //                 ),
                  //               ),
                  //             ),
                  //             Row(
                  //               children: [
                  //                 // Folder option caption left button
                  //                 Expanded(
                  //                   flex: 1,
                  //                   child: GestureDetector(
                  //                     child: Consumer<AppState>(
                  //                       builder: (ctx, appState, child) {
                  //                         if (appState
                  //                             .isInFolderOptionSubPanel) {
                  //                           return Container(
                  //                               alignment: Alignment.centerLeft,
                  //                               height:
                  //                               _folderOptionCaptionTitleHeight,
                  //                               // color: Colors.transparent,
                  //                               color: Colors.yellow,
                  //                               padding: const EdgeInsets.only(
                  //                                   left: 15.0),
                  //                               child: Icon(
                  //                                 Icons.keyboard_arrow_left,
                  //                                 color: GlobalState.themeColor,
                  //                               ));
                  //                         } else {
                  //                           return Container();
                  //                         }
                  //                       },
                  //                     ),
                  //                     onTap: () {
                  //                       GlobalState.appState
                  //                           .isInFolderOptionSubPanel = false;
                  //
                  //                       Navigator.pop(GlobalState
                  //                           .folderOptionItemListPanelContext);
                  //                     },
                  //                   ),
                  //                 ),
                  //                 // Folder option caption
                  //                 Expanded(
                  //                   flex: 1,
                  //                   child: Container(
                  //                     height: _folderOptionCaptionTitleHeight,
                  //                     child: Center(
                  //                         child: Text(
                  //                           '文件夹选项',
                  //                           style: TextStyle(
                  //                               fontSize: _folderOptionCaptionSize,
                  //                               fontWeight: FontWeight.w400),
                  //                         )),
                  //                   ),
                  //                 ),
                  //                 // Folder option caption finish button
                  //                 Expanded(
                  //                   flex: 1,
                  //                   child: GestureDetector(
                  //                     child: Container(
                  //                       color: Colors.transparent,
                  //                       height: _folderOptionCaptionTitleHeight,
                  //                       alignment: Alignment.centerRight,
                  //                       padding:
                  //                       const EdgeInsets.only(right: 15.0),
                  //                       child: Text(
                  //                         '完成',
                  //                         style: TextStyle(
                  //                             color: GlobalState.themeColor),
                  //                       ),
                  //                     ),
                  //                     onTap: () {
                  //                       Navigator.pop(context);
                  //                     },
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //             Divider(
                  //               color: Colors.black12,
                  //               height: 1,
                  //               thickness: 1,
                  //               indent: 0,
                  //               endIndent: 0,
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //
                  //       SizedBox(
                  //         height: GlobalState.folderOptionItemHeight * 4+10,
                  //           // height: 150,
                  //         //   height: 10,
                  //           width: double.infinity,
                  //
                  //            // child: Container(color: Colors.grey,),
                  //            // child: Container(height: 100,color: Colors.grey,),
                  //            // child: Text('d'),
                  //         child: MaterialApp(
                  //             debugShowCheckedModeBanner: false,
                  //             home: Scaffold(
                  //               body: FolderOptionListWidget(),
                  //             ),
                  //           ),
                  //       ),
                  //     ],
                  //   ),
                  // );
                },
              );

              // showModalBottomSheet<void>( // bottom modal window
              //   barrierColor: Colors.black12,
              //   backgroundColor: Colors.transparent,
              //   context: context,
              //   builder: (BuildContext context) {
              //     return Container( // Bottom modal window container
              //       // width: 50,
              //       height: 600,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         // color: Colors.red,
              //         borderRadius: const BorderRadius.only(
              //             topLeft: const Radius.circular(15),
              //             topRight: const Radius.circular(15)),
              //       ),
              //       child: Column(
              //         // mainAxisSize: MainAxisSize.max,
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Container( // Caption container
              //             // height: 50,
              //             // color: Colors.green,
              //             // color: Colors.white,
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Container( // Line on caption container
              //                   margin: const EdgeInsets.only(
              //                       top: 5.0, bottom: 0.0),
              //                   width: 35.0,
              //                   height: 4.0,
              //                   decoration: BoxDecoration(
              //                     color: Colors.black12,
              //                     // color: Colors.yellow,
              //                     borderRadius: const BorderRadius.all(
              //                       const Radius.circular(5),
              //                     ),
              //                   ),
              //                 ),
              //                 Row(
              //                   children: [
              //                     // Folder option caption left button
              //                     Expanded(
              //                       flex: 1,
              //                       child: GestureDetector(
              //                         child: Consumer<AppState>(
              //                           builder: (ctx, appState, child) {
              //                             if (appState
              //                                 .isInFolderOptionSubPanel) {
              //                               return Container(
              //                                   alignment: Alignment.centerLeft,
              //                                   height:
              //                                       _folderOptionCaptionTitleHeight,
              //                                   // color: Colors.transparent,
              //                                   color: Colors.yellow,
              //                                   padding: const EdgeInsets.only(
              //                                       left: 15.0),
              //                                   child: Icon(
              //                                     Icons.keyboard_arrow_left,
              //                                     color: GlobalState.themeColor,
              //                                   ));
              //                             } else {
              //                               return Container();
              //                             }
              //                           },
              //                         ),
              //                         onTap: () {
              //                           GlobalState.appState
              //                               .isInFolderOptionSubPanel = false;
              //
              //                           Navigator.pop(GlobalState
              //                               .folderOptionItemListPanelContext);
              //                         },
              //                       ),
              //                     ),
              //                     // Folder option caption
              //                     Expanded(
              //                       flex: 1,
              //                       child: Container(
              //                         height: _folderOptionCaptionTitleHeight,
              //                         child: Center(
              //                             child: Text(
              //                           '文件夹选项',
              //                           style: TextStyle(
              //                               fontSize: _folderOptionCaptionSize,
              //                               fontWeight: FontWeight.w400),
              //                         )),
              //                       ),
              //                     ),
              //                     // Folder option caption finish button
              //                     Expanded(
              //                       flex: 1,
              //                       child: GestureDetector(
              //                         child: Container(
              //                           color: Colors.transparent,
              //                           height: _folderOptionCaptionTitleHeight,
              //                           alignment: Alignment.centerRight,
              //                           padding:
              //                               const EdgeInsets.only(right: 15.0),
              //                           child: Text(
              //                             '完成',
              //                             style: TextStyle(
              //                                 color: GlobalState.themeColor),
              //                           ),
              //                         ),
              //                         onTap: () {
              //                           Navigator.pop(context);
              //                         },
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //                 Divider(
              //                   color: Colors.black12,
              //                   height: 1,
              //                   thickness: 1,
              //                   indent: 0,
              //                   endIndent: 0,
              //                 )
              //               ],
              //             ),
              //           ),
              //           SizedBox(
              //               // height: GlobalState.folderOptionItemHeight * 5,
              //               height: 500,
              //               width: double.infinity,
              //               child: MaterialApp(
              //                 debugShowCheckedModeBanner: false,
              //                 home: Scaffold(
              //                   body: FolderOptionListWidget(),
              //                 ),
              //               )),
              //         ],
              //       ),
              //     );
              //   },
              // );
            },
          ),
        ],
        title: Text('英语知识[考研必备知识点2020秋季]'),
        // title: Text('英语知识'),
        showSyncStatus: true,
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
