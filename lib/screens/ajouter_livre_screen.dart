import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_event.dart';
import '../models/livre.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';

class AjouterLivreScreen extends StatefulWidget {
  const AjouterLivreScreen({super.key});

  @override
  State<AjouterLivreScreen> createState() => _AjouterLivreScreenState();
}

class _AjouterLivreScreenState extends State<AjouterLivreScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titreController = TextEditingController();
  final _auteurController = TextEditingController();
  final _anneeController = TextEditingController();
  final _contenuController = TextEditingController();

  String _genre = 'Roman';
  double _note = 3.0;
  bool _lu = false;
  bool _favori = false;

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
  void dispose() {
    _titreController.dispose();
    _auteurController.dispose();
    _anneeController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  void _saveLivre() {
    if (_formKey.currentState!.validate()) {
      final livre = Livre(
        titre: _titreController.text.trim(),
        auteur: _auteurController.text.trim(),
        annee: _anneeController.text.trim().isEmpty
            ? null
            : int.tryParse(_anneeController.text.trim()),
        genre: _genre,
        note: _note,
        lu: _lu,
        favori: _favori,
        dateAjout: DateTime.now().toIso8601String(),
        dateModification: null,
        contenu: _contenuController.text.trim(),
      );

      context.read<LivreBloc>().add(AddLivre(livre));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: const Text(
            'Livre ajouté avec succès',
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
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStarRating() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final starValue = index + 1.0;

          return GestureDetector(
            onTap: () {
              setState(() {
                _note = starValue;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                _note >= starValue
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: accentColor,
                size: 36,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContenuField() {
    return TextFormField(
      controller: _contenuController,
      maxLines: 10,
      decoration: InputDecoration(
        labelText: 'Texte / résumé / chapitre',
        alignLabelWithHint: true,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 120),
          child: Icon(Icons.menu_book_rounded),
        ),
        filled: true,
        fillColor: const Color(0xFFF6F1EB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Ajouter un livre'),
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
                      initialValue: _genre,
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
                      subtitle: const Text('Ajouter aux livres lus'),
                      value: _lu,
                      secondary: const Icon(Icons.check_circle_rounded),
                      activeThumbColor: primaryColor,
                      activeTrackColor: accentColor,
                      onChanged: (value) {
                        setState(() {
                          _lu = value;
                        });
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Ajouter aux favoris'),
                      subtitle: const Text('Afficher dans les favoris'),
                      value: _favori,
                      secondary: const Icon(Icons.favorite_rounded),
                      activeThumbColor: primaryColor,
                      activeTrackColor: accentColor,
                      onChanged: (value) {
                        setState(() {
                          _favori = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              _buildSectionTitle('Contenu du livre'),
              _buildCard(
                child: _buildContenuField(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: _saveLivre,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text(
                    'Enregistrer le livre',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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