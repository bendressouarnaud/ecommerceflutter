class Beanreponsepanier {
  final String lienweb, libelle;
  final int idart, modepourcentage, prixpromo;
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
    required this.modepourcentage,
    required this.prixpromo,
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
        modepourcentage: json['modepourcentage'],
        prixpromo: json['prixpromo'],
        note: json['note']
    );
  }
}