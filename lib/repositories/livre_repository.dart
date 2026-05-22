import '../database/database_helper.dart';
import '../models/livre.dart';

class LivreRepository {
  final DatabaseHelper databaseHelper;

  LivreRepository({
    required this.databaseHelper,
  });

  Future<List<Livre>> getAllLivres() async {
    try {
      return await databaseHelper.getLivres();
    } catch (e) {
      throw Exception(
        'Erreur lors du chargement des livres',
      );
    }
  }

  Future<Livre?> getLivreById(int id) async {
    try {
      return await databaseHelper.getLivreById(id);
    } catch (e) {
      throw Exception(
        'Erreur lors du chargement du livre',
      );
    }
  }

  Future<int> addLivre(Livre livre) async {
    try {
      return await databaseHelper.insertLivre(livre);
    } catch (e) {
      throw Exception(
        'Erreur lors de l’ajout du livre',
      );
    }
  }

  Future<int> updateLivre(Livre livre) async {
    try {
      return await databaseHelper.updateLivre(livre);
    } catch (e) {
      throw Exception(
        'Erreur lors de la modification du livre',
      );
    }
  }

  Future<int> deleteLivre(int id) async {
    try {
      return await databaseHelper.deleteLivre(id);
    } catch (e) {
      throw Exception(
        'Erreur lors de la suppression du livre',
      );
    }
  }
}