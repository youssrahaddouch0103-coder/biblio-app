class Livre {
  final int? id;
  final String titre;
  final String auteur;
  final int annee;
  final String genre;
  final int note; // Correspond au nombre d'étoiles (1 à 5)
  final bool estLu;
  final String resume;

  Livre({
    this.id,
    required this.titre,
    required this.auteur,
    required this.annee,
    required this.genre,
    required this.note,
    required this.estLu,
    required this.resume,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'auteur': auteur,
      'annee': annee,
      'genre': genre,
      'note': note,
      'estLu': estLu ? 1 : 0, // SQLite stocke les booléens sous forme d'entiers
      'resume': resume,
    };
  }

  factory Livre.fromMap(Map<String, dynamic> map) {
    return Livre(
      id: map['id'] as int?,
      titre: map['titre'] as String,
      auteur: map['auteur'] as String,
      annee: map['annee'] as int,
      genre: map['genre'] as String,
      note: map['note'] as int,
      estLu: (map['estLu'] as int) == 1,
      resume: map['resume'] as String? ?? '',
    );
  }
}