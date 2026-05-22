import 'package:flutter_bloc/flutter_bloc.dart';


import '../repositories/livre_repository.dart';

import 'livre_event.dart';
import 'livre_state.dart';

class LivreBloc extends Bloc<LivreEvent, LivreState> {
  final LivreRepository repository;

  LivreBloc(this.repository) : super(LivreInitial()) {

    on<LoadLivres>((event, emit) async {
      emit(LivreLoading());

      try {
        final livres = await repository.getAllLivres();

        emit(LivreLoaded(livres));
      } catch (e) {
        emit(LivreError("Erreur lors du chargement"));
      }
    });

    on<AddLivre>((event, emit) async {
      try {
        await repository.addLivre(event.livre);

        final livres = await repository.getAllLivres();

        emit(LivreLoaded(livres));
      } catch (e) {
        emit(LivreError("Erreur lors de l'ajout"));
      }
    });

    on<UpdateLivre>((event, emit) async {
      try {
        await repository.updateLivre(event.livre);

        final livres = await repository.getAllLivres();

        emit(LivreLoaded(livres));
      } catch (e) {
        emit(LivreError("Erreur lors de la modification"));
      }
    });

    on<DeleteLivre>((event, emit) async {
      try {
        await repository.deleteLivre(event.id);

        final livres = await repository.getAllLivres();

        emit(LivreLoaded(livres));
      } catch (e) {
        emit(LivreError("Erreur lors de la suppression"));
      }
    });

  }
}