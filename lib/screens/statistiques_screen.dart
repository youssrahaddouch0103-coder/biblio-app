import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_state.dart';

class StatistiquesScreen extends StatelessWidget {
  const StatistiquesScreen({super.key});

  static const Color primaryColor =
      Color(0xFF1E1E2E);

  static const Color secondaryColor =
      Color(0xFF2D3250);

  static const Color accentColor =
      Color(0xFFF6B17A);

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
              child:
                  CircularProgressIndicator(),
            );
          }

          if (state is LivreError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is LivreLoaded) {
            final totalLivres =
                state.livres.length;

            final livresLus = state.livres
                .where((livre) => livre.lu)
                .length;

            final livresFavoris =
                state.livres
                    .where(
                      (livre) =>
                          livre.favori,
                    )
                    .length;

            final moyenneNotes =
                state.livres
                        .where(
                          (livre) =>
                              livre.note !=
                              null,
                        )
                        .isEmpty
                    ? 0.0
                    : state.livres
                            .where(
                              (livre) =>
                                  livre.note !=
                                  null,
                            )
                            .map(
                              (livre) =>
                                  livre.note!,
                            )
                            .reduce(
                              (a, b) =>
                                  a + b,
                            ) /
                        state.livres
                            .where(
                              (livre) =>
                                  livre.note !=
                                  null,
                            )
                            .length;

            return SingleChildScrollView(
              padding:
                  const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Container(
                    width: double.infinity,

                    padding:
                        const EdgeInsets.all(
                            28),

                    decoration: BoxDecoration(
                      gradient:
                          const LinearGradient(
                        colors: [
                          primaryColor,
                          secondaryColor,
                        ],
                      ),

                      borderRadius:
                          BorderRadius.circular(
                              32),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(
                            alpha: 0.12,
                          ),

                          blurRadius: 24,

                          offset:
                              const Offset(
                            0,
                            12,
                          ),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons
                                  .insights_rounded,
                              color:
                                  accentColor,
                              size: 38,
                            ),

                            SizedBox(
                                width: 14),

                            Text(
                              'Dashboard',
                              style:
                                  TextStyle(
                                color: Colors
                                    .white,

                                fontSize: 30,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                            height: 14),

                        Text(
                          '$totalLivres livres enregistrés',
                          style: TextStyle(
                            color: Colors.white
                                .withValues(
                              alpha: 0.72,
                            ),

                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  GridView.count(
                    shrinkWrap: true,

                    physics:
                        const NeverScrollableScrollPhysics(),

                    crossAxisCount: 2,

                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,

                    childAspectRatio: 1.02,

                    children: [
                      _StatCard(
                        title: 'Livres',
                        value:
                            totalLivres
                                .toString(),
                        icon:
                            Icons.menu_book,
                        color:
                            accentColor,
                      ),

                      _StatCard(
                        title: 'Lus',
                        value:
                            livresLus
                                .toString(),
                        icon: Icons
                            .check_circle_rounded,
                        color: Colors.green,
                      ),

                      _StatCard(
                        title: 'Favoris',
                        value:
                            livresFavoris
                                .toString(),
                        icon: Icons
                            .favorite_rounded,
                        color: Colors.red,
                      ),

                      _StatCard(
                        title:
                            'Note moyenne',
                        value:
                            moyenneNotes
                                .toStringAsFixed(
                                    1),
                        icon: Icons
                            .star_rounded,
                        color:
                            Colors.orange,
                      ),
                    ],
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

  static const Color primaryColor =
      Color(0xFF1E1E2E);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.05,
            ),

            blurRadius: 16,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            width: 54,
            height: 54,

            decoration: BoxDecoration(
              color:
                  color.withValues(alpha: 0.14),

              borderRadius:
                  BorderRadius.circular(18),
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
              color: primaryColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}