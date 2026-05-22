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

            final genres = state.livres
                .where((livre) => livre.genre != null && livre.genre!.isNotEmpty)
                .map((livre) => livre.genre!)
                .toSet()
                .length;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  _StatCard(
                    title: 'Total des livres',
                    value: totalLivres.toString(),
                    icon: Icons.menu_book,
                  ),
                  _StatCard(
                    title: 'Livres lus',
                    value: livresLus.toString(),
                    icon: Icons.check_circle,
                  ),
                  _StatCard(
                    title: 'Livres non lus',
                    value: livresNonLus.toString(),
                    icon: Icons.circle_outlined,
                  ),
                  _StatCard(
                    title: 'Genres différents',
                    value: genres.toString(),
                    icon: Icons.category,
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

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 32),
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