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
  State<ModifierLivreScreen> createState() =>
      _ModifierLivreScreenState();
}

class _ModifierLivreScreenState
    extends State<ModifierLivreScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titreController;
  late TextEditingController _auteurController;
  late TextEditingController _anneeController;

  late String _genre;
  late double _note;
  late bool _lu;
  late bool _favori;

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

    _titreController =
        TextEditingController(text: widget.livre.titre);

    _auteurController =
        TextEditingController(text: widget.livre.auteur);

    _anneeController = TextEditingController(
      text: widget.livre.annee?.toString() ?? '',
    );

    _genre = widget.livre.genre ?? 'Roman';
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
        titre: _titreController.text.trim(),
        auteur: _auteurController.text.trim(),
        annee: _anneeController.text.trim().isEmpty
            ? null
            : int.parse(_anneeController.text.trim()),
        genre: _genre,
        note: _note,
        lu: _lu,
        favori: _favori,
        dateModification:
            DateTime.now().toIso8601String(),
      );

      context
          .read<LivreBloc>()
          .add(UpdateLivre(updatedLivre));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Livre modifié avec succès'),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le livre'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _titreController,
                label: 'Titre',
                icon: Icons.book,
                validator: (value) =>
                    Validators.requiredField(
                        value, 'Le titre'),
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _auteurController,
                label: 'Auteur',
                icon: Icons.person,
                validator: (value) =>
                    Validators.requiredField(
                        value, 'L’auteur'),
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _anneeController,
                label: 'Année',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: Validators.validateYear,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue:
                    _genres.contains(_genre)
                        ? _genre
                        : 'Autre',
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: _genres.map((genre) {
                  return DropdownMenuItem(
                    value: genre,
                    child: Text(genre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _genre = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              Text(
                'Note : ${_note.toStringAsFixed(1)} / 5',
              ),

              Slider(
                value: _note,
                min: 0,
                max: 5,
                divisions: 10,
                label: _note.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _note = value;
                  });
                },
              ),

              SwitchListTile(
                title: const Text('Livre lu'),
                value: _lu,
                onChanged: (value) {
                  setState(() {
                    _lu = value;
                  });
                },
              ),

              SwitchListTile(
                title: const Text('Favori'),
                value: _favori,
                onChanged: (value) {
                  setState(() {
                    _favori = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _updateLivre,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Enregistrer les modifications',
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