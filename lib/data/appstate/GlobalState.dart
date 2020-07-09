import 'package:seal_note/ui/FolderListPage.dart';
import 'package:seal_note/ui/FolderListWidget.dart';
import 'package:seal_note/ui/NoteDetailWidget.dart';
import 'package:seal_note/ui/NoteListPage.dart';
import 'package:seal_note/ui/NoteDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/ui/NoteListWidget.dart';

import 'SelectedNoteModel.dart';

class GlobalState with ChangeNotifier {
  static final GlobalState _singleton = GlobalState._internal();

  factory GlobalState() => _singleton;

  GlobalState._internal();

  // Device basic info
  static int screenType;
  static double screenWidth;
  static double screenHeight;

  // Contexts
  static BuildContext noteListPageContext;

  // Models
  static SelectedNoteModel selectedNoteModel;
}
