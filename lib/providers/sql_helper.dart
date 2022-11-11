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
    String path = p.join(await getDatabasesPath(), 'shopping_data.db');
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
    db.insert('cart_items', product.toMap());
    print(db.query('cart_items'));
  }

  static Future<List<Map>> loadItems() async {
    Database db = await getDatabase;
    return db.query('cart_items');
  }

  static Future updateItem(Product newproduct, String status) async {
    Database db = await getDatabase;
    await db.rawUpdate('UPDATE cart_items SET qty = ?  WHERE documentId = ?', [
      status == 'increment' ? newproduct.qty + 1 : newproduct.qty - 1,
      newproduct.documentId
    ]);
  }

  static Future deleteItem(String id) async {
    Database db = await getDatabase;
    db.delete('cart_items', where: 'documentId = ?', whereArgs: [id]);
  }

  static Future daleteAllItem() async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM cart_items');
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
