import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_state.dart';

class StatistiquesScreen extends StatelessWidget {
  const StatistiquesScreen({super.key});

  static const Color primaryColor = Color(0xFF25316D);
  static const Color accentColor = Color(0xFFFFB84C);

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

            final livresLus = state.livres
                .where((livre) => livre.lu)
                .length;

            final livresNonLus =
                totalLivres - livresLus;

            final livresFavoris = state.livres
                .where((livre) => livre.favori)
                .length;

            final genresList = state.livres
                .where((livre) =>
                    livre.genre != null &&
                    livre.genre!.isNotEmpty)
                .map((livre) => livre.genre!)
                .toList();

            final genresDifferents =
                genresList.toSet().length;

            final livresAvecNote = state.livres
                .where((livre) => livre.note != null)
                .toList();

            final moyenneNotes =
                livresAvecNote.isEmpty
                    ? 0.0
                    : livresAvecNote
                            .map((livre) => livre.note!)
                            .reduce((a, b) => a + b) /
                        livresAvecNote.length;

            final Map<String, int> livresParGenre =
                {};

            for (final genre in genresList) {
              livresParGenre[genre] =
                  (livresParGenre[genre] ?? 0) + 1;
            }

            return SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(
                      16, 12, 16, 30),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient:
                          const LinearGradient(
                        colors: [
                          primaryColor,
                          Color(0xFF3949AB),
                        ],
                        begin: Alignment.topLeft,
                        end:
                            Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor
                              .withValues(
                                  alpha: 0.18),
                          blurRadius: 18,
                          offset:
                              const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons
                                  .analytics_rounded,
                              color: accentColor,
                              size: 36,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Dashboard',
                              style: TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 28,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '$totalLivres livres enregistrés dans votre bibliothèque.',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  GridView.count(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.05,
                    children: [
                      _ModernStatCard(
                        title: 'Total',
                        value:
                            totalLivres.toString(),
                        icon:
                            Icons.menu_book_rounded,
                        color: Colors.indigo,
                      ),
                      _ModernStatCard(
                        title: 'Livres lus',
                        value:
                            livresLus.toString(),
                        icon: Icons
                            .check_circle_rounded,
                        color: Colors.green,
                      ),
                      _ModernStatCard(
                        title: 'Non lus',
                        value: livresNonLus
                            .toString(),
                        icon: Icons
                            .radio_button_unchecked_rounded,
                        color: Colors.grey,
                      ),
                      _ModernStatCard(
                        title: 'Favoris',
                        value:
                            livresFavoris
                                .toString(),
                        icon:
                            Icons.favorite_rounded,
                        color: Colors.red,
                      ),
                      _ModernStatCard(
                        title: 'Genres',
                        value:
                            genresDifferents
                                .toString(),
                        icon:
                            Icons.category_rounded,
                        color:
                            Colors.deepPurple,
                      ),
                      _ModernStatCard(
                        title: 'Note moyenne',
                        value:
                            '${moyenneNotes.toStringAsFixed(1)}',
                        icon:
                            Icons.star_rounded,
                        color: Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Répartition par genre',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  if (livresParGenre.isEmpty)
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(
                              24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                                24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(
                                    alpha: 0.04),
                            blurRadius: 14,
                            offset:
                                const Offset(
                                    0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Aucun genre disponible',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    ...livresParGenre.entries
                        .map(
                      (entry) =>
                          _GenreCard(
                        genre: entry.key,
                        count: entry.value,
                        total:
                            totalLivres == 0
                                ? 1
                                : totalLivres,
                      ),
                    ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Chargement...'),
          );
        },
      ),
    );
  }
}

class _ModernStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ModernStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF25316D),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _GenreCard extends StatelessWidget {
  final String genre;
  final int count;
  final int total;

  const _GenreCard({
    required this.genre,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = count / total;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.label_rounded,
                color: Color(0xFF25316D),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  genre,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                    color: Color(0xFF25316D),
                  ),
                ),
              ),
              Text(
                '$count livre(s)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 10,
              backgroundColor:
                  Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation(
                Color(0xFFFFB84C),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(percentage * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}