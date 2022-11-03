
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbRepo {
  late Database _db;

  Future<void> openDb() async {
    String dbPath = await getDatabasesPath();
    String dbName = "todo_app.db";
    String finalDb = join(dbPath, dbName);

    _db = await openDatabase(
        finalDb,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY, todoText TEXT, isDone INTEGER)',
        );
      },
      version: 1
    );
  }

  Future<void> insertDb(Map<String, dynamic> data, String tableName) async {
    await _db.insert(
        tableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Map<String, dynamic>>> retrieveDb(String tableName) async {
    List<Map<String, dynamic>> list;
    list = await _db.query(tableName);
    return list;
  }

  Future<void> updateDb(String tableName, Map<String, dynamic> newValues, int id) async {
    await _db.update(tableName, newValues, where: 'id = ?', whereArgs: [id]);

  }

  Future<void> deleteDb(String tableName, int id) async {
    await _db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

}