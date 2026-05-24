import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_event.dart';
import '../models/livre.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';

class ModifierLivreScreen extends StatefulWidget {
  final Livre livre;

  const ModifierLivreScreen({
    super.key,
    required this.livre,
  });

  @override
  State<ModifierLivreScreen> createState() => _ModifierLivreScreenState();
}

class _ModifierLivreScreenState extends State<ModifierLivreScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titreController;
  late TextEditingController _auteurController;
  late TextEditingController _anneeController;

  late String _genre;
  late double _note;
  late bool _lu;
  late bool _favori;

  static const Color primaryColor = Color(0xFF1E1E2E);
  static const Color secondaryColor = Color(0xFF2D3250);
  static const Color accentColor = Color(0xFFF6B17A);
  static const Color backgroundColor = Color(0xFFF8F5F2);

  final List<String> _genres = [
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
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.livre.titre);
    _auteurController = TextEditingController(text: widget.livre.auteur);
    _anneeController = TextEditingController(
      text: widget.livre.annee?.toString() ?? '',
    );

    _genre = _genres.contains(widget.livre.genre) ? widget.livre.genre! : 'Autre';
    _note = widget.livre.note ?? 3.0;
    _lu = widget.livre.lu;
    _favori = widget.livre.favori;
  }

  @override
  void dispose() {
    _titreController.dispose();
    _auteurController.dispose();
    _anneeController.dispose();
    super.dispose();
  }

  void _updateLivre() {
    if (_formKey.currentState!.validate()) {
      final updatedLivre = widget.livre.copyWith(
        id: widget.livre.id,
        titre: _titreController.text.trim(),
        auteur: _auteurController.text.trim(),
        annee: _anneeController.text.trim().isEmpty
            ? null
            : int.tryParse(_anneeController.text.trim()),
        genre: _genre,
        note: _note,
        lu: _lu,
        favori: _favori,
        dateModification: DateTime.now().toIso8601String(),
      );

      context.read<LivreBloc>().add(UpdateLivre(updatedLivre));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          content: const Text(
            'Modifications enregistrées',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStarRating() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min, // Contraint la ligne à prendre juste l'espace nécessaire
    children: List.generate(5, (index) {
      final starValue = index + 1.0;
      return GestureDetector(
        onTap: () {
          setState(() {
            _note = starValue;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2), // Contrôle parfait de l'espace entre les étoiles
          child: Icon(
            _note >= starValue ? Icons.star_rounded : Icons.star_border_rounded,
            color: accentColor,
            size: 38, // Légèrement ajusté à 38 pour garantir un confort total sur tous les écrans sans aucun overflow
          ),
        ),
      );
    }),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Modifier le livre'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildSectionTitle('Informations Générales'),
              _buildCard(
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _titreController,
                      label: 'Titre du livre',
                      icon: Icons.book_rounded,
                      validator: (value) =>
                          Validators.requiredField(value, 'Le titre'),
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      controller: _auteurController,
                      label: 'Auteur',
                      icon: Icons.person_rounded,
                      validator: (value) =>
                          Validators.requiredField(value, "L'auteur"),
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      controller: _anneeController,
                      label: 'Année de publication',
                      icon: Icons.calendar_today_rounded,
                      keyboardType: TextInputType.number,
                      validator: Validators.validateYear,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              _buildSectionTitle('Catégorie & Évaluation'),
              _buildCard(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _genre,
                      decoration: const InputDecoration(
                        labelText: 'Genre littéraire',
                        prefixIcon: Icon(Icons.category_rounded),
                      ),
                      items: _genres.map((genre) {
                        return DropdownMenuItem(
                          value: genre,
                          child: Text(genre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _genre = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Évaluation',
                      style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStarRating(),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              _buildSectionTitle('Statut'),
              _buildCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Marquer comme lu'),
                      subtitle: const Text('Marquer ce livre comme déjà lu'),
                      value: _lu,
                      secondary: const Icon(Icons.check_circle_rounded),
                      onChanged: (value) {
                        setState(() {
                          _lu = value;
                        });
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Ajouter aux favoris'),
                      subtitle: const Text('Afficher dans les livres favoris'),
                      value: _favori,
                      secondary: const Icon(Icons.favorite_rounded),
                      onChanged: (value) {
                        setState(() {
                          _favori = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: _updateLivre,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text(
                    'Enregistrer les modifications',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}