import 'package:dairy_tutorial/dairy.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  
  static Database _database;
  final String table = 'dairy';
  final int version = 2;

  Future<Database> get database async{
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async{
    var dir = await getDatabasesPath();
    String path = join(dir,'dairydb.db');
    var database = await openDatabase(path,version: version, onCreate: (Database db, int version){
      db.execute('CREATE TABLE $table(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, body TEXT, date TEXT)');
    });
    return database;
  }

  Future<void> save(Dairy dairy)async{
    Database db = await database;
    await db.insert(table, dairy.toMap());
  }

  Future<void> update(Dairy dairy)async{
    Database db = await database;
    await db.update(table, dairy.toMap(),where: 'id = ? ',whereArgs: [dairy.id]);
  }

  Future<void> delete(Dairy dairy)async{
    Database db = await database;
    await db.delete(table, where: 'id = ? ', whereArgs: [dairy.id]);
  }

  Future<List<Dairy>> getDairy() async{
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(table);
    List<Dairy> dairyList = List<Dairy>();
    for(var map in maps){
      dairyList.add(Dairy.fromMap(map));
    }
    return dairyList;
  }


}