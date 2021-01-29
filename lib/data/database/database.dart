import 'dart:developer';

import 'package:moor/moor.dart';
import 'dart:async';

import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/NoteWithProgressTotal.dart';
import 'package:seal_note/util/converter/BooleanConverter.dart';
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

  TextColumn get created => text().map(const IsoDateTimeConverter())();
}

@DataClassName('FolderEntry')
class Folders extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 200)();

  IntColumn get order => integer()();

  BoolColumn get isDefaultFolder =>
      boolean().withDefault(const Constant(false)).named('isDefaultFolder')();

  IntColumn get reviewPlanId => integer().nullable().named('reviewPlanId')();

  TextColumn get created => text().map(const IsoDateTimeConverter())();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('isDeleted')();

  IntColumn get createdBy =>
      integer().withDefault(const Constant(1)).named('createdBy')();
}

@DataClassName('NoteEntry')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get folderId =>
      integer().withDefault(const Constant(3)).named('folderId')();

  TextColumn get content => text().nullable()();

  TextColumn get created => text().map(const IsoDateTimeConverter())();

  TextColumn get updated => text().map(const IsoDateTimeConverter())();

  TextColumn get nextReviewTime => text()
      .nullable()
      .named('nextReviewTime')
      .map(const IsoDateTimeConverter())();

  TextColumn get oldNextReviewTime => text()
      .nullable()
      .named('oldNextReviewTime')
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
  // For folder order
  'increaseUserFoldersOrderByOneExceptNewlyCreatedOne':
      "UPDATE folders SET [order] = [order] + 1 WHERE [order] > 2 AND id <> :createdFolderId;",

  // For folder list
  'getFoldersWithUnreadTotal':
      "SELECT f.id, f.name, f.[order], CASE WHEN f.isDefaultFolder = 1 AND f.name = '今天' THEN( SELECT count( *) FROM notes n, folders f WHERE n.folderId = f.id AND f.reviewPlanId IS NOT NULL AND n.isDeleted = 0 AND strftime('%Y-%m-%d %H:%M:%S', n.nextReviewTime) < strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime', 'start of day', '+1 day') AND n.isReviewFinished = 0 AND n.createdBy = :createdBy ) WHEN f.isDefaultFolder = 1 AND f.name = '全部笔记' THEN ( SELECT count( * ) FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy ) WHEN f.isDefaultFolder = 1 AND f.name = '删除笔记' THEN ( SELECT count( * ) FROM notes n WHERE n.isDeleted = 1 AND n.createdBy = :createdBy ) ELSE ( SELECT count( * ) FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy AND n.folderId = f.id AND CASE WHEN f.reviewPlanId IS NOT NULL THEN n.nextReviewTime IS NOT NULL ELSE n.nextReviewTime IS NULL END ) END numberToShow, f.isDefaultFolder, f.reviewPlanId, f.created, f.createdBy FROM folders f WHERE f.createdBy = :createdBy AND f.isDeleted = 0 ORDER BY f.[order] ASC, f.created DESC; ",

  // For note list
  'getNoteListForToday':
      "SELECT n.id, n.folderId, CASE WHEN INSTR(content, '&lt;/p&gt;') > 0 THEN substr(content, 1, INSTR(content, '&lt;/p&gt;') + 9) ELSE content END AS title, n.content, n.created, n.updated, n.nextReviewTime, CASE WHEN n.reviewProgressNo IS NULL THEN 0 ELSE n.reviewProgressNo END AS reviewProgressNo, n.isReviewFinished, n.isDeleted, n.createdBy,( SELECT (CASE WHEN count( * ) = 0 THEN 0 ELSE count( * ) + 1 END) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal FROM notes n, folders f WHERE n.folderId = f.id AND f.reviewPlanId IS NOT NULL AND n.isDeleted = 0 AND strftime('%Y-%m-%d %H:%M:%S', n.nextReviewTime) < strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime', 'start of day', '+1 day') AND n.isReviewFinished = 0 AND n.createdBy = :createdBy ORDER BY n.nextReviewTime ASC, n.id ASC LIMIT :pageSize OFFSET :pageSize * (:pageNo - 1); ",
  'getNoteListForAllNotes':
      "SELECT id, folderId, CASE WHEN INSTR(content, '&lt;/p&gt;') > 0 THEN substr(content, 1, INSTR(content, '&lt;/p&gt;') + 9) ELSE content END AS title, content, created, updated, nextReviewTime, CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END AS reviewProgressNo, isReviewFinished, isDeleted, createdBy,( SELECT (CASE WHEN count( * ) = 0 THEN 0 ELSE count( * ) + 1 END) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy ORDER BY n.updated DESC, n.id DESC LIMIT :pageSize OFFSET :pageSize * (:pageNo - 1); ",
  'getNoteListForDeletedNotes':
      "SELECT id, folderId, CASE WHEN INSTR(content, '&lt;/p&gt;') > 0 THEN substr(content, 1, INSTR(content, '&lt;/p&gt;') + 9) ELSE content END AS title, content, created, updated, nextReviewTime, CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END AS reviewProgressNo, isReviewFinished, isDeleted, createdBy,( SELECT (CASE WHEN count( * ) = 0 THEN 0 ELSE count( * ) + 1 END) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal FROM notes n WHERE n.isDeleted = 1 AND n.createdBy = :createdBy ORDER BY n.updated DESC, n.id DESC LIMIT :pageSize OFFSET :pageSize * (:pageNo - 1); ",
  'getNoteListForUserFolders':
      "WITH isReviewFolderTable AS( SELECT (CASE WHEN reviewPlanId IS NOT NULL THEN 1 ELSE 0 END) AS isReviewFolder FROM folders WHERE id = :folderId) SELECT id, folderId, (CASE WHEN INSTR(content, '&lt;/p&gt;') > 0 THEN substr(content, 1, INSTR(content, '&lt;/p&gt;') + 9) ELSE content END) AS title, content, created, updated, nextReviewTime, (CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END) AS reviewProgressNo, isReviewFinished, isDeleted, createdBy, ( SELECT (CASE WHEN count( * ) = 0 THEN 0 ELSE count( * ) + 1 END) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy AND n.folderId = :folderId AND CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 1 THEN n.nextReviewTime IS NOT NULL ELSE n.nextReviewTime IS NULL END ORDER BY n.isReviewFinished ASC, CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 1 THEN n.nextReviewTime END ASC, CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 0 THEN n.updated END DESC, CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 1 THEN n.updated END DESC, CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 0 THEN n.id END DESC LIMIT :pageSize OFFSET :pageSize * (:pageNo - 1); ",
  'clearDeletedNotesMoreThan30DaysAgo':
      "DELETE FROM notes WHERE strftime('%Y-%m-%d %H:%M:%S', updated) <= strftime('%Y-%m-%d %H:%M:%S', :minAvailableDateTime); ",

  // For note review plan related
  'setRightReviewProgressNoAndIsReviewFinishedFieldForAllNotes': // Logic: https://docs.qq.com/sheet/DZEt3YWNLcURrVnF6?tab=BB08J2
      "WITH progressTable1 AS( SELECT folderId, ( SELECT CASE WHEN reviewPlanId > 0 THEN 1 ELSE 0 END FROM folders WHERE id = n.folderId) AS isReviewFolder, id AS noteId, (CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END) AS reviewProgressNo, ( SELECT (CASE WHEN count( * ) = 0 THEN 0 ELSE count( * ) + 1 END) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal, isReviewFinished FROM notes n ), progressTable2 AS ( SELECT (CASE WHEN isReviewFolder = 1 AND reviewProgressNo > progressTotal THEN 1 WHEN isReviewFolder = 1 AND reviewProgressNo = progressTotal AND isReviewFinished = 0 THEN 2 WHEN isReviewFolder = 1 AND reviewProgressNo < progressTotal AND isReviewFinished = 1 THEN 3 WHEN isReviewFolder = 0 AND isReviewFinished = 1 THEN 4 ELSE 0 END) AS conditionNo, * FROM progressTable1 ) UPDATE notes SET reviewProgressNo = (CASE WHEN ( SELECT conditionNo FROM progressTable2 WHERE noteId = notes.id ) = 1 THEN ( SELECT progressTotal FROM progressTable2 WHERE noteId = notes.id ) ELSE notes.reviewProgressNo END), isReviewFinished = (CASE WHEN ( SELECT conditionNo FROM progressTable2 WHERE noteId = notes.id ) IN (1, 2) THEN 1 ELSE 0 END) WHERE id IN ( SELECT noteId FROM progressTable2 WHERE conditionNo > 0 ); ",

  // For review plans
  'getFolderReviewPlanByFolderId':
      "SELECT rp.id reviewPlanId, rp.name reviewPlanName FROM reviewPlans rp WHERE id =( SELECT reviewPlanId FROM folders WHERE id = :folderId);",
  'setFolderToNonReviewOneFromReviewOne':
      "UPDATE notes SET oldNextReviewTime = nextReviewTime, nextReviewTime = NULL WHERE folderId = :folderId;",
  'setFolderToReviewOneFromNonReviewOne':
      "UPDATE notes SET nextReviewTime =(CASE WHEN oldNextReviewTime IS NOT NULL THEN oldNextReviewTime ELSE :now END), oldNextReviewTime = NULL WHERE folderId = :folderId; ",
  'setFolderToReviewOneFromAnother':
      "UPDATE notes SET nextReviewTime =(CASE WHEN nextReviewTime IS NULL THEN :now ELSE nextReviewTime END) WHERE folderId = :folderId; ",
})
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  Database.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 1;

  // Initialization related
  Future<bool> isDbInitialized() async {
    // Whether the db has been initialized, the logic of it is based on whether Today folder which is a default folder is inserted or not

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
          // title: '标题${noteEntry.id}',
          content: 'Content:${noteEntry.id}',
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

  Future<bool> hasFolder({@required int folderId}) async {
    var hasFolder = false;
    FolderEntry folderEntry;

    folderEntry = await (select(folders)..where((f) => f.id.equals(folderId)))
        .getSingle();

    if (folderEntry != null) {
      hasFolder = true;
    }

    return hasFolder;
  }

  Future<bool> hasNotesInFolder(
      {@required int folderId, bool includeDeletedNotes = false}) async {
    var hasNotes = false;
    List<NoteEntry> noteEntryList = List<NoteEntry>();

    if (includeDeletedNotes) {
      noteEntryList = await (select(notes)
            ..where((n) => n.folderId.equals(folderId)))
          .get();
    } else {
      noteEntryList = await (select(notes)
            ..where((n) => n.folderId.equals(folderId))
            ..where((n) => n.isDeleted.equals(false)))
          .get();
    }

    if (noteEntryList.length > 0) {
      hasNotes = true;
    }

    return hasNotes;
  }

  Future<FolderEntry> getFolderEntry({@required int folderId}) async {
    FolderEntry folderEntry = await (select(folders)
          ..where((f) => f.id.equals(folderId)))
        .getSingle();

    return folderEntry;
  }

  Future<int> getFolderIdByNoteId({@required int noteId}) async {
    var folderId = 0;
    NoteEntry noteEntry =
        await (select(notes)..where((n) => n.id.equals(noteId))).getSingle();

    if (noteEntry != null) {
      folderId = noteEntry.folderId;
    }

    return folderId;
  }

  Future<String> getFolderNameById(int folderId) async {
    var folderName = '';
    FolderEntry folderEntry = await (select(folders)
          ..where((f) => f.id.equals(folderId)))
        .getSingle();

    if (folderEntry != null) {
      folderName = folderEntry.name;
    }

    return folderName;
  }

  Future<List<GetFoldersWithUnreadTotalResult>>
      getListForFoldersWithUnreadTotal() {
    var folders = getFoldersWithUnreadTotal(GlobalState.currentUserId).get();

    return folders;
  }

  Future<int> insertFolder(FoldersCompanion entry) async {
    return into(folders).insert(entry);
  }

  Future<int> updateFolder(FoldersCompanion foldersCompanion) async {
    return (update(folders)
          ..where((f) => f.id.equals(foldersCompanion.id.value)))
        .write(foldersCompanion);
  }

  Future<void> upsertFoldersInBatch(List<FolderEntry> folderEntryList) async {
    return await batch((batch) {
      batch.insertAllOnConflictUpdate(folders, folderEntryList);
    });
  }

  Future<int> changeFolderName(
      {@required int folderId, @required String newFolderName}) async {
    var foldersCompanion =
        FoldersCompanion(id: Value(folderId), name: Value(newFolderName));

    var effectedRowCount = await updateFolder(foldersCompanion);

    return effectedRowCount;
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

  Future<int> deleteFolder({@required int folderId}) async {
    var result =
        await (delete(folders)..where((f) => f.id.equals(folderId))).go();

    return result;
  }

  Future<int> setFolderDeletedStatus(
      {@required int folderId, bool isDeleted}) async {
    // Make a note as deleted or not, this won't remove the note from db, it just set isDeleted = true

    var result = await (update(folders)..where((f) => f.id.equals(folderId)))
        .write(FoldersCompanion(
      isDeleted: Value(isDeleted),
    ));

    return result;
  }

  Future<int> setFolderAndItsNotesToDeletedStatus(
      {@required int folderId}) async {
    var result = await transaction(() async {
      var folderEffectedRowCount = 0;

      // Set folder to deleted status
      folderEffectedRowCount =
          await setFolderDeletedStatus(folderId: folderId, isDeleted: true);

      // Set notes inside the folder to deleted status
      await setNotesDeletedStatusByFolderId(
          folderId: folderId, isDeleted: true);

      return folderEffectedRowCount;
    });

    return result;
  }

  Future<int> updateFolderReviewPlanId({
    @required int folderId,
    @required int oldReviewPlanId,
    @required int newReviewPlanId,
    bool forceToUpdateNotesWithNullNextReviewTimeByNow = true,
  }) async {
    var effectedRows = await transaction(() async {
      var effectedRows = 0;

      Value<int> reviewPlanIdValue = Value(null);

      if (newReviewPlanId > 0) {
        reviewPlanIdValue = Value(newReviewPlanId);
      }

      // Update the reviewPlanId field in folder table
      var foldersEffectedRows = await (update(folders)
            ..where((f) => f.id.equals(folderId)))
          .write(FoldersCompanion(
        reviewPlanId: reviewPlanIdValue,
      ));

      if (!forceToUpdateNotesWithNullNextReviewTimeByNow) {
        effectedRows = foldersEffectedRows;
      } else {
        var notesEffectedRows = 0;

        // Make sure all notes with Null nextReviewTime in the folder to have nextReviewTime value
        if (foldersEffectedRows > 0) {
          // When it is setting the folder to a review one
          var now = TimeHandler.getNowForLocal().toIso8601String();

          // Check if it is setting a review plan to the folder or not
          if (oldReviewPlanId != 0 && newReviewPlanId != 0) {
            // When switching review plans from one to another
            notesEffectedRows =
                await setFolderToReviewOneFromAnother(now, folderId);
          } else {
            // When changing review plan between review one and non-review one

            if (newReviewPlanId == 0) {
              // When it is setting the folder to a non-review one from a review one
              notesEffectedRows =
                  await setFolderToNonReviewOneFromReviewOne(folderId);
            } else {
              // When it is setting the folder to review one from a non-review one
              notesEffectedRows =
                  await setFolderToReviewOneFromNonReviewOne(now, folderId);
            }
          }
        }

        effectedRows = notesEffectedRows;
      }

      return effectedRows;
    });

    return effectedRows;
  }

// Notes
  Future<NoteEntry> getNoteEntryByNoteId({@required int noteId}) async {
    var noteEntry =
        await (select(notes)..where((n) => n.id.equals(noteId))).getSingle();

    return noteEntry;
  }

  Future<String> getNoteContentById({@required int noteId}) async {
    var noteContent = '';

    var noteEntry = await getNoteEntryByNoteId(noteId: noteId);

    if (noteEntry != null) noteContent = noteEntry.content;

    return noteContent;
  }

  Future<int> insertNote(NoteEntry noteEntry) {
    // Add a note to db

    return into(notes).insert(noteEntry);
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

  Future<int> updateNote(NotesCompanion notesCompanion) async {
    return (update(notes)
          ..where((e) => e.id.equals(GlobalState.selectedNoteModel.id)))
        .write(notesCompanion);
  }

  Future<int> changeNoteFolderId({
    @required int noteId,
    @required int newFolderId,
    @required int typeId,
    @required int currentReviewPlanId,
    @required int targetReviewPlanId,
  }) async {
    // For more info about typeId at:【腾讯文档】海豚笔记关键逻辑 https://docs.qq.com/sheet/DZEt3YWNLcURrVnF6
    // 0 means: Set nextReviewTime, reviewProgressNo fields to NULL and set isReviewFinished back to 0
    // 1 means: Set value to nextReviewTime and reviewProgressNo fields and set isReviewFinished back to 0
    // 2 means: Don't need to change all review related fields, such as nextReviewTIme, reviewProgressNo and isReviewFinished

    // Get old value of the note
    var noteEntry = await getNoteEntryByNoteId(noteId: noteId);
    var nextReviewTimeValue = Value(noteEntry.nextReviewTime);
    var oldNextReviewTimeValue = Value(noteEntry.oldNextReviewTime);
    var isReviewFinishedValue = Value(noteEntry.isReviewFinished);

    var notesCompanion;

    if (typeId == 0) {
      if (nextReviewTimeValue.value != null) {
        oldNextReviewTimeValue = nextReviewTimeValue;
        nextReviewTimeValue = Value(null);
      }
      isReviewFinishedValue = Value(false);

      notesCompanion = NotesCompanion(
          id: Value(noteId),
          folderId: Value(newFolderId),
          nextReviewTime: nextReviewTimeValue,
          oldNextReviewTime: oldNextReviewTimeValue,
          // reviewProgressNo: Value(null),
          isReviewFinished: isReviewFinishedValue,
          updated: Value(TimeHandler.getNowForLocal()));
    } else if (typeId == 1) {
      if (nextReviewTimeValue.value == null) {
        if (oldNextReviewTimeValue.value != null) {
          nextReviewTimeValue = oldNextReviewTimeValue;
        } else {
          nextReviewTimeValue = Value(TimeHandler.getNowForLocal());
        }
      }

      notesCompanion = NotesCompanion(
          id: Value(noteId),
          folderId: Value(newFolderId),
          nextReviewTime: nextReviewTimeValue,
          // Review instantly
          // reviewProgressNo: Value(0),
          isReviewFinished: Value(false),
          updated: Value(TimeHandler.getNowForLocal()));
    } else {
      // TypeId = 2
      notesCompanion = NotesCompanion(
          id: Value(noteId),
          folderId: Value(newFolderId),
          updated: Value(TimeHandler.getNowForLocal()));
    }

    var effectedRowCount = await (update(notes)
          ..where((e) => e.id.equals(noteId)))
        .write(notesCompanion);

    return effectedRowCount;
  }

  Future<List<NoteWithProgressTotal>> getNotesByPageSize(
      {@required int pageNo, @required int pageSize}) {
    // Check if it is for default folders, because we need to get specific data for default folders
    // get note list data // note list data

    if (GlobalState.isDefaultFolderSelected) {
      // When it is for default

      if (GlobalState.appState.noteListPageTitle ==
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
        // } else if (GlobalState.selectedFolderName ==
      } else if (GlobalState.appState.noteListPageTitle ==
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

      return getNoteListForUserFolders(GlobalState.selectedFolderIdCurrently,
              GlobalState.currentUserId, pageSize, pageNo.toDouble())
          .map((row) => _convertModelToNoteWithProgressTotal(row))
          .get();
    }
  }

  Future<int> deleteNote(int noteId,
      {bool forceToDeleteFolderWhenNoNote = false,
      bool autoDeleteFolderWithDeletedStatus = false}) async {
    // Delete a note, this will remove the note from db completely

    var effectedRowCount = 0;

    await transaction(() async {
      // Get folder id the note belongs to
      var folderId = await getFolderIdByNoteId(noteId: noteId);
      var shouldDeleteFolderFromDB = false;

      effectedRowCount =
          await (delete(notes)..where((n) => n.id.equals(noteId))).go();

      if (forceToDeleteFolderWhenNoNote) {
        var isFolderExisting = await hasFolder(folderId: folderId);

        if (isFolderExisting) {
          shouldDeleteFolderFromDB = true;
        }
      }

      if (autoDeleteFolderWithDeletedStatus) {
        var folderEntry = await getFolderEntry(folderId: folderId);

        if (folderEntry != null) {
          var isFolderDeleted = folderEntry.isDeleted;

          if (isFolderDeleted) {
            shouldDeleteFolderFromDB = true;
          }
        }
      }

      if (shouldDeleteFolderFromDB) {
        // When the folder has no note any more, by the way, we delete the folder
        await deleteFolder(folderId: folderId);
      }

      return effectedRowCount;
    });

    return effectedRowCount;
  }

  Future<int> setNoteDeletedStatus(
      {@required int noteId, bool isDeleted}) async {
    // Make a note as deleted or not, this won't remove the note from db, it just set isDeleted = true

    return await (update(notes)..where((e) => e.id.equals(noteId))).write(
        NotesCompanion(
            isDeleted: Value(isDeleted),
            updated: Value(TimeHandler.getNowForLocal())));
  }

  Future<int> setNotesDeletedStatusByFolderId(
      {@required int folderId, bool isDeleted}) async {
    // Make all note inside a folder as deleted or not, this won't remove the note from db, it just set isDeleted = true

    return await (update(notes)..where((e) => e.folderId.equals(folderId)))
        .write(NotesCompanion(
            isDeleted: Value(isDeleted),
            updated: Value(TimeHandler.getNowForLocal())));
  }

  Future<int> restoreNoteFromDeletedFolder({@required int noteId}) async {
    // Make a note as deleted or not, this won't remove the note from db, it just set isDeleted = true
    var effectedRowCount = 0;

    effectedRowCount = await transaction(() async {
      // Restore the note (isDeleted == false)
      effectedRowCount = await (update(notes)
            ..where((e) => e.id.equals(noteId)))
          .write(NotesCompanion(
              isDeleted: Value(false),
              updated: Value(TimeHandler.getNowForLocal())));

      // Get the folder id the note belongs to
      var folderId = await getFolderIdByNoteId(noteId: noteId);

      // Restore the folder anyway
      if (folderId > 0) {
        // If the folder exists in db, we restore the folder anyway
        await (update(folders)..where((f) => f.id.equals(folderId)))
            .write(FoldersCompanion(
          isDeleted: Value(false),
        ));
      }

      return effectedRowCount;
    });

    return effectedRowCount;
  }

  Future<int> updateNoteNextReviewTime(
      {@required int noteId, @required DateTime nextReviewTime}) async {
    return (update(notes)..where((e) => e.id.equals(noteId))).write(
        NotesCompanion(
            nextReviewTime: Value(nextReviewTime),
            updated: Value(TimeHandler.getNowForLocal())));
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

  Future<int> getProgressTotalByReviewPlanId(
      {@required int reviewPlanId}) async {
    var progressTotal = (await (select(reviewPlanConfigs)
                  ..where((rpc) => rpc.reviewPlanId.equals(reviewPlanId)))
                .get())
            .length +
        1;

    return progressTotal;
  }

  Future<void> upsertReviewPlanConfigsInBatch(
      List<ReviewPlanConfigEntry> reviewPlanConfigEntryList) async {
    return await batch((batch) {
      batch.insertAllOnConflictUpdate(
          reviewPlanConfigs, reviewPlanConfigEntryList);
    });
  }

  Future<List<ReviewPlanEntry>> getAllReviewPlans() async {
    return await (select(reviewPlans)
          ..orderBy([
            (rp) => OrderingTerm(expression: rp.id, mode: OrderingMode.desc),
          ]))
        .get();
  }

// Other methods
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
