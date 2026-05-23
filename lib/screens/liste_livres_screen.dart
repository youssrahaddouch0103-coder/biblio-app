import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_state.dart';
import 'ajouter_livre_screen.dart';
import 'detail_livre_screen.dart';
import 'statistiques_screen.dart';

class ListeLivresScreen extends StatefulWidget {
  const ListeLivresScreen({super.key});

  @override
  State<ListeLivresScreen> createState() => _ListeLivresScreenState();
}

class _ListeLivresScreenState extends State<ListeLivresScreen> {
  String searchQuery = '';
  String selectedGenre = 'Tous';
  String selectedSort = 'Titre';

  bool favorisOnly = false;
  bool lusOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BiblioApp'),
        actions: [
          IconButton(
            tooltip: 'Statistiques',
            icon: const Icon(Icons.insights_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatistiquesScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
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
            final favoris = state.livres.where((livre) => livre.favori).length;

            final genres = state.livres
                .where((livre) => livre.genre != null && livre.genre!.isNotEmpty)
                .map((livre) => livre.genre!)
                .toSet()
                .toList()
              ..sort();

            final filteredLivres = state.livres.where((livre) {
              final query = searchQuery.toLowerCase();

              final matchSearch =
                  livre.titre.toLowerCase().contains(query) ||
                  livre.auteur.toLowerCase().contains(query);

              final matchGenre =
                  selectedGenre == 'Tous' || livre.genre == selectedGenre;

              final matchFavori = !favorisOnly || livre.favori;
              final matchLu = !lusOnly || livre.lu;

              return matchSearch && matchGenre && matchFavori && matchLu;
            }).toList();

            if (selectedSort == 'Titre') {
              filteredLivres.sort((a, b) => a.titre.compareTo(b.titre));
            } else if (selectedSort == 'Année') {
              filteredLivres.sort(
                (a, b) => (b.annee ?? 0).compareTo(a.annee ?? 0),
              );
            } else if (selectedSort == 'Note') {
              filteredLivres.sort(
                (a, b) => (b.note ?? 0).compareTo(a.note ?? 0),
              );
            }

            return Column(
              children: [
                _HeaderSection(
                  totalLivres: totalLivres,
                  livresLus: livresLus,
                  favoris: favoris,
                ),
                _SearchAndFilterSection(
                  selectedGenre: selectedGenre,
                  genres: genres,
                  onSearchChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  onGenreChanged: (value) {
                    setState(() {
                      selectedGenre = value ?? 'Tous';
                    });
                  },
                ),
                _AdvancedFilterSection(
                  selectedSort: selectedSort,
                  favorisOnly: favorisOnly,
                  lusOnly: lusOnly,
                  onSortChanged: (value) {
                    setState(() {
                      selectedSort = value ?? 'Titre';
                    });
                  },
                  onFavorisChanged: (value) {
                    setState(() {
                      favorisOnly = value;
                    });
                  },
                  onLusChanged: (value) {
                    setState(() {
                      lusOnly = value;
                    });
                  },
                ),
                Expanded(
                  child: filteredLivres.isEmpty
                      ? const _EmptyBooksState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                          itemCount: filteredLivres.length,
                          itemBuilder: (context, index) {
                            final livre = filteredLivres[index];

                            return _BookModernCard(
                              titre: livre.titre,
                              auteur: livre.auteur,
                              genre: livre.genre ?? 'Non classé',
                              annee: livre.annee?.toString() ?? '—',
                              note: livre.note?.toStringAsFixed(1) ?? '0.0',
                              lu: livre.lu,
                              favori: livre.favori,
                              heroTag: 'livre_${livre.titre}',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailLivreScreen(livre: livre),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const Center(child: Text('Chargement...'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        label: const Text('Ajouter'),
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

class _HeaderSection extends StatelessWidget {
  final int totalLivres;
  final int livresLus;
  final int favoris;

  const _HeaderSection({
    required this.totalLivres,
    required this.livresLus,
    required this.favoris,
  });

  static const Color primaryColor = Color(0xFF25316D);
  static const Color accentColor = Color(0xFFFFB84C);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            primaryColor,
            Color(0xFF3949AB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.local_library_rounded,
                color: accentColor,
                size: 34,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ma bibliothèque personnelle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Organise tes lectures, favoris et statistiques.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _MiniStat(
                label: 'Livres',
                value: totalLivres.toString(),
                icon: Icons.menu_book_rounded,
              ),
              _MiniStat(
                label: 'Lus',
                value: livresLus.toString(),
                icon: Icons.check_circle_rounded,
              ),
              _MiniStat(
                label: 'Favoris',
                value: favoris.toString(),
                icon: Icons.favorite_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  static const Color accentColor = Color(0xFFFFB84C);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: accentColor, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.78),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchAndFilterSection extends StatelessWidget {
  final String selectedGenre;
  final List<String> genres;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onGenreChanged;

  const _SearchAndFilterSection({
    required this.selectedGenre,
    required this.genres,
    required this.onSearchChanged,
    required this.onGenreChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          TextField(
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              hintText: 'Rechercher par titre ou auteur...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: selectedGenre,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.tune_rounded),
              labelText: 'Filtrer par genre',
            ),
            items: [
              const DropdownMenuItem(
                value: 'Tous',
                child: Text('Tous les genres'),
              ),
              ...genres.map(
                (genre) => DropdownMenuItem(
                  value: genre,
                  child: Text(genre),
                ),
              ),
            ],
            onChanged: onGenreChanged,
          ),
        ],
      ),
    );
  }
}

class _AdvancedFilterSection extends StatelessWidget {
  final String selectedSort;
  final bool favorisOnly;
  final bool lusOnly;
  final ValueChanged<String?> onSortChanged;
  final ValueChanged<bool> onFavorisChanged;
  final ValueChanged<bool> onLusChanged;

  const _AdvancedFilterSection({
    required this.selectedSort,
    required this.favorisOnly,
    required this.lusOnly,
    required this.onSortChanged,
    required this.onFavorisChanged,
    required this.onLusChanged,
  });

  static const Color primaryColor = Color(0xFF25316D);
  static const Color accentColor = Color(0xFFFFB84C);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: selectedSort,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.sort_rounded),
              labelText: 'Trier par',
            ),
            items: const [
              DropdownMenuItem(
                value: 'Titre',
                child: Text('Titre'),
              ),
              DropdownMenuItem(
                value: 'Année',
                child: Text('Année récente'),
              ),
              DropdownMenuItem(
                value: 'Note',
                child: Text('Meilleure note'),
              ),
            ],
            onChanged: onSortChanged,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilterChip(
                  selected: favorisOnly,
                  label: const Text('Favoris'),
                  avatar: Icon(
                    Icons.favorite_rounded,
                    color: favorisOnly ? Colors.white : Colors.redAccent,
                    size: 18,
                  ),
                  selectedColor: primaryColor,
                  checkmarkColor: Colors.white,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: favorisOnly ? Colors.white : primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: onFavorisChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilterChip(
                  selected: lusOnly,
                  label: const Text('Livres lus'),
                  avatar: Icon(
                    Icons.check_circle_rounded,
                    color: lusOnly ? Colors.white : Colors.green,
                    size: 18,
                  ),
                  selectedColor: accentColor,
                  checkmarkColor: primaryColor,
                  backgroundColor: Colors.white,
                  labelStyle: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: onLusChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookModernCard extends StatelessWidget {
  final String titre;
  final String auteur;
  final String genre;
  final String annee;
  final String note;
  final bool lu;
  final bool favori;
  final String heroTag;
  final VoidCallback onTap;

  const _BookModernCard({
    required this.titre,
    required this.auteur,
    required this.genre,
    required this.annee,
    required this.note,
    required this.lu,
    required this.favori,
    required this.heroTag,
    required this.onTap,
  });

  static const Color primaryColor = Color(0xFF25316D);
  static const Color softPurple = Color(0xFFEDE9FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: heroTag,
                  child: _BookCoverLetter(
                    title: titre,
                    favori: favori,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titre,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        auteur,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _Badge(
                            icon: Icons.category_rounded,
                            label: genre,
                            color: softPurple,
                          ),
                          _Badge(
                            icon: Icons.calendar_month_rounded,
                            label: annee,
                            color: const Color(0xFFFFF1D6),
                          ),
                          _Badge(
                            icon: Icons.star_rounded,
                            label: '$note / 5',
                            color: const Color(0xFFFFF8D6),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Icon(
                      lu
                          ? Icons.task_alt_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: lu ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    if (favori)
                      const Icon(
                        Icons.favorite_rounded,
                        color: Colors.redAccent,
                        size: 22,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookCoverLetter extends StatelessWidget {
  final String title;
  final bool favori;

  const _BookCoverLetter({
    required this.title,
    required this.favori,
  });

  static const Color primaryColor = Color(0xFF25316D);
  static const Color accentColor = Color(0xFFFFB84C);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 58,
        height: 82,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              primaryColor,
              Color(0xFF5A61C9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                title.isNotEmpty ? title[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (favori)
              const Positioned(
                top: 6,
                right: 6,
                child: Icon(
                  Icons.favorite_rounded,
                  color: accentColor,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
  });

  static const Color primaryColor = Color(0xFF25316D);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: primaryColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBooksState extends StatelessWidget {
  const _EmptyBooksState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_rounded,
              size: 82,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun livre trouvé',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF25316D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Essaie une autre recherche ou ajoute un nouveau livre.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}