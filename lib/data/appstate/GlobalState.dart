import 'package:seal_note/data/database/database.dart';
import 'package:flutter/material.dart';

import 'SelectedNoteModel.dart';

class GlobalState with ChangeNotifier {
  static final GlobalState _singleton = GlobalState._internal();

  factory GlobalState() => _singleton;

  GlobalState._internal();

  // Database
  static Database database;

  // Device basic info
  static int screenType;
  static double screenWidth;
  static double screenHeight;

  // Contexts
  static BuildContext noteListPageContext;

  // Models
  static SelectedNoteModel selectedNoteModel;
}
