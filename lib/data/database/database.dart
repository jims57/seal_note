import 'dart:developer';

import 'package:moor/moor.dart';
import 'dart:async';

import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/NoteWithProgressTotal.dart';
import 'package:seal_note/util/converter/BooleanConverter.dart';

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

class _DateTimeToStartOfDay extends Expression<int> {
  final Expression<String> _inner;

  _DateTimeToStartOfDay(this._inner);

  @override
  void writeInto(GenerationContext context) {
    context.buffer.write("CAST(strftime('%s', date(");
    _inner.writeInto(context);
    context.buffer.write(')) AS INT)');
  }
}

extension ParseDateInSql on Expression<String> {
  Expression<int> startOfDayUnix() => _DateTimeToStartOfDay(this);
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

@UseMoor(tables: [
  Users,
  Folders,
  Notes,
  ReviewPlans,
  ReviewPlanConfigs
], queries: {
  // For folder list
  // 'foldersWithProgressTotal':
  //     'SELECT *,( SELECT count( *) FROM reviewPlanConfigs WHERE reviewPlanId = f.reviewPlanId ) AS progressTotal FROM folders f ORDER BY f.[order] ASC;',
  'getFoldersWithUnreadTotal':
      "SELECT f.id, f.name, f.[order], CASE WHEN f.isDefaultFolder = 1 AND f.name = '今天' THEN( SELECT count( *) FROM notes n WHERE n.isDeleted = 0 AND strftime('%Y-%m-%d %H:%M:%S', n.nextReviewTime) < strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime', 'start of day', '+1 day') AND n.isReviewFinished = 0 AND n.createdBy = :createdBy ) WHEN f.isDefaultFolder = 1 AND f.name = '全部笔记' THEN ( SELECT count( * ) FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy ) WHEN f.isDefaultFolder = 1 AND f.name = '删除笔记' THEN ( SELECT count( * ) FROM notes n WHERE n.isDeleted = 1 AND n.createdBy = :createdBy ) ELSE ( SELECT count( * ) FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy AND n.folderId = f.id AND CASE WHEN f.reviewPlanId IS NOT NULL THEN n.nextReviewTime IS NOT NULL ELSE n.nextReviewTime IS NULL END ) END numberToShow, f.isDefaultFolder, f.reviewPlanId, f.created, f.createdBy FROM folders f WHERE createdBy = :createdBy ORDER BY [order] ASC; ",

  // For note list
  'getNoteListForToday':
      "SELECT n.id, n.folderId, n.title, n.content, n.created, n.updated, n.nextReviewTime, CASE WHEN n.reviewProgressNo IS NULL THEN 0 ELSE n.reviewProgressNo END AS reviewProgressNo, n.isReviewFinished, n.isDeleted, n.createdBy,( SELECT count( *) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal FROM notes n, folders f WHERE n.folderId = f.id AND f.reviewPlanId IS NOT NULL AND n.isDeleted = 0 AND strftime('%Y-%m-%d %H:%M:%S', n.nextReviewTime) < strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime', 'start of day', '+1 day') AND n.isReviewFinished = 0 AND n.createdBy = :createdBy ORDER BY n.nextReviewTime ASC, n.id ASC LIMIT :pageSize OFFSET :pageSize * (:pageNo - 1); ",
  'getNoteListForAllNotes':
      "SELECT id, folderId, title, content, created, updated, nextReviewTime, CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END AS reviewProgressNo, isReviewFinished, isDeleted, createdBy,( SELECT count( *) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy ORDER BY n.updated DESC, n.id DESC LIMIT :pageSize OFFSET :pageSize * (:pageNo - 1); ",
  'getNoteListForDeletedNotes':
      "SELECT id, folderId, title, content, created, updated, nextReviewTime, CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END AS reviewProgressNo, isReviewFinished, isDeleted, createdBy,( SELECT count( *) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal FROM notes n WHERE n.isDeleted = 1 AND n.createdBy = :createdBy ORDER BY n.updated DESC, n.id DESC LIMIT :pageSize OFFSET :pageSize * (:pageNo - 1); ",
  'getNoteListForUserFolders':
      "WITH isReviewFolderTable AS( SELECT CASE WHEN reviewPlanId IS NOT NULL THEN 1 ELSE 0 END AS isReviewFolder FROM folders WHERE id = :folderId) SELECT id, folderId, title, content, created, updated, nextReviewTime, CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END AS reviewProgressNo, isReviewFinished, isDeleted, createdBy, ( SELECT count( * ) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy AND n.folderId = :folderId AND CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 1 THEN n.nextReviewTime IS NOT NULL ELSE n.nextReviewTime IS NULL END ORDER BY n.isReviewFinished ASC, CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 1 THEN n.nextReviewTime END ASC, CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 0 THEN n.updated END DESC, CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 1 THEN n.updated END DESC, CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 0 THEN n.id END DESC LIMIT :pageSize OFFSET :pageSize * (:pageNo - 1); ",

  // For testing
  'notesWithNullChecking2':
      'SELECT * FROM notes n WHERE  n.folderId = :selectedFolderId AND (CASE WHEN 1 = :isReviewFolderSelected THEN n.nextReviewTime IS NOT NULL ELSE n.nextReviewTime IS NULL END);'
})
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
    var newNoteEntryList = List<NoteEntry>();
    var countToInsert = 10;

    // upsert notes // update notes content
    for (var i = 0; i < countToInsert; i++) {
      var noteEntry = noteEntryList[i];
      var now = DateTime.now().toLocal();

      var note = NoteEntry(
          id: null,
          folderId: null,
          title: '标题${noteEntry.id}',
          content: 'Content:${noteEntry.title}',
          created: now,
          updated: now,
          isReviewFinished: false,
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

  Future<List<GetFoldersWithUnreadTotalResult>>
      getListForFoldersWithUnreadTotal() {
    var folders = getFoldersWithUnreadTotal(GlobalState.currentUserId).get();

    return folders;
  }

  Future reorderFolders(List<FoldersCompanion> foldersCompanionList) async {
    var result = await transaction(() async {
      for (var foldersCompanion in foldersCompanionList) {
        await (update(folders)
              ..where((f) => f.id.equals(foldersCompanion.id.value)))
            .write(FoldersCompanion(
          order: Value(foldersCompanion.order.value),
        ));
      }
    });

    return result;
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

  Future<List<NoteWithProgressTotal>> getNotesByPageSize(
      {@required int pageNo, @required int pageSize}) {
    // Check if it is for default folders, because we need to get specific data for default folders
    // get note list data // note list data

    if (GlobalState.isDefaultFolderSelected) {
      // When it is for default
      if (GlobalState.selectedFolderName ==
          GlobalState.defaultFolderNameForToday) {
        // For Today folder

        // get today note list item // get today data from sqlite
        // get today data // show today note list
        // show today note data // today data
        // today note list

        return getNoteListForToday(
                GlobalState.currentUserId, pageSize, pageNo.toDouble())
            .map((row) => _convertModelToNoteWithProgressTotal(row))
            .get();
      } else if (GlobalState.selectedFolderName ==
          GlobalState.defaultFolderNameForAllNotes) {
        // For All Notes folder

        // get all notes note list
        return getNoteListForAllNotes(
                GlobalState.currentUserId, pageSize, pageNo.toDouble())
            .map((row) => _convertModelToNoteWithProgressTotal(row))
            .get();
      } else {
        // get deleted note // get deletion notes

        // For Deleted Notes folder
        return getNoteListForDeletedNotes(
                GlobalState.currentUserId, pageSize, pageNo.toDouble())
            .map((row) => _convertModelToNoteWithProgressTotal(row))
            .get();
      }
    } else {
      // Get user folder notes
      // get user folder note list // get user folder data
      // get user folder note data

      return getNoteListForUserFolders(GlobalState.selectedFolderId,
              GlobalState.currentUserId, pageSize, pageNo.toDouble())
          .map((row) => _convertModelToNoteWithProgressTotal(row))
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

  // Model conversion
  NoteWithProgressTotal _convertModelToNoteWithProgressTotal(var row) {
    return NoteWithProgressTotal(
        id: row.id,
        folderId: row.folderId,
        title: row.title,
        content: row.content,
        created: row.created,
        updated: row.updated,
        nextReviewTime: row.nextReviewTime,
        reviewProgressNo: row.reviewProgressNo,
        isReviewFinished: row.isReviewFinished,
        isDeleted: row.isDeleted,
        createdBy: row.createdBy,
        progressTotal: row.progressTotal);
  }
}
