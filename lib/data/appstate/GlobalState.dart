import 'package:seal_note/ui/FolderListPage.dart';
import 'package:seal_note/ui/NoteListPage.dart';
import 'package:seal_note/ui/NoteDetailPage.dart';
import 'package:flutter/material.dart';

import 'SelectedNoteModel.dart';

class GlobalState {
  static final GlobalState _singleton = GlobalState._internal();

  factory GlobalState() => _singleton;

  GlobalState._internal();

  static int screenType;

  static BuildContext noteListPageContext;

  static FolderListPage folderListPage;
  static NoteListPage noteListPage;
  static NoteDetailPage noteDetailPage;
}
