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

  final livres = [
    {
      'titre': 'Le Petit Prince',
      'auteur': 'Antoine de Saint-Exupéry',
      'annee': 1943,
      'genre': 'Conte',
      'note': 5.0,
      'lu': 1,
    },
    {
      'titre': '1984',
      'auteur': 'George Orwell',
      'annee': 1949,
      'genre': 'Science-fiction',
      'note': 5.0,
      'lu': 1,
    },
    {
      'titre': 'Harry Potter à l’école des sorciers',
      'auteur': 'J.K. Rowling',
      'annee': 1997,
      'genre': 'Fantasy',
      'note': 4.5,
      'lu': 1,
    },
    {
      'titre': 'L’Étranger',
      'auteur': 'Albert Camus',
      'annee': 1942,
      'genre': 'Roman',
      'note': 4.0,
      'lu': 1,
    },
    {
      'titre': 'Les Misérables',
      'auteur': 'Victor Hugo',
      'annee': 1862,
      'genre': 'Classique',
      'note': 5.0,
      'lu': 0,
    },
    {
      'titre': 'Crime et Châtiment',
      'auteur': 'Fiodor Dostoïevski',
      'annee': 1866,
      'genre': 'Philosophique',
      'note': 4.8,
      'lu': 1,
    },
    {
      'titre': 'Le Seigneur des Anneaux',
      'auteur': 'J.R.R. Tolkien',
      'annee': 1954,
      'genre': 'Fantasy',
      'note': 5.0,
      'lu': 1,
    },
    {
      'titre': 'Pride and Prejudice',
      'auteur': 'Jane Austen',
      'annee': 1813,
      'genre': 'Romance',
      'note': 4.2,
      'lu': 0,
    },
    {
      'titre': 'The Hobbit',
      'auteur': 'J.R.R. Tolkien',
      'annee': 1937,
      'genre': 'Fantasy',
      'note': 4.7,
      'lu': 1,
    },
    {
      'titre': 'Don Quichotte',
      'auteur': 'Miguel de Cervantes',
      'annee': 1605,
      'genre': 'Aventure',
      'note': 4.0,
      'lu': 0,
    },
    {
      'titre': 'La Peste',
      'auteur': 'Albert Camus',
      'annee': 1947,
      'genre': 'Roman',
      'note': 4.3,
      'lu': 1,
    },
    {
      'titre': 'Dracula',
      'auteur': 'Bram Stoker',
      'annee': 1897,
      'genre': 'Horreur',
      'note': 4.1,
      'lu': 0,
    },
    {
      'titre': 'Frankenstein',
      'auteur': 'Mary Shelley',
      'annee': 1818,
      'genre': 'Science-fiction',
      'note': 4.0,
      'lu': 1,
    },
    {
      'titre': 'Le Comte de Monte-Cristo',
      'auteur': 'Alexandre Dumas',
      'annee': 1844,
      'genre': 'Aventure',
      'note': 4.9,
      'lu': 1,
    },
    {
      'titre': 'Jane Eyre',
      'auteur': 'Charlotte Brontë',
      'annee': 1847,
      'genre': 'Romance',
      'note': 4.1,
      'lu': 0,
    },
    {
      'titre': 'The Alchemist',
      'auteur': 'Paulo Coelho',
      'annee': 1988,
      'genre': 'Développement personnel',
      'note': 3.9,
      'lu': 1,
    },
    {
      'titre': 'Dune',
      'auteur': 'Frank Herbert',
      'annee': 1965,
      'genre': 'Science-fiction',
      'note': 4.9,
      'lu': 1,
    },
    {
      'titre': 'Sherlock Holmes',
      'auteur': 'Arthur Conan Doyle',
      'annee': 1892,
      'genre': 'Policier',
      'note': 4.5,
      'lu': 1,
    },
    {
      'titre': 'The Da Vinci Code',
      'auteur': 'Dan Brown',
      'annee': 2003,
      'genre': 'Thriller',
      'note': 4.0,
      'lu': 0,
    },
    {
      'titre': 'Percy Jackson',
      'auteur': 'Rick Riordan',
      'annee': 2005,
      'genre': 'Fantasy',
      'note': 4.4,
      'lu': 1,
    },
    {
      'titre': 'Twilight',
      'auteur': 'Stephenie Meyer',
      'annee': 2005,
      'genre': 'Romance',
      'note': 3.5,
      'lu': 0,
    },
    {
      'titre': 'The Hunger Games',
      'auteur': 'Suzanne Collins',
      'annee': 2008,
      'genre': 'Science-fiction',
      'note': 4.6,
      'lu': 1,
    },
    {
      'titre': 'The Chronicles of Narnia',
      'auteur': 'C.S. Lewis',
      'annee': 1950,
      'genre': 'Fantasy',
      'note': 4.3,
      'lu': 0,
    },
    {
      'titre': 'Moby Dick',
      'auteur': 'Herman Melville',
      'annee': 1851,
      'genre': 'Aventure',
      'note': 3.8,
      'lu': 0,
    },
    {
      'titre': 'War and Peace',
      'auteur': 'Léon Tolstoï',
      'annee': 1869,
      'genre': 'Historique',
      'note': 4.7,
      'lu': 1,
    },
  ];

  for (final livre in livres) {
    await db.insert('livres', livre);
  }
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