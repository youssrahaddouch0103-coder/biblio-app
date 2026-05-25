import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_event.dart';
import '../models/livre.dart';
import 'lecture_livre_screen.dart';
import 'modifier_livre_screen.dart';

class DetailLivreScreen extends StatelessWidget {
  final Livre livre;

  const DetailLivreScreen({
    super.key,
    required this.livre,
  });

  static const Color primaryColor = Color(0xFF1E1E2E);
  static const Color secondaryColor = Color(0xFF2D3250);
  static const Color accentColor = Color(0xFFF6B17A);
  static const Color backgroundColor = Color(0xFFF8F5F2);

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '—';

    try {
      final dateTime = DateTime.parse(isoString);

      final jour = dateTime.day.toString().padLeft(2, '0');
      final mois = dateTime.month.toString().padLeft(2, '0');
      final annee = dateTime.year;

      final heure = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return '$jour/$mois/$annee à ${heure}h$minute';
    } catch (e) {
      return isoString;
    }
  }

  void _confirmerSuppression(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text('Supprimer le livre'),
          content: Text(
            'Voulez-vous supprimer "${livre.titre}" ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Annuler',
                style: TextStyle(color: primaryColor),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                context.read<LivreBloc>().add(
                      DeleteLivre(livre.id!),
                    );

                Navigator.pop(dialogContext);
                Navigator.pop(context);

                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    content: const Text(
                      'Livre supprimé avec succès',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.delete_rounded),
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
        builder: (context) => ModifierLivreScreen(
          livre: livre,
        ),
      ),
    );
  }

  void _ouvrirLecture(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LectureLivreScreen(
          livre: livre,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Color iconColor = primaryColor,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildResumeCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: accentColor,
              ),
              SizedBox(width: 10),
              Text(
                'Contenu du livre',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            livre.contenu == null || livre.contenu!.trim().isEmpty
                ? 'Aucun contenu disponible.'
                : livre.contenu!,
            style: const TextStyle(
              fontSize: 16,
              height: 1.7,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Détails du Livre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _confirmerSuppression(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoCard(
              icon: Icons.book_rounded,
              title: 'Titre',
              value: livre.titre,
            ),
            _buildInfoCard(
              icon: Icons.person_rounded,
              title: 'Auteur',
              value: livre.auteur,
            ),
            _buildInfoCard(
              icon: Icons.calendar_today_rounded,
              title: 'Année de publication',
              value: livre.annee?.toString() ?? '—',
            ),
            _buildInfoCard(
              icon: Icons.category_rounded,
              title: 'Genre',
              value: livre.genre ?? 'Non classé',
            ),
            _buildInfoCard(
              icon: Icons.star_rounded,
              title: 'Note',
              value: livre.note != null
                  ? '${livre.note!.toStringAsFixed(1)} / 5.0'
                  : 'Aucune note',
              iconColor: accentColor,
            ),
            _buildInfoCard(
              icon: livre.lu
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              title: 'Statut de lecture',
              value: livre.lu ? 'Livre lu' : 'Non lu',
              iconColor: livre.lu ? Colors.green : Colors.grey,
            ),
            _buildInfoCard(
              icon: livre.favori
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              title: 'Favori',
              value: livre.favori
                  ? 'Ajouté aux favoris'
                  : 'Non favori',
              iconColor:
                  livre.favori ? Colors.redAccent : Colors.grey,
            ),
            if (livre.dateAjout != null)
              _buildInfoCard(
                icon: Icons.access_time_rounded,
                title: 'Date d’ajout',
                value: _formatDate(livre.dateAjout),
              ),
            if (livre.dateModification != null)
              _buildInfoCard(
                icon: Icons.update_rounded,
                title: 'Dernière modification',
                value: _formatDate(livre.dateModification),
              ),
            _buildResumeCard(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: primaryColor,
                ),
                onPressed: () => _ouvrirLecture(context),
                icon: const Icon(Icons.chrome_reader_mode_rounded),
                label: const Text(
                  'Lire le livre',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                onPressed: () => _ouvrirModification(context),
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Modifier le livre'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}