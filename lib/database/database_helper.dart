import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/livre.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('biblio.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE livres(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT NOT NULL,
        auteur TEXT NOT NULL,
        annee INTEGER,
        genre TEXT,
        note REAL,
        lu INTEGER NOT NULL
      )
    ''');
  }

  // CREATE
  Future<int> insertLivre(Livre livre) async {
    final db = await instance.database;

    return await db.insert(
      'livres',
      livre.toMap(),
    );
  }

  // READ ALL
  Future<List<Livre>> getLivres() async {
    final db = await instance.database;

    final result = await db.query('livres');

    return result.map((json) => Livre.fromMap(json)).toList();
  }

  // READ ONE
  Future<Livre?> getLivreById(int id) async {
    final db = await instance.database;

    final result = await db.query(
      'livres',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Livre.fromMap(result.first);
    }

    return null;
  }

  // UPDATE
  Future<int> updateLivre(Livre livre) async {
    final db = await instance.database;

    return await db.update(
      'livres',
      livre.toMap(),
      where: 'id = ?',
      whereArgs: [livre.id],
    );
  }

  // DELETE
  Future<int> deleteLivre(int id) async {
    final db = await instance.database;

    return await db.delete(
      'livres',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}