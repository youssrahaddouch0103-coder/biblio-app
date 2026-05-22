import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/livre_bloc.dart';
import '../bloc/livre_event.dart';
import '../models/livre.dart';

class ModifierLivreScreen extends StatefulWidget {
  final Livre livre;

  const ModifierLivreScreen({super.key, required this.livre});

  @override
  State<ModifierLivreScreen> createState() => _ModifierLivreScreenState();
}

class _ModifierLivreScreenState extends State<ModifierLivreScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titreController;
  late TextEditingController _auteurController;
  late TextEditingController _anneeController;
  late TextEditingController _genreController;
  late TextEditingController _noteController;

  late bool _lu;

  @override
  void initState() {
    super.initState();

    _titreController = TextEditingController(text: widget.livre.titre);
    _auteurController = TextEditingController(text: widget.livre.auteur);
    _anneeController =
        TextEditingController(text: widget.livre.annee?.toString() ?? '');
    _genreController = TextEditingController(text: widget.livre.genre ?? '');
    _noteController =
        TextEditingController(text: widget.livre.note?.toString() ?? '');

    _lu = widget.livre.lu;
  }

  @override
  void dispose() {
    _titreController.dispose();
    _auteurController.dispose();
    _anneeController.dispose();
    _genreController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _modifierLivre() {
    if (_formKey.currentState!.validate()) {
      final livreModifie = Livre(
        id: widget.livre.id,
        titre: _titreController.text.trim(),
        auteur: _auteurController.text.trim(),
        annee: _anneeController.text.trim().isEmpty
            ? null
            : int.tryParse(_anneeController.text.trim()),
        genre: _genreController.text.trim().isEmpty
            ? null
            : _genreController.text.trim(),
        note: _noteController.text.trim().isEmpty
            ? null
            : double.tryParse(_noteController.text.trim()),
        lu: _lu,
      );

      context.read<LivreBloc>().add(UpdateLivre(livreModifie));

      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le livre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Le titre est obligatoire'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _auteurController,
                decoration: const InputDecoration(
                  labelText: 'Auteur',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? "L'auteur est obligatoire"
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _anneeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Année',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Note /5',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text('Livre lu'),
                value: _lu,
                onChanged: (value) {
                  setState(() {
                    _lu = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _modifierLivre,
                child: const Text('Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}