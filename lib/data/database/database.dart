import 'dart:developer';

import 'package:moor/moor.dart';
import 'dart:async';

import 'package:seal_note/data/appstate/GlobalState.dart';

part 'database.g.dart';

@DataClassName('UserEntry')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 200)();

  TextColumn get nickName =>
      text().withLength(min: 1, max: 200).named('nickName')();

  TextColumn get portrait => text().nullable()();

  TextColumn get mobile => text().nullable().withLength(min: 11, max: 11)();

  TextColumn get introduction => text().nullable()();

  DateTimeColumn get created =>
      dateTime().withDefault(Constant(DateTime.now()))();
}

@DataClassName('FolderEntry')
class Folders extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 200)();

  IntColumn get order => integer()();

  IntColumn get planId => integer().nullable().named('planId')();

  IntColumn get numberToShow =>
      integer().withDefault(const Constant(0)).named('numberToShow')();

  BoolColumn get isDefaultFolder =>
      boolean().withDefault(const Constant(false)).named('isDefaultFolder')();

  DateTimeColumn get created =>
      dateTime().withDefault(Constant(DateTime.now()))();

  IntColumn get createdBy =>
      integer().withDefault(const Constant(1)).named('createdBy')();

// @override
// Set<Column> get primaryKey => {id};
}

@DataClassName('NoteEntry')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get folderId =>
      integer().withDefault(const Constant(3)).named('folderId')();

  TextColumn get title => text().withLength(min: 2, max: 200)();

  TextColumn get content => text().nullable()();

  DateTimeColumn get created =>
      dateTime().withDefault(Constant(DateTime.now()))();

  DateTimeColumn get updated =>
      dateTime().nullable()();

  DateTimeColumn get nextReviewTime =>
      dateTime().nullable().named('nextReviewTime')();

  IntColumn get reviewProgress =>
      integer().nullable().named('reviewProgress')();

  IntColumn get reviewPlanId => integer().nullable().named('reviewPlanId')();

  BoolColumn get isDeleted => boolean().withDefault(const Constant(false)).named('isDeleted')();

  IntColumn get createdBy =>
      integer().withDefault(const Constant(1)).named('createdBy')();

// @override
// Set<Column> get primaryKey => {id};
}

@DataClassName('ReviewPlanEntry')
class ReviewPlans extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get introduction => text()();

  IntColumn get createdBy =>
      integer().withDefault(const Constant(1)).named('createdBy')();

// @override
// Set<Column> get primaryKey => {id};
}

@DataClassName('ReviewPlanConfigEntry')
class ReviewPlanConfigs extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get progressId => integer().named('progressId')();

  IntColumn get order => integer()();

  IntColumn get value => integer().withDefault(const Constant(1))();

  // Unit for the value. { 1 = minute, 2 = hour, 3 = day, 4 = week, 5 = month, 6 = year }
  IntColumn get unit => integer().withDefault(const Constant(1))();

  IntColumn get createdBy =>
      integer().withDefault(const Constant(1)).named('createdBy')();

// @override
// Set<Column> get primaryKey => {id};
}

@UseMoor(tables: [Users, Folders, Notes, ReviewPlans, ReviewPlanConfigs])
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  Database.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 1;

  // [Begin] Initializing db
  Future<bool> isDbInitialized() async {
    // Whether the db has been initialized

    bool isDbInitialized = true;
    FolderEntry folderEntry = await (select(folders)
      ..where((f) =>
          f.name.equals(GlobalState.defaultFolderNameForToday))..where((f) =>
          f.isDefaultFolder.equals(true)))
        .getSingle();

    if (folderEntry == null) isDbInitialized = false;

    return isDbInitialized;
  }

  Future upsertAllNotesContentByTitles(List<NoteEntry> noteEntryList) async {
    var result = await transaction(() async {
      for (var noteEntry in noteEntryList) {
        await (update(notes)
          ..where((e) => e.id.equals(noteEntry.id)))
            .write(NotesCompanion(
          // string.substring(1, 4);
          title: Value('标题${noteEntry.id}'),
          content: Value(noteEntry.title),
        ));
      }
    });

    return result;
  }

  // [End] Initializing db

  // [Begin] folders
  Future<List<FolderEntry>> getAllFolders() {
    return (select(folders)
      ..orderBy([(t) => OrderingTerm(expression: t.order)]))
        .get();
  }

  Future<void> upsertFoldersInBatch(List<FolderEntry> folderEntryList) async {
    return await batch((batch) {
      batch.insertAllOnConflictUpdate(folders, folderEntryList);
    });
  }

  // [End] folders

  // [Begin] notes
  Future<int> insertNote(NotesCompanion entry) {
    return into(notes).insert(entry);
  }

  Future<void> insertNotesInBatch(
      List<NotesCompanion> notesCompanionList) async {
    batch((batch) {
      batch.insertAll(notes, notesCompanionList);
    });
  }

  Future<void> upsertNotesInBatch(List<NoteEntry> noteEntryList) async {
    return await batch((batch) {
      batch.insertAllOnConflictUpdate(notes, noteEntryList);
    });
  }

  // Future<List<NoteEntry>> get getAllNotes => select(notes).get();

  Future<List<NoteEntry>> getNotesByPageSize(
      {@required int pageNo, @required int pageSize}) {
    // Check if it is for default folders, because we need to get specific data for default folders
    if (GlobalState.isDefaultFolderSelected) {
      // When it is for default folders
      if (GlobalState.selectedFolderName ==
          GlobalState.defaultFolderNameForToday) {
        // For Today folder

      } else if (GlobalState.selectedFolderName ==
          GlobalState.defaultFolderNameForAllNotes) {
        // For All Notes folder

        // get all notes note list
        return (select(notes)
          ..orderBy([
                (n) =>
                OrderingTerm(
                    expression: n.created, mode: OrderingMode.desc),
          ])
          ..limit(pageSize, offset: pageSize * (pageNo - 1)))
            .get();
      } else {
        // For Deleted Notes folder

      }
    } else {
      // get user folder note list
      return (select(notes)
        ..orderBy([
              (n) =>
              OrderingTerm(expression: n.created, mode: OrderingMode.desc),
        ])
        ..where((n) => n.folderId.equals(GlobalState.selectedFolderId))
        ..limit(pageSize, offset: pageSize * (pageNo - 1)))
          .get();
    }
  }

  Future<int> deleteAllNotes() {
    return (delete(notes)).go();
  }
// [End] notes
}
