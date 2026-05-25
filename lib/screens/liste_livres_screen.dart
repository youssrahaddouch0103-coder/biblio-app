import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_state.dart';
import '../models/livre.dart';
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

  static const Color backgroundColor = Color(0xFFF8F5F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
        ],
      ),
      body: Column(
        children: [
          const HeaderSection(),
          SearchAndFilterSection(
            searchQuery: searchQuery,
            selectedGenre: selectedGenre,
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
          AdvancedFilterSection(
            favorisOnly: favorisOnly,
            lusOnly: lusOnly,
            selectedSort: selectedSort,
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
            onSortChanged: (value) {
              setState(() {
                selectedSort = value ?? 'Titre';
              });
            },
          ),
          Expanded(
            child: BlocBuilder<LivreBloc, LivreState>(
              builder: (context, state) {
                if (state is LivreLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is LivreError) {
                  return Center(child: Text(state.message));
                }

                if (state is LivreLoaded) {
                  var filteredLivres = state.livres.where((livre) {
                    final query = searchQuery.toLowerCase();

                    final matchesSearch =
                        livre.titre.toLowerCase().contains(query) ||
                            livre.auteur.toLowerCase().contains(query);

                    final matchesGenre =
                        selectedGenre == 'Tous' || livre.genre == selectedGenre;

                    final matchesFavoris = !favorisOnly || livre.favori;
                    final matchesLus = !lusOnly || livre.lu;

                    return matchesSearch &&
                        matchesGenre &&
                        matchesFavoris &&
                        matchesLus;
                  }).toList();

                  if (selectedSort == 'Titre') {
                    filteredLivres.sort((a, b) => a.titre.compareTo(b.titre));
                  } else if (selectedSort == 'Auteur') {
                    filteredLivres.sort((a, b) => a.auteur.compareTo(b.auteur));
                  } else if (selectedSort == 'Note') {
                    filteredLivres.sort(
                      (a, b) => (b.note ?? 0).compareTo(a.note ?? 0),
                    );
                  } else if (selectedSort == 'Récents') {
                    filteredLivres.sort(
                      (a, b) =>
                          (b.dateAjout ?? '').compareTo(a.dateAjout ?? ''),
                    );
                  }

                  if (filteredLivres.isEmpty) {
                    return const EmptyBooksState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filteredLivres.length,
                    itemBuilder: (context, index) {
                      final livre = filteredLivres[index];
                      return BookModernCard(livre: livre);
                    },
                  );
                }

                return const EmptyBooksState();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AjouterLivreScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Ajouter un livre'),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  static const Color primaryColor = Color(0xFF1E1E2E);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LivreBloc, LivreState>(
      builder: (context, state) {
        int count = 0;

        if (state is LivreLoaded) {
          count = state.livres.length;
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ma Bibliothèque',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count > 1
                    ? '$count livres enregistrés'
                    : '$count livre enregistré',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SearchAndFilterSection extends StatelessWidget {
  final String searchQuery;
  final String selectedGenre;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onGenreChanged;

  const SearchAndFilterSection({
    super.key,
    required this.searchQuery,
    required this.selectedGenre,
    required this.onSearchChanged,
    required this.onGenreChanged,
  });

  final List<String> _genres = const [
    'Tous',
    'Roman',
    'Fantasy',
    'Science-fiction',
    'Classique',
    'Aventure',
    'Romance',
    'Policier',
    'Thriller',
    'Historique',
    'Développement personnel',
    'Autre',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Rechercher un livre...',
                prefixIcon: const Icon(Icons.search_rounded),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                filled: true,
                fillColor: const Color(0xFFF8F5F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5F2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedGenre,
                  isExpanded: true,
                  icon: const Icon(Icons.filter_list_rounded),
                  items: _genres.map((genre) {
                    return DropdownMenuItem(
                      value: genre,
                      child: Text(
                        genre,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: onGenreChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdvancedFilterSection extends StatelessWidget {
  final bool favorisOnly;
  final bool lusOnly;
  final String selectedSort;
  final ValueChanged<bool> onFavorisChanged;
  final ValueChanged<bool> onLusChanged;
  final ValueChanged<String?> onSortChanged;

  const AdvancedFilterSection({
    super.key,
    required this.favorisOnly,
    required this.lusOnly,
    required this.selectedSort,
    required this.onFavorisChanged,
    required this.onLusChanged,
    required this.onSortChanged,
  });

  static const Color primaryColor = Color(0xFF1E1E2E);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              FilterChip(
                label: const Text('Favoris'),
                selected: favorisOnly,
                onSelected: onFavorisChanged,
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Lus'),
                selected: lusOnly,
                onSelected: onLusChanged,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSort,
                icon: const Icon(Icons.swap_vert_rounded, size: 18),
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                items: const ['Titre', 'Auteur', 'Note', 'Récents'].map((sort) {
                  return DropdownMenuItem(
                    value: sort,
                    child: Text('Tri: $sort'),
                  );
                }).toList(),
                onChanged: onSortChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookModernCard extends StatelessWidget {
  final Livre livre;

  const BookModernCard({
    super.key,
    required this.livre,
  });

  static const Color primaryColor = Color(0xFF1E1E2E);
  static const Color accentColor = Color(0xFFF6B17A);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailLivreScreen(livre: livre),
              ),
            );
          },
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.bookmark_rounded,
              color: primaryColor,
            ),
          ),
          title: Text(
            livre.titre,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                livre.auteur,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (livre.note ?? 0.0)
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: accentColor,
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (livre.favori)
                const Icon(
                  Icons.favorite_rounded,
                  color: Colors.redAccent,
                  size: 22,
                ),
              if (livre.lu) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 22,
                ),
              ],
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyBooksState extends StatelessWidget {
  const EmptyBooksState({super.key});

  static const Color primaryColor = Color(0xFF1E1E2E);

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
              size: 86,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 18),
            const Text(
              'Aucun livre trouvé',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoute un nouveau livre ou modifie tes filtres.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}