// ignore_for_file: avoid_print

import 'package:hub/providers/product_class.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class SQHelper {
  static Database? _database;
  static get getDatabase async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  static Future<Database> initDatabase() async {
    String path = p.join(await getDatabasesPath(), 'shipping_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future _onCreate(Database db, int verstion) async {
    Batch batch = db.batch();
    batch.execute('''CREATE TABLE cart_items(
      documentId TEXT PRIMARY KEY,
      name TEXT,
      price DOUBLE,
      qty INTEGER,
     qntty INTEGER,
     imagesUrl TEXT,
     suppId TEXT
      )''');
    batch.execute('''CREATE TABLE wish_items(
      documentId TEXT PRIMARY KEY,
      name TEXT,
      price DOUBLE,
      qty INTEGER,
     qntty INTEGER,
     imagesUrl TEXT,
     suppId TEXT
      )''');
    batch.commit();
    print('on create was called');
  }

  static Future insertItem(Product product) async {
    Database db = await getDatabase;
    // await db.insert('cart_items', product.toMap());
    print(await db.query('cart_items'));
  }

  static Future insertTodo(Todo todo) async {
    Database db = await getDatabase;
    await db.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print(await db.query('todos'));
  }

  static Future insertNoteRaw(title, content) async {
    Database db = await getDatabase;
    await db.rawInsert(
        'INSERT INTO notes(title, content,) VALUES(?, ?)', [title, content]);
    print(await db.rawQuery('SELECT * FROM notes'));
  }

  static Future<List<Map>> loadItems() async {
    Database db = await getDatabase;
    return await db.query('cart_items');
  }

  static Future<List<Map>> loadTodo() async {
    Database db = await getDatabase;
    List<Map> maps = await db.query('todos');
    return List.generate(maps.length, (index) {
      return Todo(
        id: maps[index]['id'],
        title: maps[index]['title'],
        value: maps[index]['value'],
      ).toMap();
    });
  }

  static Future updateNote(Note newNote) async {
    Database db = await getDatabase;
    await db.update('notes', newNote.toMap(),
        where: 'id=?', whereArgs: [newNote.id]);
  }

  static Future updateNoteTodoCheck(int id, int currentValue) async {
    Database db = await getDatabase;
    await db.rawUpdate('UPDATE todos SET value = ? WHERE id = ?',
        [currentValue == 0 ? 1 : 0, id]);
  }

  static Future updateNoteRaw(Note newNote) async {
    Database db = await getDatabase;
    await db.rawUpdate('UPDATE notes SET title = ?, content = ? WHERE id = ?',
        [newNote.title, newNote.content, newNote.id]);
  }

  static Future daleteNote(int id) async {
    Database db = await getDatabase;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future daleteNoteRaw(int id) async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM notes WHERE id = ?', [id]);
  }

  static Future daleteAllNoteRaw() async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM notes');
  }

  static Future daleteAllNote() async {
    Database db = await getDatabase;
    await db.delete('notes');
  }

  static Future daleteAllTodosRaw() async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM todos');
  }

  static Future daleteAllTodos() async {
    Database db = await getDatabase;
    await db.delete('todos');
  }
}

class Note {
  final int id;
  final String title;
  final String content;
  String? description;

  Note(
      {required this.id,
      required this.title,
      required this.content,
      this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Note{id:$id , title: $title , content: $content,description: $description,}';
  }
}

class Todo {
  final int? id;
  final String title;
  int value;

  Todo({this.id, required this.title, this.value = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'value': value,
    };
  }

  @override
  String toString() {
    return 'Note{id:$id , title: $title ,value: $value,}';
  }
}
