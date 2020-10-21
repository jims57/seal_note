import 'dart:developer';

import 'package:moor/moor.dart';
import 'dart:async';

import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/time/TimeHandler.dart';

part 'database.g.dart';

class IsoDateTimeConverter extends TypeConverter<DateTime, String> {
  const IsoDateTimeConverter();

  @override
  DateTime mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    } else {
      return DateTime.parse(fromDb);
    }
  }

  @override
  String mapToSql(DateTime value) {
    return value?.toIso8601String();
  }
}

@DataClassName('UserEntry')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get userName =>
      text().withLength(min: 1, max: 200).named('userName')();

  TextColumn get password => text().withLength(min: 6, max: 200)();

  TextColumn get nickName =>
      text().nullable().withLength(min: 1, max: 200).named('nickName')();

  TextColumn get portrait => text().nullable()();

  TextColumn get mobile => text().nullable().withLength(min: 11, max: 11)();

  TextColumn get introduction => text().nullable()();

  TextColumn get created => text()
      // .withDefault(Constant(DateTime.now().toString()))
      .map(const IsoDateTimeConverter())();
}

@DataClassName('FolderEntry')
class Folders extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 200)();

  IntColumn get order => integer()();

  IntColumn get numberToShow =>
      integer().withDefault(const Constant(0)).named('numberToShow')();

  BoolColumn get isDefaultFolder =>
      boolean().withDefault(const Constant(false)).named('isDefaultFolder')();

  IntColumn get reviewPlanId => integer().nullable().named('reviewPlanId')();

  TextColumn get created => text()
      // .withDefault(Constant(DateTime.now().toString()))
      .map(const IsoDateTimeConverter())();

  IntColumn get createdBy =>
      integer().withDefault(const Constant(1)).named('createdBy')();
}

@DataClassName('NoteEntry')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get folderId =>
      integer().withDefault(const Constant(3)).named('folderId')();

  TextColumn get title => text().withLength(min: 2, max: 200)();

  TextColumn get content => text().nullable()();

  TextColumn get created => text().map(const IsoDateTimeConverter())();

  TextColumn get updated => text().map(const IsoDateTimeConverter())();

  TextColumn get nextReviewTime => text()
      .nullable()
      .named('nextReviewTime')
      .map(const IsoDateTimeConverter())();

  IntColumn get reviewProgressNo =>
      integer().nullable().named('reviewProgressNo')();

  BoolColumn get isReviewFinished =>
      boolean().withDefault(const Constant(false)).named('isReviewFinished')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('isDeleted')();

  IntColumn get createdBy =>
      integer().withDefault(const Constant(1)).named('createdBy')();
}

@DataClassName('ReviewPlanEntry')
class ReviewPlans extends Table {
  @override
  String get tableName => 'reviewPlans';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get introduction => text()();

  IntColumn get createdBy =>
      integer().withDefault(const Constant(1)).named('createdBy')();
}

@DataClassName('ReviewPlanConfigEntry')
class ReviewPlanConfigs extends Table {
  @override
  String get tableName => 'reviewPlanConfigs';

  IntColumn get id => integer().autoIncrement()();

  IntColumn get reviewPlanId => integer().named('reviewPlanId')();

  IntColumn get order => integer()();

  IntColumn get value => integer().withDefault(const Constant(1))();

  // Unit for the value. { 1 = minute, 2 = hour, 3 = day, 4 = week, 5 = month, 6 = year }
  IntColumn get unit => integer().withDefault(const Constant(1))();

  IntColumn get createdBy =>
      integer().withDefault(const Constant(1)).named('createdBy')();
}

@UseMoor(tables: [Users, Folders, Notes, ReviewPlans, ReviewPlanConfigs])
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  Database.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 1;

  // Testing
  // Future<List<FolderEntry>> getAllFoldersWithFields() {
  //   final folderName = folders.name;
  //   final query = selectOnly(folders)..addColumns([folderName]);
  //   var s = query.map((row) => FolderEntry(name:row.read(folderName))).get();
  //
  // }

  // Initialization related
  Future<bool> isDbInitialized() async {
    // Whether the db has been initialized

    bool isDbInitialized = true;
    FolderEntry folderEntry = await (select(folders)
          ..where((f) => f.name.equals(GlobalState.defaultFolderNameForToday))
          ..where((f) => f.isDefaultFolder.equals(true)))
        .getSingle();

    if (folderEntry == null) isDbInitialized = false;

    return isDbInitialized;
  }

  Future updateAllNotesContentByTitles(List<NoteEntry> noteEntryList) async {
    var newNoteEntryList = List<NoteEntry>();

    // upsert notes // update notes content
    for (var noteEntry in noteEntryList) {
      var now = DateTime.now().toLocal();

      var note = NoteEntry(
          id: null,
          folderId: null,
          title: '标题${noteEntry.id}',
          content: 'Content:${noteEntry.title}',
          created: now,
          updated: now,
          isDeleted: null,
          createdBy: null);

      newNoteEntryList.add(note);
    }

    var result = await transaction(() async {
      batch((batch) {
        batch.insertAll(notes, newNoteEntryList);
      });
    });

    return result;
  }

  // Users
  Future<int> insertUser(UsersCompanion usersCompanion) {
    return into(users).insert(usersCompanion);
  }

  // Folders
  Future<List<FolderEntry>> getAllFolders() {
    return (select(folders)
          ..where((f) => f.createdBy.equals(GlobalState.currentUserId))
          ..orderBy([(f) => OrderingTerm(expression: f.order)]))
        .get();
  }

  Future<bool> isReviewFolder(int folderId) async {
    var isReviewFolder = false;
    FolderEntry folderEntry = await (select(folders)
          ..where((f) => f.id.equals(folderId)))
        .getSingle();

    if (folderEntry != null && folderEntry.reviewPlanId != null) {
      isReviewFolder = true;
    }

    return isReviewFolder;
  }

  // Notes
  Future<void> upsertFoldersInBatch(List<FolderEntry> folderEntryList) async {
    return await batch((batch) {
      batch.insertAllOnConflictUpdate(folders, folderEntryList);
    });
  }

  Future<int> insertNote(NotesCompanion entry) {
    return into(notes).insert(entry);
  }

  Future<void> insertNotesInBatch(List<NoteEntry> noteEntryList) async {
    batch((batch) {
      batch.insertAll(notes, noteEntryList);
    });
  }

  Future<void> upsertNotesInBatch(List<NoteEntry> noteEntryList) async {
    return await batch((batch) {
      batch.insertAllOnConflictUpdate(notes, noteEntryList);
    });
  }

  Future<List<NoteEntry>> getNotesByPageSize(
      {@required int pageNo, @required int pageSize}) {
    // Check if it is for default folders, because we need to get specific data for default folders

    if (GlobalState.isDefaultFolderSelected) {
      // When it is for default
      // get today note list item // get today data from sqlite
      // get today data // show today note list
      // show today note data
      if (GlobalState.selectedFolderName ==
          GlobalState.defaultFolderNameForToday) {
        // For Today folder
        var now = TimeHandler.getNowForLocal();

        String todayDateString =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

        return (select(notes)
              ..where((n) => n.isDeleted.equals(false))
              ..where((n) => n.nextReviewTime.like('$todayDateString%'))
              ..where((n) => n.isReviewFinished.equals(false))
              ..where((n) => n.createdBy.equals(GlobalState.currentUserId))
              ..orderBy([
                (n) => OrderingTerm(
                    expression: n.nextReviewTime, mode: OrderingMode.asc),
                (n) => OrderingTerm(expression: n.id, mode: OrderingMode.desc),
              ])
              ..limit(pageSize, offset: pageSize * (pageNo - 1)))
            .get();
      } else if (GlobalState.selectedFolderName ==
          GlobalState.defaultFolderNameForAllNotes) {
        // For All Notes folder

        // get all notes note list
        return (select(notes)
              ..where((n) => n.isDeleted.equals(false))
              ..where((n) => n.createdBy.equals(GlobalState.currentUserId))
              ..orderBy([
                (n) => OrderingTerm(
                    expression: n.updated, mode: OrderingMode.desc),
                (n) => OrderingTerm(expression: n.id, mode: OrderingMode.desc),
              ])
              ..limit(pageSize, offset: pageSize * (pageNo - 1)))
            .get();
      } else {
        // For Deleted Notes folder
        return (select(notes)
              ..where((n) => n.isDeleted.equals(true))
              ..where((n) => n.createdBy.equals(GlobalState.currentUserId))
              ..orderBy([
                (n) => OrderingTerm(
                    expression: n.updated, mode: OrderingMode.desc),
                (n) => OrderingTerm(expression: n.id, mode: OrderingMode.desc),
              ])
              ..limit(pageSize, offset: pageSize * (pageNo - 1)))
            .get();
      }
    } else {
      // Get user folder notes
      // get user folder note list // get user folder data
      // get user folder note data

      return (select(notes)
            ..where((n) => n.folderId.equals(GlobalState.selectedFolderId))
            ..where((n) => n.isDeleted.equals(false))
            ..where((n) => n.createdBy.equals(GlobalState.currentUserId))
            ..where((n) {
              if (GlobalState.isReviewFolderSelected) {
                return isNotNull(n.nextReviewTime);
              } else {
                return isNull(n.nextReviewTime);
              }
            })
            ..orderBy([
              (n) {
                if (GlobalState.isReviewFolderSelected) {
                  return OrderingTerm(
                      expression: n.nextReviewTime, mode: OrderingMode.asc);
                } else {
                  return OrderingTerm(
                      expression: n.updated, mode: OrderingMode.desc);
                }
              },
              (n) => OrderingTerm(expression: n.id, mode: OrderingMode.desc),
            ])
            ..limit(pageSize, offset: pageSize * (pageNo - 1)))
          .get();
    }
  }

  Future<int> deleteAllNotes() {
    return (delete(notes)).go();
  }

  Future<bool> hasNote() async {
    // Whether the db has notes data

    bool hasNote = true;
    NoteEntry noteEntry = await (select(notes)..limit(1)).getSingle();

    if (noteEntry == null) hasNote = false;

    return hasNote;
  }

  // Review plans
  Future<void> upsertReviewPlansInBatch(
      List<ReviewPlanEntry> reviewPlanEntryList) async {
    return await batch((batch) {
      batch.insertAllOnConflictUpdate(reviewPlans, reviewPlanEntryList);
    });
  }

  // Review plan configs
  Future<void> upsertReviewPlanConfigsInBatch(
      List<ReviewPlanConfigEntry> reviewPlanConfigEntryList) async {
    return await batch((batch) {
      batch.insertAllOnConflictUpdate(
          reviewPlanConfigs, reviewPlanConfigEntryList);
    });
  }
}
