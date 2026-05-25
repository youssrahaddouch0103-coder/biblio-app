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
      version: 3,
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
        dateModification TEXT,
        contenu TEXT
      )
    ''');

    await _insertInitialData(db);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE livres ADD COLUMN favori INTEGER NOT NULL DEFAULT 0',
      );
      await db.execute('ALTER TABLE livres ADD COLUMN dateAjout TEXT');
      await db.execute('ALTER TABLE livres ADD COLUMN dateModification TEXT');
    }

    if (oldVersion < 3) {
      await db.execute('ALTER TABLE livres ADD COLUMN contenu TEXT');
    }
  }

  Future<void> _insertInitialData(Database db) async {
    final now = DateTime.now().toIso8601String();

    final livres = [
      [
        'Le Petit Prince',
        'Antoine de Saint-Exupéry',
        1943,
        'Conte',
        5.0,
        1,
        1,
        'Le Petit Prince raconte la rencontre entre un aviateur et un jeune prince venu d’une autre planète. Ce récit poétique parle d’amitié, de solitude, de curiosité et de la manière de voir le monde avec le cœur.'
      ],
      [
        '1984',
        'George Orwell',
        1949,
        'Science-fiction',
        5.0,
        1,
        1,
        '1984 présente une société contrôlée par un pouvoir totalitaire où la liberté individuelle disparaît. Le livre suit Winston Smith, qui commence à questionner le système dans lequel il vit.'
      ],
      [
        'Harry Potter à l’école des sorciers',
        'J.K. Rowling',
        1997,
        'Fantasy',
        4.5,
        1,
        1,
        'Harry découvre qu’il est sorcier et rejoint une école de magie. Il y trouve des amis, des mystères et les premières traces d’un passé qu’il ne connaissait pas.'
      ],
      [
        'L’Étranger',
        'Albert Camus',
        1942,
        'Roman',
        4.0,
        1,
        0,
        'L’Étranger suit Meursault, un homme détaché du monde qui l’entoure. Le roman explore l’absurde, la société et le jugement.'
      ],
      [
        'Les Misérables',
        'Victor Hugo',
        1862,
        'Classique',
        5.0,
        0,
        1,
        'Les Misérables raconte le parcours de Jean Valjean et montre la pauvreté, l’injustice, la rédemption et l’espoir dans la France du XIXe siècle.'
      ],
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
        'contenu': livre[7],
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