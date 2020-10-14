import 'dart:developer';

import 'package:moor/moor.dart';
import 'dart:async';

import 'package:seal_note/data/appstate/GlobalState.dart';

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
      .withDefault(Constant(DateTime.now().toString()))
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
      .withDefault(Constant(DateTime.now().toString()))
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

  TextColumn get created => text()
      .withDefault(Constant(DateTime.now().toString()))
      .map(const IsoDateTimeConverter())();

  TextColumn get updated => text()
      .withDefault(Constant(DateTime.now().toString()))
      .map(const IsoDateTimeConverter())();

  TextColumn get nextReviewTime => text()
      .nullable()
      .named('nextReviewTime')
      .map(const IsoDateTimeConverter())();

  IntColumn get reviewProgressNo =>
      integer().nullable().named('reviewProgressNo')();

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
    var result = await transaction(() async {
      for (var noteEntry in noteEntryList) {
        await (update(notes)..where((e) => e.id.equals(noteEntry.id)))
            .write(NotesCompanion(
          // string.substring(1, 4);
          title: Value('标题${noteEntry.id}'),
          content: Value(noteEntry.title),
        ));
      }
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
          ..orderBy([(t) => OrderingTerm(expression: t.order)]))
        .get();
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

  Future<List<NoteEntry>> getNotesByPageSize(
      {@required int pageNo, @required int pageSize}) {
    // Check if it is for default folders, because we need to get specific data for default folders
    if (GlobalState.isDefaultFolderSelected) {
      // When it is for default
      // get today note list item // get today data from sqlite
      // get today data
      if (GlobalState.selectedFolderName ==
          GlobalState.defaultFolderNameForToday) {
        // For Today folder
        var now = DateTime.now();
        String todayDateString = '${now.year}-${now.month}-${now.day}';

        return (select(notes)
              ..where((n) => n.isDeleted.equals(false))
              ..where((n) => n.nextReviewTime.like('$todayDateString%'))
              ..orderBy([
                (n) => OrderingTerm(
                    expression: n.updated, mode: OrderingMode.desc),
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
              ..orderBy([
                (n) => OrderingTerm(
                    expression: n.updated, mode: OrderingMode.desc),
                (n) => OrderingTerm(expression: n.id, mode: OrderingMode.desc),
              ])
              ..limit(pageSize, offset: pageSize * (pageNo - 1)))
            .get();
      }
    } else {
      // get user folder note list
      return (select(notes)
            ..where((n) => n.folderId.equals(GlobalState.selectedFolderId))
            ..where((n) => n.isDeleted.equals(false))
            ..orderBy([
              (n) =>
                  OrderingTerm(expression: n.updated, mode: OrderingMode.desc),
              (n) => OrderingTerm(expression: n.id, mode: OrderingMode.desc),
            ])
            ..limit(pageSize, offset: pageSize * (pageNo - 1)))
          .get();
    }
  }

  Future<int> deleteAllNotes() {
    return (delete(notes)).go();
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
