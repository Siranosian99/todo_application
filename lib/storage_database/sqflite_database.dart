import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_application/model/todo_model.dart';

class TodoDatabase {
  static Database? _database;
  static List<TodoModel> tasks = [];

  static Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        return db.execute(
            'CREATE TABLE todo (id INTEGER PRIMARY KEY AUTOINCREMENT,photoPath TEXT,task TEXT,description TEXT,date TEXT,time TEXT,isDone INTEGER)');
      },
    );
  }

  // CREATE
  static Future<int> insertNote(TodoModel todo) async {
    final dbClient = await db;
    int auto_id=await dbClient.insert('todo', todo.toJson());
    print("this id${auto_id}");
    return auto_id;
  }

// READ
  static Future<List<TodoModel>> getNotes() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('todo');
    return maps.map((map) => TodoModel.fromJson(map)).toList();
  }

  // UPDATE
  static Future<int> updateNote(int id, TodoModel todo) async {
    final dbClient = await db;
    return await dbClient
        .update('todo', todo.toJson(), where: 'id = ?', whereArgs: [id]);
  }

  // DELETE
  static Future<int> deleteNote(int id) async {
    final dbClient = await db;
    return await dbClient.delete('todo', where: 'id = ?', whereArgs: [id]);
  }
}
