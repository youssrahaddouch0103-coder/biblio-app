import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_event.dart';
import '../models/livre.dart';
import 'modifier_livre_screen.dart';

class DetailLivreScreen extends StatelessWidget {
  final Livre livre;

  const DetailLivreScreen({super.key, required this.livre});

  void _confirmerSuppression(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer le livre'),
          content: Text('Voulez-vous supprimer "${livre.titre}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<LivreBloc>().add(DeleteLivre(livre.id!));
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _ouvrirModification(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModifierLivreScreen(livre: livre),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du livre'),
        actions: [
          IconButton(
            onPressed: () => _ouvrirModification(context),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _confirmerSuppression(context),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                livre.titre,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text('Auteur : ${livre.auteur}'),
              Text('Année : ${livre.annee ?? "Non renseignée"}'),
              Text('Genre : ${livre.genre ?? "Non renseigné"}'),
              Text('Note : ${livre.note ?? "Non renseignée"} / 5'),
              Text('Lu : ${livre.lu ? "Oui" : "Non"}'),
            ],
          ),
        ),
      ),
    );
  }
}