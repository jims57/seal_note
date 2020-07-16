import 'package:moor/moor.dart';

part 'database.g.dart';

@DataClassName('NoteEntry')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 2, max: 32)();

  TextColumn get content => text().named('body')();

  DateTimeColumn get created => dateTime().named('createdT')();
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

  @override
  int get schemaVersion => 1;

  Future<int> insertNote(NotesCompanion entry) {
    return into(notes).insert(entry);
  }

  Future<List<NoteEntry>> get getAllNotes => select(notes).get();

  Future<List<NoteEntry>> getNotesByPageSize (
      {@required int pageNo, @required int pageSize}) {
    Future<List<NoteEntry>> nl = (select(notes)
          ..orderBy([
            (t) => OrderingTerm(expression: t.created, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
          ])
          ..limit(pageSize, offset: pageSize * (pageNo - 1)))
        .get();

    return nl;
  }

  Future<int> deleteAllNotes() {
    return (delete(notes)).go();
  }
}
