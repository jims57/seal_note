import 'dart:typed_data';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:flutter/material.dart';

import 'AppState.dart';
import 'SelectedNoteModel.dart';

class GlobalState with ChangeNotifier {
  static final GlobalState _singleton = GlobalState._internal();

  factory GlobalState() => _singleton;

  GlobalState._internal();

  // Theme
  static Color themeColor;

  // Database
  static Database database;

  // Device basic info
  static int screenType;
  static double screenWidth;
  static double screenHeight;

  // Contexts
  static BuildContext noteListPageContext;
  static BuildContext folderOptionItemListPanelContext;
  static BuildContext noteDetailPageContext;
  static BuildContext noteDetailWidgetContext;
  static BuildContext myWebViewPluginContext;

  // Models
  static SelectedNoteModel selectedNoteModel;

  // States
  static AppState appState;

  // Folder Options
  static double folderOptionItemHeight = 40.0;

  // WebView
  static FlutterWebviewPlugin flutterWebviewPlugin;

  // Photo Views
  static int firstPageIndex = 0;
  static List<Uint8List> imageDataList = List<Uint8List>();
}
