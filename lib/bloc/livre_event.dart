import '../models/livre.dart';

abstract class LivreEvent {}

class LoadLivres extends LivreEvent {}

class AddLivre extends LivreEvent {
  final Livre livre;

  AddLivre(this.livre);
}

class UpdateLivre extends LivreEvent {
  final Livre livre;

  UpdateLivre(this.livre);
}

class DeleteLivre extends LivreEvent {
  final int id;

  DeleteLivre(this.id);
}