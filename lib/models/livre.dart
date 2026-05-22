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

  Livre({
    this.id,
    required this.titre,
    required this.auteur,
    this.annee,
    this.genre,
    this.note,
    this.lu = false,
    this.favori = false,
    this.dateAjout,
    this.dateModification,
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
    };
  }

  factory Livre.fromMap(Map<String, dynamic> map) {
    return Livre(
      id: map['id'],
      titre: map['titre'],
      auteur: map['auteur'],
      annee: map['annee'],
      genre: map['genre'],
      note: map['note']?.toDouble(),
      lu: map['lu'] == 1,
      favori: map['favori'] == 1,
      dateAjout: map['dateAjout'],
      dateModification: map['dateModification'],
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
    );
  }
}