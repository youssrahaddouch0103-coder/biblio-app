import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_event.dart';
import '../models/livre.dart';
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

                context.read<LivreBloc>().add(DeleteLivre(livre.id!));

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
        builder: (context) => ModifierLivreScreen(livre: livre),
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Color? iconColor,
  }) {
    final currentColor = iconColor ?? primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: currentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: currentColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCover() {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 132,
        height: 184,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              primaryColor,
              secondaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                livre.titre.isNotEmpty ? livre.titre[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 58,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (livre.favori)
              const Positioned(
                top: 12,
                right: 12,
                child: Icon(
                  Icons.favorite_rounded,
                  color: accentColor,
                  size: 26,
                ),
              ),
            Positioned(
              bottom: 14,
              left: 18,
              right: 18,
              child: Container(
                height: 5,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final note = livre.note?.toStringAsFixed(1) ?? '0.0';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Détails du livre'),
        actions: [
          IconButton(
            tooltip: 'Modifier',
            onPressed: () => _ouvrirModification(context),
            icon: const Icon(Icons.edit_rounded),
          ),
          IconButton(
            tooltip: 'Supprimer',
            onPressed: () => _confirmerSuppression(context),
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    primaryColor,
                    secondaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Hero(
                    tag: 'livre_${livre.titre}',
                    child: _buildBookCover(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    livre.titre,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    livre.auteur,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildBadge(
                        icon: Icons.category_rounded,
                        label: livre.genre ?? 'Non classé',
                        color: accentColor,
                      ),
                      _buildBadge(
                        icon: Icons.star_rounded,
                        label: '$note / 5',
                        color: Colors.orange,
                      ),
                      _buildBadge(
                        icon: livre.lu
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        label: livre.lu ? 'Lu' : 'Non lu',
                        color: livre.lu ? Colors.green : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(
              icon: Icons.person_rounded,
              title: 'Auteur',
              value: livre.auteur,
            ),
            _buildInfoCard(
              icon: Icons.calendar_today_rounded,
              title: 'Année',
              value: livre.annee?.toString() ?? 'Non renseignée',
            ),
            _buildInfoCard(
              icon: Icons.category_rounded,
              title: 'Genre',
              value: livre.genre ?? 'Non renseigné',
            ),
            _buildInfoCard(
              icon: Icons.star_rounded,
              iconColor: Colors.orange,
              title: 'Note',
              value: '$note / 5',
            ),
            _buildInfoCard(
              icon: livre.lu
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              iconColor: livre.lu ? Colors.green : Colors.grey,
              title: 'Lecture',
              value: livre.lu ? 'Livre lu' : 'Non lu',
            ),
            _buildInfoCard(
              icon: livre.favori
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              iconColor: livre.favori ? Colors.redAccent : Colors.grey,
              title: 'Favori',
              value: livre.favori ? 'Ajouté aux favoris' : 'Non favori',
            ),
            if (livre.dateAjout != null)
              _buildInfoCard(
                icon: Icons.access_time_rounded,
                title: 'Date d’ajout',
                value: livre.dateAjout!,
              ),
            if (livre.dateModification != null)
              _buildInfoCard(
                icon: Icons.update_rounded,
                title: 'Dernière modification',
                value: livre.dateModification!,
              ),
            const SizedBox(height: 18),
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