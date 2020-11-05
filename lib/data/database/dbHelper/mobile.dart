import 'dart:io';
import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart' as paths;
import 'package:path/path.dart' as p;
import 'package:seal_note/data/appstate/GlobalState.dart';
import '../database.dart';

Database constructDb({bool logStatements = false}) {
  if (Platform.isIOS || Platform.isAndroid) {
    final executor = LazyDatabase(() async {
      final dataDir = await paths.getApplicationDocumentsDirectory();


      // db file // seal db file
      final dbFile =
      File(p.join(dataDir.path, GlobalState.dbNameForMobilePlatform));

      print(dbFile);

      return VmDatabase(dbFile, logStatements: logStatements);
    });
    return Database(executor);
  }

  if (Platform.isMacOS || Platform.isLinux) {
    final file = File('sealmacdb2.sqlite');
    return Database(VmDatabase(file, logStatements: logStatements));
  }

  // if (Platform.isWindows) {
  //   final file = File('db.sqlite');
  //   return Database(VMDatabase(file, logStatements: logStatements));
  // }

  return Database(VmDatabase.memory(logStatements: logStatements));
}
