import '../database/database_helper.dart';
import '../models/livre.dart';

class LivreRepository {
  final DatabaseHelper databaseHelper;

  LivreRepository({required this.databaseHelper});

  Future<List<Livre>> getAllLivres() async {
    return await databaseHelper.getLivres();
  }

  Future<Livre?> getLivreById(int id) async {
    return await databaseHelper.getLivreById(id);
  }

  Future<int> addLivre(Livre livre) async {
    return await databaseHelper.insertLivre(livre);
  }

  Future<int> updateLivre(Livre livre) async {
    return await databaseHelper.updateLivre(livre);
  }

  Future<int> deleteLivre(int id) async {
    return await databaseHelper.deleteLivre(id);
  }
}