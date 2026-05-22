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
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
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
        lu INTEGER NOT NULL,
        favori INTEGER NOT NULL,
        dateAjout TEXT,
        dateModification TEXT
      )
    ''');

    await _insertInitialData(db);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE livres ADD COLUMN favori INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE livres ADD COLUMN dateAjout TEXT');
      await db.execute('ALTER TABLE livres ADD COLUMN dateModification TEXT');
    }
  }

  Future<void> _insertInitialData(Database db) async {
    final now = DateTime.now().toIso8601String();

    final livres = [
      ['Le Petit Prince', 'Antoine de Saint-Exupéry', 1943, 'Conte', 5.0, 1, 1],
      ['1984', 'George Orwell', 1949, 'Science-fiction', 5.0, 1, 1],
      ['Harry Potter à l’école des sorciers', 'J.K. Rowling', 1997, 'Fantasy', 4.5, 1, 1],
      ['L’Étranger', 'Albert Camus', 1942, 'Roman', 4.0, 1, 0],
      ['Les Misérables', 'Victor Hugo', 1862, 'Classique', 5.0, 0, 1],
      ['Crime et Châtiment', 'Fiodor Dostoïevski', 1866, 'Philosophique', 4.8, 1, 0],
      ['Le Seigneur des Anneaux', 'J.R.R. Tolkien', 1954, 'Fantasy', 5.0, 1, 1],
      ['Pride and Prejudice', 'Jane Austen', 1813, 'Romance', 4.2, 0, 0],
      ['The Hobbit', 'J.R.R. Tolkien', 1937, 'Fantasy', 4.7, 1, 1],
      ['Don Quichotte', 'Miguel de Cervantes', 1605, 'Aventure', 4.0, 0, 0],
      ['La Peste', 'Albert Camus', 1947, 'Roman', 4.3, 1, 0],
      ['Dracula', 'Bram Stoker', 1897, 'Horreur', 4.1, 0, 0],
      ['Frankenstein', 'Mary Shelley', 1818, 'Science-fiction', 4.0, 1, 0],
      ['Le Comte de Monte-Cristo', 'Alexandre Dumas', 1844, 'Aventure', 4.9, 1, 1],
      ['Jane Eyre', 'Charlotte Brontë', 1847, 'Romance', 4.1, 0, 0],
      ['The Alchemist', 'Paulo Coelho', 1988, 'Développement personnel', 3.9, 1, 0],
      ['Dune', 'Frank Herbert', 1965, 'Science-fiction', 4.9, 1, 1],
      ['Sherlock Holmes', 'Arthur Conan Doyle', 1892, 'Policier', 4.5, 1, 0],
      ['The Da Vinci Code', 'Dan Brown', 2003, 'Thriller', 4.0, 0, 0],
      ['Percy Jackson', 'Rick Riordan', 2005, 'Fantasy', 4.4, 1, 0],
      ['Twilight', 'Stephenie Meyer', 2005, 'Romance', 3.5, 0, 0],
      ['The Hunger Games', 'Suzanne Collins', 2008, 'Science-fiction', 4.6, 1, 1],
      ['The Chronicles of Narnia', 'C.S. Lewis', 1950, 'Fantasy', 4.3, 0, 0],
      ['Moby Dick', 'Herman Melville', 1851, 'Aventure', 3.8, 0, 0],
      ['War and Peace', 'Léon Tolstoï', 1869, 'Historique', 4.7, 1, 0],
    ];

    for (final livre in livres) {
      await db.insert('livres', {
        'titre': livre[0],
        'auteur': livre[1],
        'annee': livre[2],
        'genre': livre[3],
        'note': livre[4],
        'lu': livre[5],
        'favori': livre[6],
        'dateAjout': now,
        'dateModification': null,
      });
    }
  }

  Future<int> insertLivre(Livre livre) async {
    final db = await instance.database;
    return await db.insert('livres', livre.toMap());
  }

  Future<List<Livre>> getLivres() async {
    final db = await instance.database;
    final result = await db.query('livres', orderBy: 'titre ASC');
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

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}