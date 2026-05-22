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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BiblioApp'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
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
      body: BlocBuilder<LivreBloc, LivreState>(
        builder: (context, state) {
          if (state is LivreLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LivreError) {
            return Center(child: Text(state.message));
          }

          if (state is LivreLoaded) {
            final genres = state.livres
                .where((livre) => livre.genre != null && livre.genre!.isNotEmpty)
                .map((livre) => livre.genre!)
                .toSet()
                .toList();

            final filteredLivres = state.livres.where((livre) {
              final matchSearch =
                  livre.titre.toLowerCase().contains(searchQuery.toLowerCase()) ||
                      livre.auteur.toLowerCase().contains(searchQuery.toLowerCase());

              final matchGenre =
                  selectedGenre == 'Tous' || livre.genre == selectedGenre;

              return matchSearch && matchGenre;
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher un livre...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedGenre,
                    decoration: const InputDecoration(
                      labelText: 'Filtrer par genre',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: 'Tous',
                        child: Text('Tous'),
                      ),
                      ...genres.map(
                        (genre) => DropdownMenuItem(
                          value: genre,
                          child: Text(genre),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedGenre = value ?? 'Tous';
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filteredLivres.isEmpty
                      ? const Center(
                          child: Text(
                            'Aucun livre trouvé.',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredLivres.length,
                          itemBuilder: (context, index) {
                            final livre = filteredLivres[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailLivreScreen(livre: livre),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  child: Text(livre.titre[0].toUpperCase()),
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
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${livre.note?.toStringAsFixed(1) ?? '0.0'} / 5',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      livre.lu
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: livre.lu
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    const SizedBox(height: 4),
                                    if (livre.favori)
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              ),
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