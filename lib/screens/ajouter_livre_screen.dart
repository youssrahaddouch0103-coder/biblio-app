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
  State<AjouterLivreScreen> createState() =>
      _AjouterLivreScreenState();
}

class _AjouterLivreScreenState
    extends State<AjouterLivreScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titreController =
      TextEditingController();

  final _auteurController =
      TextEditingController();

  final _anneeController =
      TextEditingController();

  String _genre = 'Roman';

  double _note = 3.0;

  bool _lu = false;
  bool _favori = false;

  static const Color primaryColor =
      Color(0xFF1E1E2E);

  static const Color secondaryColor =
      Color(0xFF2D3250);

  static const Color accentColor =
      Color(0xFFF6B17A);

  static const Color backgroundColor =
      Color(0xFFF8F5F2);

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

    super.dispose();
  }

  void _saveLivre() {
    if (_formKey.currentState!
        .validate()) {
      final livre = Livre(
        titre:
            _titreController.text.trim(),

        auteur:
            _auteurController.text.trim(),

        annee: _anneeController
                .text
                .trim()
                .isEmpty
            ? null
            : int.parse(
                _anneeController.text
                    .trim(),
              ),

        genre: _genre,

        note: _note,

        lu: _lu,

        favori: _favori,

        dateAjout: DateTime.now()
            .toIso8601String(),

        dateModification: null,
      );

      context
          .read<LivreBloc>()
          .add(AddLivre(livre));

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,

          backgroundColor:
              primaryColor,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),

          content: const Text(
            'Livre ajouté avec succès',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  Widget _buildSectionTitle(
      String title) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),

      child: Align(
        alignment:
            Alignment.centerLeft,

        child: Text(
          title,

          style: const TextStyle(
            color: primaryColor,

            fontSize: 18,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required Widget child,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          28,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.045,
            ),

            blurRadius: 18,

            offset: const Offset(
              0,
              10,
            ),
          ),
        ],
      ),

      child: child,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool>
        onChanged,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:
            const Color(0xFFF6F1EB),

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: accentColor
                  .withValues(
                alpha: 0.16,
              ),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: Icon(
              icon,
              color: primaryColor,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  title,

                  style:
                      const TextStyle(
                    color:
                        primaryColor,

                    fontWeight:
                        FontWeight
                            .bold,

                    fontSize: 15,
                  ),
                ),

                const SizedBox(
                    height: 3),

                Text(
                  subtitle,

                  style: TextStyle(
                    color:
                        Colors.grey[600],

                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,

            activeThumbColor:
                primaryColor,

            activeTrackColor:
                accentColor,

            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildGenreDropdown() {
    return DropdownButtonFormField<
        String>(
      initialValue: _genre,

      decoration:
          const InputDecoration(
        labelText: 'Genre',

        prefixIcon: Icon(
          Icons.category_rounded,
        ),
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
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        const Text(
          'Note du livre',

          style: TextStyle(
            color: primaryColor,

            fontWeight:
                FontWeight.bold,

            fontSize: 16,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 9,
              ),

              decoration: BoxDecoration(
                color: accentColor
                    .withValues(
                  alpha: 0.18,
                ),

                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),

              child: Text(
                '${_note.toStringAsFixed(1)} / 5',

                style:
                    const TextStyle(
                  color:
                      primaryColor,

                  fontWeight:
                      FontWeight.bold,

                  fontSize: 16,
                ),
              ),
            ),

            const Spacer(),

            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index <
                          _note.round()
                      ? Icons
                          .star_rounded
                      : Icons
                          .star_border_rounded,

                  color: accentColor,
                ),
              ),
            ),
          ],
        ),

        Slider(
          value: _note,

          min: 0,
          max: 5,

          divisions: 10,

          activeColor:
              primaryColor,

          inactiveColor:
              accentColor
                  .withValues(
            alpha: 0.28,
          ),

          label:
              _note.toStringAsFixed(
            1,
          ),

          onChanged: (value) {
            setState(() {
              _note = value;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Ajouter un livre',
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(
          16,
          10,
          16,
          30,
        ),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(
                  26,
                ),

                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      primaryColor,
                      secondaryColor,
                    ],

                    begin:
                        Alignment.topLeft,

                    end: Alignment
                        .bottomRight,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    34,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: 0.12,
                      ),

                      blurRadius: 24,

                      offset:
                          const Offset(
                        0,
                        12,
                      ),
                    ),
                  ],
                ),

                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Icon(
                      Icons
                          .library_add_rounded,

                      color: accentColor,
                      size: 44,
                    ),

                    SizedBox(height: 18),

                    Text(
                      'Ajouter un nouveau livre',

                      style: TextStyle(
                        color:
                            Colors.white,

                        fontSize: 27,

                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Construis ta bibliothèque personnelle avec une expérience moderne.',

                      style: TextStyle(
                        color:
                            Colors.white70,

                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              _buildSectionTitle(
                'Informations principales',
              ),

              _buildCard(
                child: Column(
                  children: [
                    CustomTextField(
                      controller:
                          _titreController,

                      label: 'Titre',

                      icon: Icons
                          .book_rounded,

                      validator: (
                        value,
                      ) =>
                          Validators
                              .requiredField(
                        value,
                        'Le titre',
                      ),
                    ),

                    const SizedBox(
                        height: 18),

                    CustomTextField(
                      controller:
                          _auteurController,

                      label: 'Auteur',

                      icon: Icons
                          .person_rounded,

                      validator: (
                        value,
                      ) =>
                          Validators
                              .requiredField(
                        value,
                        'L’auteur',
                      ),
                    ),

                    const SizedBox(
                        height: 18),

                    CustomTextField(
                      controller:
                          _anneeController,

                      label: 'Année',

                      icon: Icons
                          .calendar_today_rounded,

                      keyboardType:
                          TextInputType
                              .number,

                      validator:
                          Validators
                              .validateYear,
                    ),

                    const SizedBox(
                        height: 18),

                    _buildGenreDropdown(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle(
                'Évaluation',
              ),

              _buildCard(
                child:
                    _buildRatingSection(),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle(
                'Préférences',
              ),

              _buildCard(
                child: Column(
                  children: [
                    _buildSwitchTile(
                      title:
                          'Livre lu',

                      subtitle:
                          'Marquer ce livre comme déjà lu',

                      value: _lu,

                      icon: Icons
                          .check_circle_rounded,

                      onChanged:
                          (value) {
                        setState(() {
                          _lu = value;
                        });
                      },
                    ),

                    _buildSwitchTile(
                      title:
                          'Ajouter aux favoris',

                      subtitle:
                          'Afficher dans les favoris',

                      value: _favori,

                      icon: Icons
                          .favorite_rounded,

                      onChanged:
                          (value) {
                        setState(() {
                          _favori =
                              value;
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

                child:
                    ElevatedButton.icon(
                  onPressed:
                      _saveLivre,

                  icon: const Icon(
                    Icons.save_rounded,
                  ),

                  label: const Text(
                    'Enregistrer le livre',

                    style: TextStyle(
                      fontSize: 16,

                      fontWeight:
                          FontWeight
                              .bold,
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