import 'package:moor/moor.dart';

part 'database.g.dart';

@DataClassName('NoteEntry')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 2, max: 200)();

  TextColumn get content => text().nullable().named('body')();

  DateTimeColumn get created => dateTime().nullable().named('createdT')();

  @override
  Set<Column> get primaryKey => {id};
}

//LazyDatabase _openConnection() {
//  // the LazyDatabase util lets us find the right location for the file async.
//  return LazyDatabase(() async {
//    // put the database file, called db.sqlite here, into the documents folder
//    // for your app.
//    final dbFolder = await getApplicationDocumentsDirectory();
//    final file = File(p.join(dbFolder.path, 'db.sqlite'));
//    return VmDatabase(file);
//  });
//}

@UseMoor(tables: [Notes])
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  Database.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 1;

  Future<int> insertNote(NotesCompanion entry) {
    return into(notes).insert(entry);
  }

  Future<List<NoteEntry>> insertNotesInBatch(
      List<NoteEntry> noteEntryList) async {
    await batch((batch) {
      batch.insertAll(notes, noteEntryList);
    });
  }

  Future<List<NoteEntry>> upsertNotesInBatch(
      List<NoteEntry> noteEntryList) async {
    await batch((batch){
      batch.insertAllOnConflictUpdate(notes, noteEntryList);
    });
  }

  Future<List<NoteEntry>> get getAllNotes => select(notes).get();

  Future<List<NoteEntry>> getNotesByPageSize(
      {@required int pageNo, @required int pageSize}) {
    Future<List<NoteEntry>> nl = (select(notes)
          ..orderBy([
            (t) => OrderingTerm(expression: t.created, mode: OrderingMode.asc),
            (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
          ])
          ..limit(pageSize, offset: pageSize * (pageNo - 1)))
        .get();

    return nl;
  }

  Future<int> deleteAllNotes() {
    return (delete(notes)).go();
  }
}
