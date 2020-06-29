import 'package:moor/moor.dart';

part 'database.g.dart';

@DataClassName('NoteEntry')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 2, max: 32)();

  TextColumn get content => text().named('body')();
}

@UseMoor(tables: [Notes])
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  Future<int> createTodoEntry(NotesCompanion entry) {
    return into(notes).insert(entry);
  }

  Future<List<NoteEntry>> get getAllTodoEntries => select(notes).get();

  Future deleteAllTodo() {
    return (delete(notes)).go();
  }
}
