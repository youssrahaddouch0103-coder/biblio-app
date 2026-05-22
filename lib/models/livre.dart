class Livre {
  final int? id;
  final String titre;
  final String auteur;
  final int? annee;
  final String? genre;
  final double? note;
  final bool lu;

  Livre({
    this.id,
    required this.titre,
    required this.auteur,
    this.annee,
    this.genre,
    this.note,
    this.lu = false,
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
    );
  }
}