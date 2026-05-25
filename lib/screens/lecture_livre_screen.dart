import 'package:flutter/material.dart';

import '../models/livre.dart';

class LectureLivreScreen extends StatelessWidget {
  final Livre livre;

  const LectureLivreScreen({
    super.key,
    required this.livre,
  });

  static const Color primaryColor = Color(0xFF1E1E2E);
  static const Color backgroundColor = Color(0xFFF8F5F2);

  @override
  Widget build(BuildContext context) {
    final contenu = livre.contenu?.trim();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Espace de lecture'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              livre.titre,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              livre.auteur,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                contenu == null || contenu.isEmpty
                    ? 'Aucun contenu disponible pour ce livre.'
                    : contenu,
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  height: 1.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}