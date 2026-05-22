import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_state.dart';

class StatistiquesScreen extends StatelessWidget {
  const StatistiquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
      ),
      body: BlocBuilder<LivreBloc, LivreState>(
        builder: (context, state) {
          if (state is LivreLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LivreError) {
            return Center(child: Text(state.message));
          }

          if (state is LivreLoaded) {
            final totalLivres = state.livres.length;
            final livresLus = state.livres.where((livre) => livre.lu).length;
            final livresNonLus = totalLivres - livresLus;
            final livresFavoris =
                state.livres.where((livre) => livre.favori).length;

            final genresList = state.livres
                .where((livre) => livre.genre != null && livre.genre!.isNotEmpty)
                .map((livre) => livre.genre!)
                .toList();

            final genresDifferents = genresList.toSet().length;

            final livresAvecNote =
                state.livres.where((livre) => livre.note != null).toList();

            final moyenneNotes = livresAvecNote.isEmpty
                ? 0.0
                : livresAvecNote
                        .map((livre) => livre.note!)
                        .reduce((a, b) => a + b) /
                    livresAvecNote.length;

            final Map<String, int> livresParGenre = {};

            for (final genre in genresList) {
              livresParGenre[genre] = (livresParGenre[genre] ?? 0) + 1;
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  _StatCard(
                    title: 'Total des livres',
                    value: totalLivres.toString(),
                    icon: Icons.menu_book,
                    iconColor: Colors.indigo,
                  ),
                  _StatCard(
                    title: 'Livres lus',
                    value: livresLus.toString(),
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                  ),
                  _StatCard(
                    title: 'Livres non lus',
                    value: livresNonLus.toString(),
                    icon: Icons.circle_outlined,
                    iconColor: Colors.grey,
                  ),
                  _StatCard(
                    title: 'Livres favoris',
                    value: livresFavoris.toString(),
                    icon: Icons.favorite,
                    iconColor: Colors.red,
                  ),
                  _StatCard(
                    title: 'Genres différents',
                    value: genresDifferents.toString(),
                    icon: Icons.category,
                    iconColor: Colors.deepPurple,
                  ),
                  _StatCard(
                    title: 'Moyenne des notes',
                    value: '${moyenneNotes.toStringAsFixed(1)} / 5',
                    icon: Icons.star,
                    iconColor: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Répartition par genre',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (livresParGenre.isEmpty)
                    const Card(
                      child: ListTile(
                        title: Text('Aucun genre disponible'),
                      ),
                    )
                  else
                    ...livresParGenre.entries.map(
                      (entry) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.label),
                          title: Text(entry.key),
                          trailing: Text(
                            entry.value.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          return const Center(child: Text('Chargement...'));
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          size: 32,
          color: iconColor,
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}