import 'package:moor/moor.dart';
import 'dart:async';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/NoteWithProgressTotal.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/model/errorCodes/ErrorCodeModel.dart';
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

String _nowForLocal() {
  return const IsoDateTimeConverter().mapToSql(DateTime.now().toLocal());
}

@DataClassName('UserEntry')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get userName =>
      text().withLength(min: 1, max: 200).named('userName')();

  TextColumn get password => text()
      .withDefault(const Constant('123456'))
      .withLength(min: 6, max: 200)();

  TextColumn get nickName =>
      text().nullable().withLength(min: 1, max: 200).named('nickName')();

  TextColumn get portrait => text().nullable()();

  TextColumn get mobile => text().nullable().withLength(min: 11, max: 11)();

  TextColumn get introduction => text().nullable()();

  TextColumn get created =>
      text().clientDefault(_nowForLocal).map(const IsoDateTimeConverter())();
}

@DataClassName('FolderEntry')
class Folders extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 200)();

  IntColumn get order => integer().withDefault(const Constant(3))();

  BoolColumn get isDefaultFolder =>
      boolean().withDefault(const Constant(false)).named('isDefaultFolder')();

  IntColumn get reviewPlanId => integer().nullable().named('reviewPlanId')();

  TextColumn get created =>
      text().clientDefault(_nowForLocal).map(const IsoDateTimeConverter())();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('isDeleted')();

  IntColumn get createdBy => integer()
      .withDefault(Constant(GlobalState.currentUserId))
      .named('createdBy')();
}

@DataClassName('NoteEntry')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get folderId => integer()
      .withDefault(Constant(GlobalState.defaultUserFolderIdForMyNotes))
      .named('folderId')();

  TextColumn get content => text().nullable()();

  TextColumn get created =>
      text().clientDefault(_nowForLocal).map(const IsoDateTimeConverter())();

  TextColumn get updated =>
      text().clientDefault(_nowForLocal).map(const IsoDateTimeConverter())();

  // * [basic]
  //    a. This field has to have value for review note,
  //    whereas NULL for non-review note,
  //    or the non-review folder won't show the note even it is inside a folder which has no review plan.
  //    b. Zero and NULL are same.
  // * [Ordering]
  //    a. The ordering (order by asc) takes precedence over the ordering(order by desc) of *updated* filed
  //    b . If you want to make the ordering of *updated* take effect, you have to set value *3000-01-01T00:00:00.000* to this field
  //    so that all review-finished notes have the same *nextReviewTime* value to ignore this field ordering, in this case,
  //    *updated* field can order as expected(order by asc updated)
  // * [3000Y value]
  //    a. When this field value is 3000-01-01T00:00:00.000, it means this note has been finished all its review plans by the user's review behavior.
  //    b. But if *isReviewFinished* field = true, and this field isn't 3000-01-01T00:00:00.000, say, 2021-02-07T15:39:56.025050,
  //    it means this note is marked finished because it is moved from another folder which as more review plans,
  //    in a nutshell, it is not finished by the user review behavior, but by Move Note functionality instead.
  TextColumn get nextReviewTime => text()
      .nullable()
      .named('nextReviewTime')
      .map(const IsoDateTimeConverter())();

  TextColumn get oldNextReviewTime => text()
      .nullable()
      .named('oldNextReviewTime')
      .map(const IsoDateTimeConverter())();

  // Remark:
  // Example: total = 3
  // * When 3/3 means this note has finished review
  // * 0/3 is the first time to review, when finished this, it will become 1/3
  IntColumn get reviewProgressNo =>
      integer().nullable().named('reviewProgressNo')();

  BoolColumn get isReviewFinished =>
      boolean().withDefault(const Constant(false)).named('isReviewFinished')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('isDeleted')();

  IntColumn get createdBy => integer()
      .withDefault(Constant(GlobalState.currentUserId))
      .named('createdBy')();
}

@DataClassName('ReviewPlanEntry')
class ReviewPlans extends Table {
  @override
  String get tableName => 'reviewPlans';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get introduction => text()();

  IntColumn get createdBy => integer()
      .withDefault(Constant(GlobalState.currentUserId))
      .named('createdBy')();
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

  IntColumn get createdBy => integer()
      .withDefault(Constant(GlobalState.currentUserId))
      .named('createdBy')();
}

@DataClassName('SystemInfoEntry')
class SystemInfos extends Table {
  @override
  String get tableName => 'SystemInfos';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get key => text().named('key')();

  TextColumn get value => text().named('value')();

// @override
// List<String> get customConstraints => ['UNIQUE (key)'];
}

@UseMoor(tables: [
  Users,
  Folders,
  Notes,
  ReviewPlans,
  ReviewPlanConfigs,
  SystemInfos
], queries: {
  // For folder order
  'increaseUserFoldersOrderByOneExceptNewlyCreatedOne':
      "UPDATE folders SET [order] = [order] + 1 WHERE [order] > 2 AND id <> :createdFolderId;",

  // For folder list
  'getFoldersWithUnreadTotal':
      "SELECT f.id, f.name, f.[order], CASE WHEN f.id = 1 THEN( SELECT count( *) FROM notes n, folders f WHERE n.folderId = f.id AND f.reviewPlanId IS NOT NULL AND n.isDeleted = 0 AND strftime('%Y-%m-%d %H:%M:%S', n.nextReviewTime) < strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime', 'start of day', '+1 day') AND n.isReviewFinished = 0 AND n.createdBy = :createdBy ) WHEN f.id = 2 THEN ( SELECT count( * ) FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy ) WHEN f.id = 3 THEN ( SELECT count( * ) FROM notes n WHERE n.isDeleted = 1 AND n.createdBy = :createdBy ) ELSE ( SELECT count( * ) FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy AND n.folderId = f.id AND CASE WHEN f.reviewPlanId IS NOT NULL THEN n.nextReviewTime IS NOT NULL ELSE n.nextReviewTime IS NULL END ) END numberToShow, f.isDefaultFolder, f.reviewPlanId, f.created, f.createdBy FROM folders f WHERE f.createdBy = :createdBy AND f.isDeleted = 0 ORDER BY f.[order] ASC, f.created DESC; ",

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

  // For note model
  'getNoteWithProgressTotalByNoteId':
      "with myTargetFolderReviewPlanIdTable as( select reviewPlanId from folders where id = :folderId), myNoteWithReviewPlanIdTable as(SELECT (CASE /*When the folder the current note belongs to isn't a review folder, reviewPlanId just return -1*/ WHEN (select reviewPlanId from myTargetFolderReviewPlanIdTable limit 1) is null THEN -1 /*If the folder the current note belongs to is a review folder, just return its reviewPlanId, say, 4*/ ELSE (select reviewPlanId from myTargetFolderReviewPlanIdTable limit 1) END) AS reviewPlanId, * FROM notes n WHERE id = :noteId), myNoteWithProgressTotalTable as ( select (CASE /*If it isn't in a review folder, the progressTotal is -1*/ WHEN reviewPlanId = -1 THEN -1 /*If it is in a review folder, just return its right progress total the folder is using*/ ELSE (select count(*)+1 from reviewPlanConfigs where reviewPlanId = nrp.reviewPlanId) END) as progressTotal,* from myNoteWithReviewPlanIdTable nrp ) select * from myNoteWithProgressTotalTable ",

  // For note review
  'setNoteToNextReviewPhrase': // This is used for the note review button, see:  https://user-images.githubusercontent.com/1920873/107107893-033e3880-686f-11eb-92d9-5e5ee7179956.png
      "WITH myNoteTable AS( SELECT id AS noteId, folderId, nextReviewTime, (CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END) AS reviewProgressNo FROM notes WHERE id = :noteId), myReviewPlanConfigsTable AS ( SELECT (select noteId from myNoteTable) as noteId, rpc.id reviewPlanConfigId, rpc.[order], rpc.value, rpc.unit, (select nextReviewTime from myNoteTable) as nextReviewTime, ( SELECT reviewProgressNo + 1 FROM myNoteTable ) as newReviewProgressNo, ( SELECT count( * ) + 1 FROM reviewPlanConfigs WHERE reviewPlanId = rpc.reviewPlanId ) AS progressTotal FROM reviewPlanConfigs rpc WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM myNoteTable ) ) ) , myReviewPlanConfigsTable2 AS ( SELECT noteId, reviewPlanConfigId, [order], value, unit, nextReviewTime, newReviewProgressNo, progressTotal FROM myReviewPlanConfigsTable WHERE [order] = ( SELECT reviewProgressNo + 1 FROM myNoteTable ) ) , myDifferenceMinutesTable as( select noteId, reviewPlanConfigId as nextReviewPlanConfigId, [order], value, unit, nextReviewTime, newReviewProgressNo, progressTotal, (CASE WHEN unit = 1 THEN value WHEN unit=2 THEN value*60 WHEN unit=3 THEN value*60*24 WHEN unit=4 THEN value*60*24*7 WHEN unit=5 THEN value*60*24*30 ELSE value*60*24*365 END) as differenceMinutes from myReviewPlanConfigsTable2 ) , myReviewPlanConfigsTableWith3000Year as( select noteId,(CASE WHEN count( * ) = 0 THEN -3000 ELSE dmt.nextReviewPlanConfigId END) AS nextReviewPlanConfigId,[order],value,unit, nextReviewTime as oldNextReviewTime, newReviewProgressNo, (CASE WHEN count( * ) = 0 THEN (select progressTotal from myReviewPlanConfigsTable limit 1) ELSE dmt.progressTotal END) as progressTotal, differenceMinutes, '+'||cast(differenceMinutes as text)||' minutes' as differenceMinutesFormat from myDifferenceMinutesTable dmt ) ,myNewNextReviewTimeTable as( select noteId, nextReviewPlanConfigId, strftime('%Y-%m-%dT%H:%M:%f', 'now','localtime') as updated, oldNextReviewTime, (CASE WHEN strftime('%Y-%m-%dT%H:%M:%f',oldNextReviewTime)<strftime('%Y-%m-%dT%H:%M:%f', 'now','localtime') THEN 1 ELSE 0 END) as oldNextReviewTimeisLessThanNow, differenceMinutesFormat, newReviewProgressNo, progressTotal from myReviewPlanConfigsTableWith3000Year ), myNewNextReviewTimeTableWithCheckingNow as ( select *, (CASE /*When the oldNextReviewTime is less than now, we will use now as the base to get the newNextReviewTime,*/ /*but if the oldNextReviewTime is greater than now, we use the oldNextReviewTime as the base to calculate it.*/ WHEN oldNextReviewTimeisLessThanNow=1 THEN strftime('%Y-%m-%dT%H:%M:%f',datetime(strftime('%Y-%m-%dT%H:%M:%f', 'now','localtime'), differenceMinutesFormat)) ELSE strftime('%Y-%m-%dT%H:%M:%f',datetime(strftime('%Y-%m-%dT%H:%M:%f', oldNextReviewTime), differenceMinutesFormat)) END) as newNextReviewTime from myNewNextReviewTimeTable ) update notes set updated = (select updated from myNewNextReviewTimeTableWithCheckingNow limit 1), nextReviewTime = (CASE WHEN (select nextReviewPlanConfigId from myNewNextReviewTimeTableWithCheckingNow limit 1)=-3000 THEN '3000-01-01T00:00:00.000' ELSE (select newNextReviewTime from myNewNextReviewTimeTableWithCheckingNow limit 1) END), oldNextReviewTime = (CASE WHEN (select nextReviewPlanConfigId from myNewNextReviewTimeTableWithCheckingNow limit 1)=-3000 THEN NULL ELSE oldNextReviewTime END), reviewProgressNo =(CASE WHEN (select nextReviewPlanConfigId from myNewNextReviewTimeTableWithCheckingNow limit 1)=-3000 THEN (select progressTotal from myNewNextReviewTimeTableWithCheckingNow limit 1) ELSE (select newReviewProgressNo from myNewNextReviewTimeTableWithCheckingNow limit 1) END), isReviewFinished = (CASE WHEN (select nextReviewPlanConfigId from myNewNextReviewTimeTableWithCheckingNow limit 1)=-3000 THEN 1 ELSE 0 END) where id = (select noteId from myNewNextReviewTimeTableWithCheckingNow limit 1) ",

  // For note review plan related
  'setRightReviewProgressNoAndIsReviewFinishedFieldForAllNotes': // Logic: https://docs.qq.com/sheet/DZEt3YWNLcURrVnF6?tab=BB08J2
      "WITH progressTable1 AS( SELECT folderId, ( SELECT CASE WHEN reviewPlanId > 0 THEN 1 ELSE 0 END FROM folders WHERE id = n.folderId) AS isReviewFolder, id AS noteId, (CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END) AS reviewProgressNo, ( SELECT (CASE WHEN count( * ) = 0 THEN 0 ELSE count( * ) + 1 END) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal, isReviewFinished FROM notes n ), progressTable2 AS ( SELECT (CASE WHEN isReviewFolder = 1 AND reviewProgressNo > progressTotal THEN 1 WHEN isReviewFolder = 1 AND reviewProgressNo = progressTotal AND isReviewFinished = 0 THEN 2 WHEN isReviewFolder = 1 AND reviewProgressNo < progressTotal AND isReviewFinished = 1 THEN 3 WHEN isReviewFolder = 0 AND isReviewFinished = 1 THEN 4 ELSE 0 END) AS conditionNo, * FROM progressTable1 ) UPDATE notes SET reviewProgressNo = (CASE WHEN ( SELECT conditionNo FROM progressTable2 WHERE noteId = notes.id ) = 1 THEN ( SELECT progressTotal FROM progressTable2 WHERE noteId = notes.id ) ELSE notes.reviewProgressNo END), isReviewFinished = (CASE WHEN ( SELECT conditionNo FROM progressTable2 WHERE noteId = notes.id ) IN (1, 2) THEN 1 ELSE 0 END) WHERE id IN ( SELECT noteId FROM progressTable2 WHERE conditionNo > 0 ); ",

  // For review plans
  'getFolderReviewPlanByFolderId':
      "SELECT rp.id reviewPlanId, rp.name reviewPlanName FROM reviewPlans rp WHERE id =( SELECT reviewPlanId FROM folders WHERE id = :folderId);",
  'setFolderToNonReviewOneFromReviewOne':
      "UPDATE notes SET oldNextReviewTime = nextReviewTime, nextReviewTime = NULL WHERE folderId = :folderId;",
  'setFolderToReviewOneFromNonReviewOne':
      "WITH myParametersTable AS( SELECT CAST (:newReviewPlanId AS INTEGER) AS newReviewPlanId, CAST (:folderId AS INTEGER) AS folderId, strftime('%Y-%m-%dT%H:%M:%f', 'now', 'localtime') AS now), myTargetProgressTotalTable AS ( SELECT reviewPlanId AS targetReviewPlanId, count( * ) + 1 AS targetProgressTotal FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT newReviewPlanId FROM myParametersTable ) ) UPDATE notes SET nextReviewTime = (CASE WHEN (reviewProgressNo < ( SELECT targetProgressTotal FROM myTargetProgressTotalTable ) OR reviewProgressNo IS NULL) AND strftime('%Y-%m-%d', oldNextReviewTime) >= strftime('%Y-%m-%d', '3000-01-01T00:00:00.000') THEN ( SELECT now FROM myParametersTable ) WHEN oldNextReviewTime IS NOT NULL THEN oldNextReviewTime ELSE ( SELECT now FROM myParametersTable ) END), oldNextReviewTime = NULL WHERE folderId = ( SELECT folderId FROM myParametersTable ); ",
  'setFolderToReviewOneFromAnother':
      "WITH myParametersTable AS( SELECT CAST (:newReviewPlanId AS INTEGER) AS newReviewPlanId, CAST (:folderId AS INTEGER) AS folderId, strftime('%Y-%m-%dT%H:%M:%f', 'now', 'localtime') AS now), myTargetProgressTotalTable AS ( SELECT reviewPlanId AS targetReviewPlanId, count( * ) + 1 AS targetProgressTotal FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT newReviewPlanId FROM myParametersTable ) ) UPDATE notes SET nextReviewTime = (CASE WHEN strftime('%Y-%m-%d', nextReviewTime) >= strftime('%Y-%m-%d', '3000-01-01T00:00:00.000') AND (reviewProgressNo < ( SELECT targetProgressTotal FROM myTargetProgressTotalTable ) OR reviewProgressNo IS NULL) THEN ( SELECT now FROM myParametersTable ) WHEN nextReviewTime IS NULL THEN ( SELECT now FROM myParametersTable ) ELSE nextReviewTime END) WHERE folderId = ( SELECT folderId FROM myParametersTable ); ",

  // For review plan configs
  'getNextReviewPlanConfigIdByNoteId': // return -3000, means the next review time of the note has reached its last review progress, and should set *isReviewFinished* true
      "WITH myNoteTable AS( SELECT id AS noteId, folderId, (CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END) AS reviewProgressNo FROM notes WHERE id = :noteId), myReviewPlanConfigsTable AS ( SELECT rpc.id reviewPlanConfigId, rpc.[order], rpc.value, rpc.unit, ( SELECT reviewProgressNo + 1 FROM myNoteTable ) nextReviewProgressNo, ( SELECT count( * ) + 1 FROM reviewPlanConfigs WHERE reviewPlanId = rpc.reviewPlanId ) AS progressTotal FROM reviewPlanConfigs rpc WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM myNoteTable ) ) ), myReviewPlanConfigsTable2 AS ( SELECT reviewPlanConfigId, [order], value, unit FROM myReviewPlanConfigsTable WHERE [order] = ( SELECT reviewProgressNo + 1 FROM myNoteTable ) ), myDifferenceMinutesTable as( select reviewPlanConfigId, [order], value, unit, (CASE WHEN unit = 1 THEN value WHEN unit=2 THEN value*60 WHEN unit=3 THEN value*60*24 WHEN unit=4 THEN value*60*24*7 WHEN unit=5 THEN value*60*24*30 ELSE value*60*24*365 END) as differenceMinutes from myReviewPlanConfigsTable2 ) select (CASE WHEN count( * ) = 0 THEN -3000 ELSE dmt.reviewPlanConfigId END) AS reviewPlanConfigId,[order],value,unit, differenceMinutes from myDifferenceMinutesTable dmt",
  // "WITH myNoteTable AS( SELECT id AS noteId, folderId, (CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END) AS reviewProgressNo FROM notes WHERE id = :noteId), myReviewPlanConfigsTable AS ( SELECT rpc.id reviewPlanConfigId, rpc.[order], rpc.value, rpc.unit, ( SELECT reviewProgressNo + 1 FROM myNoteTable ) nextReviewProgressNo, ( SELECT count( * ) + 1 FROM reviewPlanConfigs WHERE reviewPlanId = rpc.reviewPlanId ) AS progressTotal FROM reviewPlanConfigs rpc WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM myNoteTable ) ) ), myReviewPlanConfigsTable2 AS ( SELECT reviewPlanConfigId FROM myReviewPlanConfigsTable WHERE [order] = ( SELECT reviewProgressNo + 1 FROM myNoteTable ) ) SELECT (CASE WHEN count( * ) = 0 THEN -3000 ELSE t2.reviewPlanConfigId END) AS reviewPlanConfigId FROM myReviewPlanConfigsTable2 t2; ",
})
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  Database.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => GlobalState.systemInfoBasicDataStructureVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {});

  // Initialization related
  Future<bool> isDbInitialized() async {
    // Use *dataVersion* key in systemInfos to test if the db has been initialized, since *dataVersion* is the last record to be inserted

    bool isDbInitialized = false;

    var systemInfo = await getSystemInfoByKey(
        key: GlobalState.systemInfoKeyNameForDataVersion);
    if (systemInfo != null) {
      isDbInitialized = true;
    }

    return isDbInitialized;
  }

  Future updateAllNotesContentByTitles(List<NoteEntry> noteEntryList) async {
    var newNoteEntryList = <NoteEntry>[];
    var countToInsert = 10;

    // upsert notes // update notes content
    for (var i = 0; i < countToInsert; i++) {
      var noteEntry = noteEntryList[i];
      var now = DateTime.now().toLocal();

      var note = NoteEntry(
          id: null,
          folderId: 4,
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

  Future<ResponseModel> upsertUsersInBatch({
    @required List<UsersCompanion> usersCompanionList,
  }) async {
    var response;

    await batch((batch) {
      batch.insertAllOnConflictUpdate(
          users, usersCompanionList); //>>moor upsert
    }).then((value) {
      response = ResponseModel.getResponseModelForSuccess();
    }).catchError((err) {
      response = ResponseModel.getResponseModelForError(
        code: ErrorCodeModel.UPSERT_USERS_IN_BATCH_FAILED_CODE,
        message: ErrorCodeModel.UPSERT_USERS_IN_BATCH_FAILED_MESSAGE,
      );
    });

    return response;
  }

  Future<int> deleteUser({@required int userId}) async {
    var result = await (delete(users)..where((u) => u.id.equals(userId))).go();

    return result;
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

  Future<bool> isFolderWithUserNotes({@required int folderId}) async {
    var isFolderWithUserNotes = false;
    NoteEntry noteEntry = await (select(notes)
          ..where((n) => n.folderId.equals(folderId))
          ..where((n) => n.id
              .isBiggerOrEqualValue(GlobalState.beginIdForUserOperationInDB)))
        .getSingle();

    if (noteEntry != null) {
      isFolderWithUserNotes = true;
    }

    return isFolderWithUserNotes;
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
    List<NoteEntry> noteEntryList = <NoteEntry>[];

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

  Future<List<FolderEntry>> getFoldersByIdScope({
    @required int beginId,
    @required intEndId,
  }) async {
    List<FolderEntry> folderEntryList = await (select(folders)
          ..where((f) => f.id.isBiggerOrEqualValue(beginId))
          ..where((f) => f.id.isSmallerOrEqualValue(intEndId)))
        .get();

    return folderEntryList;
  }

  Future<List<FolderEntry>> getFoldersCreatedByUser() async {
    var beginId = GlobalState.beginIdForUserOperationInDB;

    List<FolderEntry> folderEntryList = await (select(folders)
          ..where((f) => f.id.isBiggerOrEqualValue(beginId)))
        .get();

    return folderEntryList;
  }

  Future<List<FolderEntry>> getFoldersCreatedBySystemInfo() async {
    var endId = GlobalState.beginIdForUserOperationInDB;

    List<FolderEntry> folderEntryList = await (select(folders)
          ..where((f) => f.id.isSmallerThanValue(endId)))
        .get();

    return folderEntryList;
  }

  Future<int> insertFolder(FoldersCompanion entry) async {
    return into(folders).insert(entry);
  }

  Future<int> updateFolder(FoldersCompanion foldersCompanion) async {
    return (update(folders)
          ..where((f) => f.id.equals(foldersCompanion.id.value)))
        .write(foldersCompanion);
  }

  Future<ResponseModel> updateFoldersByTransaction(
      {@required List<FoldersCompanion> foldersCompanionList}) async {
    var response = ResponseModel.getResponseModelForSuccess();

    await transaction(() async {
      for (var foldersCompanion in foldersCompanionList) {
        await (update(folders)
              ..where((f) => f.id.equals(foldersCompanion.id.value)))
            .write(foldersCompanion);
      }
    }).catchError((err) {
      response = ResponseModel.getResponseModelForError(
        code: ErrorCodeModel.UPDATE_FOLDERS_IN_BATCH_FAILED_CODE,
        message: ErrorCodeModel.UPDATE_FOLDERS_IN_BATCH_FAILED_MESSAGE,
      );
    });

    return response;
  }

  Future<ResponseModel> upsertFoldersInBatch({
    @required List<FoldersCompanion> foldersCompanionList,
  }) async {
    var response;

    await batch((batch) {
      batch.insertAllOnConflictUpdate(folders, foldersCompanionList);
    }).then((value) {
      response = ResponseModel.getResponseModelForSuccess();
    }).catchError((err) {
      response = ResponseModel.getResponseModelForError(
        code: ErrorCodeModel.UPSERT_FOLDERS_IN_BATCH_FAILED_CODE,
        message: ErrorCodeModel.UPSERT_FOLDERS_IN_BATCH_FAILED_MESSAGE,
      );
    });

    return response;
  }

  Future<int> changeFolderName(
      {@required int folderId, @required String newFolderName}) async {
    var foldersCompanion =
        FoldersCompanion(id: Value(folderId), name: Value(newFolderName));

    var effectedRowCount = await updateFolder(foldersCompanion);

    return effectedRowCount;
  }

  Future<ResponseModel> reorderFolders(
      List<FoldersCompanion> foldersCompanionList) async {
    var response = ResponseModel.getResponseModelForSuccess();

    await transaction(() async {
      for (var foldersCompanion in foldersCompanionList) {
        await (update(folders)
              ..where((f) => f.id.equals(foldersCompanion.id.value)))
            .write(FoldersCompanion(
          order: Value(foldersCompanion.order.value),
        ));
      }
    }).catchError((err) {
      response = ResponseModel.getResponseModelForError(
        code: ErrorCodeModel.REORDER_FOLDERS_FAILED_CODE,
        message: ErrorCodeModel.REORDER_FOLDERS_FAILED_MESSAGE,
      );
    });

    return response;
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
    // oldReviewPlanId = 0, means NULL in sqlite db
    @required int oldReviewPlanId,
    // newReviewPlanId = 0, means NULL in sqlite db
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

          // Check if it is setting a review plan to the folder or not
          if (oldReviewPlanId != 0 && newReviewPlanId != 0) {
            // When switching review plans from one to another
            notesEffectedRows = await setFolderToReviewOneFromAnother(
                newReviewPlanId.toString(), folderId.toString());
          } else {
            // When changing review plan between review one and non-review one

            if (newReviewPlanId == 0) {
              // When it is setting the folder to a non-review one from a review one
              notesEffectedRows =
                  await setFolderToNonReviewOneFromReviewOne(folderId);
            } else {
              // When it is setting the folder to review one from a non-review one
              notesEffectedRows =
                  // await setFolderToReviewOneFromNonReviewOne(now, folderId);
                  await setFolderToReviewOneFromNonReviewOne(
                      newReviewPlanId.toString(), folderId.toString());
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

  Future<List<NoteEntry>> getNotesCreatedBySystemInfo() async {
    var endId = GlobalState.beginIdForUserOperationInDB;

    List<NoteEntry> noteEntryList = await (select(notes)
          ..where((n) => n.id.isSmallerThanValue(endId)))
        .get();

    return noteEntryList;
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

  Future<ResponseModel> upsertNotesInBatch({
    @required List<NotesCompanion> notesCompanionList,
  }) async {
    var response;

    await batch((batch) {
      batch.insertAllOnConflictUpdate(notes, notesCompanionList);
    }).then((value) {
      response = ResponseModel.getResponseModelForSuccess();
    }).catchError((err) {
      response = ResponseModel.getResponseModelForError(
        code: ErrorCodeModel.UPSERT_NOTES_IN_BATCH_FAILED_CODE,
        message: ErrorCodeModel.UPSERT_NOTES_IN_BATCH_FAILED_MESSAGE,
      );
    });

    return response;
  }

  Future<int> updateNote({
    @required NotesCompanion notesCompanion,
  }) async {
    return (update(notes)..where((e) => e.id.equals(notesCompanion.id.value)))
        .write(notesCompanion);
  }

  Future<ResponseModel> updateNotesByTransaction(
      {@required List<NotesCompanion> notesCompanionList}) async {
    var response = ResponseModel.getResponseModelForSuccess();

    await transaction(() async {
      for (var notesCompanion in notesCompanionList) {
        await (update(notes)
              ..where((f) => f.id.equals(notesCompanion.id.value)))
            .write(notesCompanion);
      }
    }).catchError((err) {
      response = ResponseModel.getResponseModelForError(
        code: ErrorCodeModel.UPDATE_NOTES_IN_BATCH_FAILED_CODE,
        message: ErrorCodeModel.UPDATE_NOTES_IN_BATCH_FAILED_MESSAGE,
      );
    });

    return response;
  }

  Future<int> changeNoteFolderId({
    @required int noteId,
    @required int newFolderId,
    @required int typeId,
    @required int currentReviewPlanId,
    @required int targetReviewPlanId,
  }) async {
    // For more info about typeId at: https://docs.qq.com/sheet/DZEt3YWNLcURrVnF6
    // 0 means: Set nextReviewTime, reviewProgressNo fields to NULL and set isReviewFinished back to 0
    // 1 means: Set value to nextReviewTime and reviewProgressNo fields and set isReviewFinished back to 0
    // 2 means: Don't need to change all review related fields, such as nextReviewTIme, reviewProgressNo and isReviewFinished

    // Get old value of the note
    var theNoteEntry =
        await getNoteWithProgressTotalByNoteId(newFolderId, noteId).getSingle();
    var nextReviewTimeValue = Value(theNoteEntry.nextReviewTime);
    var oldNextReviewTimeValue = Value(theNoteEntry.oldNextReviewTime);
    var isReviewFinishedValue = Value(theNoteEntry.isReviewFinished);

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

      // Check if new next review time is 3000-01-01T00:00:00.000 or not
      if (nextReviewTimeValue.value.year >= 3000 &&
          theNoteEntry.reviewProgressNo < theNoteEntry.progressTotal) {
        nextReviewTimeValue = Value(TimeHandler.getNowForLocal());
      }

      notesCompanion = NotesCompanion(
          id: Value(noteId),
          folderId: Value(newFolderId),
          nextReviewTime: nextReviewTimeValue,
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

      if (GlobalState.selectedFolderIdCurrently ==
          GlobalState.defaultFolderIdForToday) {
        // For Today folder

        // get today note list item // get today data from sqlite
        // get today data // show today note list
        // show today note data // today data
        // today note list

        return getNoteListForToday(
                GlobalState.currentUserId, pageSize, pageNo.toDouble())
            .map((row) => _convertModelToNoteWithProgressTotal(row))
            .get();
      } else if (GlobalState.selectedFolderIdCurrently ==
          GlobalState.defaultFolderIdForAllNotes) {
        // For All Notes folder

        // get all notes note list
        return getNoteListForAllNotes(
                GlobalState.currentUserId, pageSize, pageNo.toDouble())
            .map((row) => _convertModelToNoteWithProgressTotal(row))
            .get();
      } else if (GlobalState.selectedFolderIdCurrently ==
          GlobalState.defaultFolderIdForDeletedFolder) {
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

  Future<int> setNotesDeletedStatusByFolderId({
    @required int folderId,
    @required bool isDeleted,
    bool forceToSetUpdatedFieldToNow = true,
  }) async {
    // Make all note inside a folder as deleted or not, this won't remove the note from db, it just set isDeleted = true

    var updatedValue;
    if (forceToSetUpdatedFieldToNow) {
      updatedValue = Value(TimeHandler.getNowForLocal());
    } else {
      updatedValue = Value<DateTime>.absent();
    }

    return await (update(notes)..where((e) => e.folderId.equals(folderId)))
        .write(NotesCompanion(
      isDeleted: Value(isDeleted),
      updated: updatedValue,
    ));
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

  Future<int> reviewNoteAgain({@required int noteId}) async {
    // See bug: https://github.com/jims57/seal_note/issues/350

    var nowValue = Value(TimeHandler.getNowForLocal());

    return await (update(notes)..where((n) => n.id.equals(noteId))).write(
      NotesCompanion(
        updated: nowValue,
        nextReviewTime: nowValue,
        oldNextReviewTime: Value(null),
        reviewProgressNo: Value(0),
        isReviewFinished: Value(false),
      ),
    );
  }

// Review plans
  Future<List<ReviewPlanEntry>> getAllReviewPlans() async {
    return await (select(reviewPlans)
          ..orderBy([
            (rp) => OrderingTerm(expression: rp.id, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<ReviewPlanEntry>> getReviewPlansCreatedBySystemInfo() async {
    var endId = GlobalState.beginIdForUserOperationInDB;

    List<ReviewPlanEntry> reviewPlanEntryList = await (select(reviewPlans)
          ..where((rp) => rp.id.isSmallerThanValue(endId)))
        .get();

    return reviewPlanEntryList;
  }

  Future<int> updateReviewPlan({
    @required ReviewPlansCompanion reviewPlansCompanion,
  }) async {
    return (update(reviewPlans)
          ..where((rp) => rp.id.equals(reviewPlansCompanion.id.value)))
        .write(reviewPlansCompanion);
  }

  Future<int> deleteReviewPlan({@required int reviewPlanId}) async {
    var result = await (delete(reviewPlans)
          ..where((rp) => rp.id.equals(reviewPlanId)))
        .go();

    return result;
  }

  Future<ResponseModel> updateReviewPlansByTransaction(
      {@required List<ReviewPlansCompanion> reviewPlansCompanionList}) async {
    var response = ResponseModel.getResponseModelForSuccess();

    await transaction(() async {
      for (var reviewPlansCompanion in reviewPlansCompanionList) {
        await (update(reviewPlans)
              ..where((f) => f.id.equals(reviewPlansCompanion.id.value)))
            .write(reviewPlansCompanion);
      }
    }).catchError((err) {
      response = ResponseModel.getResponseModelForError(
        code: ErrorCodeModel.UPDATE_REVIEW_PLANS_IN_BATCH_FAILED_CODE,
        message: ErrorCodeModel.UPDATE_REVIEW_PLANS_IN_BATCH_FAILED_MESSAGE,
      );
    });

    return response;
  }

  Future<ResponseModel> upsertReviewPlansInBatch({
    @required List<ReviewPlansCompanion> reviewPlansCompanionList,
  }) async {
    var response;

    await batch((batch) {
      batch.insertAllOnConflictUpdate(reviewPlans, reviewPlansCompanionList);
    }).then((value) {
      response = ResponseModel.getResponseModelForSuccess();
    }).catchError((err) {
      response = ResponseModel.getResponseModelForError(
        code: ErrorCodeModel.UPSERT_REVIEW_PLANS_IN_BATCH_FAILED_CODE,
        message: ErrorCodeModel.UPSERT_REVIEW_PLANS_IN_BATCH_FAILED_MESSAGE,
      );
    });

    return response;
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

// Review plan config
  Future<List<ReviewPlanConfigEntry>>
      getReviewPlanConfigsCreatedBySystemInfo() async {
    var endId = GlobalState.beginIdForUserOperationInDB;

    List<ReviewPlanConfigEntry> reviewPlanConfigEntryList =
        await (select(reviewPlanConfigs)
              ..where((rpc) => rpc.id.isSmallerThanValue(endId)))
            .get();

    return reviewPlanConfigEntryList;
  }

  Future<int> updateReviewPlanConfig({
    @required ReviewPlanConfigsCompanion reviewPlanConfigsCompanion,
  }) async {
    return (update(reviewPlanConfigs)
          ..where((rpc) => rpc.id.equals(reviewPlanConfigsCompanion.id.value)))
        .write(reviewPlanConfigsCompanion);
  }

  Future<int> deleteReviewPlanConfig({@required int reviewPlanConfigId}) async {
    var result = await (delete(reviewPlanConfigs)
          ..where((rpc) => rpc.id.equals(reviewPlanConfigId)))
        .go();

    return result;
  }

  Future<ResponseModel> updateReviewPlanConfigsByTransaction(
      {@required
          List<ReviewPlanConfigsCompanion>
              reviewPlanConfigsCompanionList}) async {
    var response = ResponseModel.getResponseModelForSuccess();

    await transaction(() async {
      for (var reviewPlanConfigsCompanion in reviewPlanConfigsCompanionList) {
        await (update(reviewPlanConfigs)
              ..where((f) => f.id.equals(reviewPlanConfigsCompanion.id.value)))
            .write(reviewPlanConfigsCompanion);
      }
    }).catchError((err) {
      response = ResponseModel.getResponseModelForError(
        code: ErrorCodeModel.UPDATE_REVIEW_PLAN_CONFIGS_IN_BATCH_FAILED_CODE,
        message:
            ErrorCodeModel.UPDATE_REVIEW_PLAN_CONFIGS_IN_BATCH_FAILED_MESSAGE,
      );
    });

    return response;
  }

  Future<ResponseModel> upsertReviewPlanConfigsInBatch({
    @required List<ReviewPlanConfigsCompanion> reviewPlanConfigsCompanionList,
  }) async {
    var response;

    await batch((batch) {
      batch.insertAllOnConflictUpdate(
          reviewPlanConfigs, reviewPlanConfigsCompanionList);
    }).then((value) {
      response = ResponseModel.getResponseModelForSuccess();
    }).catchError((err) {
      response = ResponseModel.getResponseModelForError(
        code: ErrorCodeModel.UPSERT_REVIEW_PLAN_CONFIGS_IN_BATCH_FAILED_CODE,
        message:
            ErrorCodeModel.UPSERT_REVIEW_PLAN_CONFIGS_IN_BATCH_FAILED_MESSAGE,
      );
    });

    return response;
  }

// System Infos
  Future<SystemInfoEntry> getSystemInfoByKey({@required String key}) async {
    return await (select(systemInfos)..where((si) => si.key.equals(key)))
        .getSingle();
  }

  Future<List<SystemInfoEntry>> getSystemInfosCreatedBySystemInfo() async {
    var endId = GlobalState.beginIdForUserOperationInDB;

    List<SystemInfoEntry> systemInfoEntryList = await (select(systemInfos)
          ..where((si) => si.id.isSmallerThanValue(endId)))
        .get();

    return systemInfoEntryList;
  }

  Future<int> getSystemInfoDataVersion() async {
    var dataVersion = 0;

    var systemInfo = await (select(systemInfos)
          ..where((si) =>
              si.key.equals(GlobalState.systemInfoKeyNameForDataVersion)))
        .getSingle();

    if (systemInfo != null) {
      dataVersion = int.parse(systemInfo.value);
    }

    return dataVersion;
  }

  Future<int> upsertSystemInfoDataVersion({@required int newDataVersion}) {
    var systemInfosCompanion = SystemInfosCompanion(
      id: Value(1),
      key: Value(GlobalState.systemInfoKeyNameForDataVersion),
      value: Value('$newDataVersion'),
    );
    return into(systemInfos).insertOnConflictUpdate(systemInfosCompanion);
  }

  Future<ResponseModel> upsertSystemInfosInBatch({
    @required List<SystemInfosCompanion> systemInfosCompanionList,
  }) async {
    var response;

    await batch((batch) {
      batch.insertAllOnConflictUpdate(systemInfos, systemInfosCompanionList);
    }).then((value) {
      response = ResponseModel.getResponseModelForSuccess();
    }).catchError((err) {
      response = ResponseModel.getResponseModelForError(
        code: ErrorCodeModel.UPSERT_SYSTEM_INFOS_IN_BATCH_FAILED_CODE,
        message: ErrorCodeModel.UPSERT_SYSTEM_INFOS_IN_BATCH_FAILED_MESSAGE,
      );
    });

    return response;
  }

  Future<int> deleteSystemInfo({@required int systemInfoId}) async {
    var result = await (delete(systemInfos)
          ..where((si) => si.id.equals(systemInfoId)))
        .go();

    return result;
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
