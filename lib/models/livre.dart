class Livre {
  final int? id;
  final String titre;
  final String auteur;
  final int? annee;
  final String? genre;
  final double? note;
  final bool lu;
  final bool favori;
  final String? dateAjout;
  final String? dateModification;
  final String? contenu;

  Livre({
    this.id,
    required this.titre,
    required this.auteur,
    this.annee,
    this.genre,
    this.note,
    required this.lu,
    required this.favori,
    this.dateAjout,
    this.dateModification,
    this.contenu,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'auteur': auteur,
      'annee': annee,
      'genre': genre,
      'note': note,
      'lu': lu ? 1 : 0,
      'favori': favori ? 1 : 0,
      'dateAjout': dateAjout,
      'dateModification': dateModification,
      'contenu': contenu,
    };
  }

  factory Livre.fromMap(Map<String, dynamic> map) {
    return Livre(
      id: map['id'] as int?,
      titre: map['titre'] as String,
      auteur: map['auteur'] as String,
      annee: map['annee'] as int?,
      genre: map['genre'] as String?,
      note: map['note'] == null ? null : (map['note'] as num).toDouble(),
      lu: (map['lu'] as int? ?? 0) == 1,
      favori: (map['favori'] as int? ?? 0) == 1,
      dateAjout: map['dateAjout'] as String?,
      dateModification: map['dateModification'] as String?,
      contenu: map['contenu'] as String?,
    );
  }

  Livre copyWith({
    int? id,
    String? titre,
    String? auteur,
    int? annee,
    String? genre,
    double? note,
    bool? lu,
    bool? favori,
    String? dateAjout,
    String? dateModification,
    String? contenu,
  }) {
    return Livre(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      auteur: auteur ?? this.auteur,
      annee: annee ?? this.annee,
      genre: genre ?? this.genre,
      note: note ?? this.note,
      lu: lu ?? this.lu,
      favori: favori ?? this.favori,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModification: dateModification ?? this.dateModification,
      contenu: contenu ?? this.contenu,
    );
  }
}