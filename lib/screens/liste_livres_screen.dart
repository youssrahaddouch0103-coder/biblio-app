import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_state.dart';

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
          if (state is LivreLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LivreError) {
            return Center(child: Text(state.message));
          }

          if (state is LivreLoaded) {
            if (state.livres.isEmpty) {
              return const Center(
                child: Text('Aucun livre pour le moment.'),
              );
            }

            return ListView.builder(
              itemCount: state.livres.length,
              itemBuilder: (context, index) {
                final livre = state.livres[index];

                return ListTile(
                  title: Text(livre.titre),
                  subtitle: Text(livre.auteur),
                  trailing: Icon(
                    livre.lu ? Icons.check_circle : Icons.circle_outlined,
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Chargement...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // On ajoutera la navigation vers AjouterLivreScreen après
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}