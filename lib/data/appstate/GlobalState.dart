import 'package:seal_note/ui/FolderListPage.dart';
import 'package:seal_note/ui/NoteDetailWidget.dart';
import 'package:seal_note/ui/NoteListPage.dart';
import 'package:seal_note/ui/NoteDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/ui/NoteListWidget.dart';

import 'SelectedNoteModel.dart';

class GlobalState {
  static final GlobalState _singleton = GlobalState._internal();

  factory GlobalState() => _singleton;

  GlobalState._internal();

  // Device basic info
  static int screenType;
  static double screenWidth;
  static double screenHeight;

  // Contexts
  static BuildContext noteListPageContext;

  // Pages and Widget
  static FolderListPage folderListPage;
  static NoteListPage noteListPage;
  static NoteListWidget noteListWidget;
  static NoteDetailPage noteDetailPage;
  static NoteDetailWidget noteDetailWidget;

  // Models
  static SelectedNoteModel selectedNoteModel;
}
