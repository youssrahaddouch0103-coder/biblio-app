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

  Future<void> _createDB(Database db, int version) async {
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

  Future<int> insertLivre(Livre livre) async {
    final db = await instance.database;

    return await db.insert(
      'livres',
      livre.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Livre>> getLivres() async {
    final db = await instance.database;

    final result = await db.query(
      'livres',
      orderBy: 'id DESC',
    );

    return result.map((map) => Livre.fromMap(map)).toList();
  }

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

  Future<int> updateLivre(Livre livre) async {
    final db = await instance.database;

    if (livre.id == null) {
      throw Exception('Impossible de modifier un livre sans id');
    }

    return await db.update(
      'livres',
      livre.toMap(),
      where: 'id = ?',
      whereArgs: [livre.id],
    );
  }

  Future<int> deleteLivre(int id) async {
    final db = await instance.database;

    return await db.delete(
      'livres',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}