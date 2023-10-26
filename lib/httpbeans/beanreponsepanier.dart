class Beanreponsepanier {
  final String lienweb, libelle;
  final int idart;
  final int totalcomment, restant, prix, reduction;
  final double note;

  const Beanreponsepanier({
    required this.idart,
    required this.prix,
    required this.reduction,
    required this.totalcomment,
    required this.restant,
    required this.lienweb,
    required this.libelle,
    required this.note
  });

  factory Beanreponsepanier.fromJson(Map<String, dynamic> json) {
    return Beanreponsepanier(
        idart: json['idart'],
        prix: json['prix'],
        reduction: json['reduction'],
        totalcomment: json['totalcomment'],
        restant: json['restant'],
        lienweb: json['lienweb'],
        libelle: json['libelle'],
        note: json['note']
    );
  }
}