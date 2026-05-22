import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_state.dart';
import 'ajouter_livre_screen.dart';

class ListeLivresScreen extends StatelessWidget {
  const ListeLivresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BiblioApp'),
        centerTitle: true,
      ),
      body: BlocBuilder<LivreBloc, LivreState>(
        builder: (context, state) {
          // Chargement
          if (state is LivreLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Erreur
          if (state is LivreError) {
            return Center(
              child: Text(state.message),
            );
          }

          // Données chargées
          if (state is LivreLoaded) {
            // Aucun livre
            if (state.livres.isEmpty) {
              return const Center(
                child: Text(
                  'Aucun livre pour le moment.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            // Liste des livres
            return ListView.builder(
              itemCount: state.livres.length,
              itemBuilder: (context, index) {
                final livre = state.livres[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        livre.titre[0].toUpperCase(),
                      ),
                    ),
                    title: Text(
                      livre.titre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Auteur : ${livre.auteur}'),
                        if (livre.genre != null)
                          Text('Genre : ${livre.genre}'),
                        if (livre.annee != null)
                          Text('Année : ${livre.annee}'),
                      ],
                    ),
                    trailing: Icon(
                      livre.lu
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: livre.lu ? Colors.green : Colors.grey,
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text('Chargement...'),
          );
        },
      ),

      // Bouton ajouter
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AjouterLivreScreen(),
            ),
          );
        },
      ),
    );
  }
}