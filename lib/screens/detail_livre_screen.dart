import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_event.dart';
import '../models/livre.dart';
import 'modifier_livre_screen.dart';

class DetailLivreScreen extends StatelessWidget {
  final Livre livre;

  const DetailLivreScreen({super.key, required this.livre});

  void _confirmerSuppression(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer le livre'),
          content: Text('Voulez-vous supprimer "${livre.titre}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<LivreBloc>().add(DeleteLivre(livre.id!));

                Navigator.pop(dialogContext);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Livre supprimé avec succès'),
                  ),
                );
              },
              icon: const Icon(Icons.delete),
              label: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _ouvrirModification(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModifierLivreScreen(livre: livre),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    Color? iconColor,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final note = livre.note?.toStringAsFixed(1) ?? 'Non renseignée';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du livre'),
        actions: [
          IconButton(
            onPressed: () => _ouvrirModification(context),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _confirmerSuppression(context),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CircleAvatar(
                radius: 42,
                child: Text(
                  livre.titre[0].toUpperCase(),
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                livre.titre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                livre.auteur,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),

              _buildInfoTile(
                icon: Icons.person,
                title: 'Auteur',
                value: livre.auteur,
              ),
              _buildInfoTile(
                icon: Icons.calendar_today,
                title: 'Année',
                value: livre.annee?.toString() ?? 'Non renseignée',
              ),
              _buildInfoTile(
                icon: Icons.category,
                title: 'Genre',
                value: livre.genre ?? 'Non renseigné',
              ),
              _buildInfoTile(
                icon: Icons.star,
                iconColor: Colors.amber,
                title: 'Note',
                value: '$note / 5',
              ),
              _buildInfoTile(
                icon: livre.lu ? Icons.check_circle : Icons.circle_outlined,
                iconColor: livre.lu ? Colors.green : Colors.grey,
                title: 'Lu',
                value: livre.lu ? 'Oui' : 'Non',
              ),
              _buildInfoTile(
                icon: livre.favori ? Icons.favorite : Icons.favorite_border,
                iconColor: livre.favori ? Colors.red : Colors.grey,
                title: 'Favori',
                value: livre.favori ? 'Oui' : 'Non',
              ),
              if (livre.dateAjout != null)
                _buildInfoTile(
                  icon: Icons.access_time,
                  title: 'Date d’ajout',
                  value: livre.dateAjout!,
                ),
              if (livre.dateModification != null)
                _buildInfoTile(
                  icon: Icons.update,
                  title: 'Dernière modification',
                  value: livre.dateModification!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}