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

  // Models
  static SelectedNoteModel selectedNoteModel;

  // States
  static AppState appState;

  // Folder Options
  static double folderOptionItemHeight = 40.0;
}
