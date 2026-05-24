import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_state.dart';

class StatistiquesScreen extends StatelessWidget {
  const StatistiquesScreen({super.key});

  static const Color primaryColor = Color(0xFF1E1E2E);
  static const Color secondaryColor = Color(0xFF2D3250);
  static const Color accentColor = Color(0xFFF6B17A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
      ),
      body: BlocBuilder<LivreBloc, LivreState>(
        builder: (context, state) {
          if (state is LivreLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LivreError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is LivreLoaded) {
            final totalLivres = state.livres.length;
            final livresLus = state.livres.where((livre) => livre.lu).length;
            final livresFavoris = state.livres.where((livre) => livre.favori).length;

            // Sécurisation complète du calcul de la moyenne
            final livresAvecNote = state.livres.where((livre) => livre.note != null).toList();
            final moyenneNotes = livresAvecNote.isEmpty
                ? 0.0
                : livresAvecNote.map((livre) => livre.note!).reduce((a, b) => a + b) /
                    livresAvecNote.length;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _StatCard(
                    title: 'Total Livres',
                    value: totalLivres.toString(),
                    icon: Icons.collections_bookmark_rounded,
                    color: primaryColor,
                  ),
                  _StatCard(
                    title: 'Livres Lus',
                    value: livresLus.toString(),
                    icon: Icons.check_circle_rounded,
                    color: Colors.green,
                  ),
                  _StatCard(
                    title: 'Favoris',
                    value: livresFavoris.toString(),
                    icon: Icons.favorite_rounded,
                    color: Colors.redAccent,
                  ),
                  _StatCard(
                    title: 'Note Moyenne',
                    value: '${moyenneNotes.toStringAsFixed(1)} / 5',
                    icon: Icons.star_rounded,
                    color: accentColor,
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Aucune donnée disponible'),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: StatistiquesScreen.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}