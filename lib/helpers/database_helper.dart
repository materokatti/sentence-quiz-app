import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/sentence.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sentences.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE sentences (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nativeSentence TEXT NOT NULL,
      answer TEXT NOT NULL
    )
    ''');
  }

  Future<int> insertSentence(Sentence sentence) async {
    final db = await instance.database;
    return await db.insert('sentences', {
      'nativeSentence': sentence.nativeSentence,
      'answer': sentence.answer,
    });
  }

  Future<int> getTotalSentences() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM sentences');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Sentence>> getAllSentences() async {
    final db = await instance.database;
    final results = await db.query('sentences');
    return results.map((map) => Sentence.fromMap(map)).toList();
  }

  Future<Sentence?> getRandomSentence() async {
    final db = await instance.database;
    final results =
        await db.rawQuery('SELECT * FROM sentences ORDER BY RANDOM() LIMIT 1');
    if (results.isNotEmpty) {
      return Sentence.fromMap(results.first);
    }
    return null;
  }
}
