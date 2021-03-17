import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  setDatabase() async{
    var directory =await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_eltodo');
    var database = await openDatabase(path, version: 1, onCreate: _onCreateDatabase);
    return database;
  }

  _onCreateDatabase(Database db, int version) async{
    await db.execute("CREATE TABLE categeries(id INTEGER PRIMARY KEY, name TEXT");
  }

}