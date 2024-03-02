class Beanarticledetailnew {
  final int idart;
  final int iddet, prix, reduction, note, articlerestant;
  final String libelle;
  final String lienweb;
  final int modepourcentage, prixpromo;

  const Beanarticledetailnew({
    required this.idart,
    required this.iddet,
    required this.prix,
    required this.reduction,
    required this.note,
    required this.articlerestant,
    required this.libelle,
    required this.modepourcentage,
    required this.prixpromo,
    required this.lienweb
  });

  factory Beanarticledetailnew.fromJson(Map<String, dynamic> json) {
    return Beanarticledetailnew(
        idart: json['idart'],
        iddet: json['iddet'],
        prix: json['prix'],
        reduction: json['reduction'],
        note: json['note'],
        articlerestant: json['articlerestant'],
        libelle: json['libelle'],
        modepourcentage: json['modepourcentage'],
        prixpromo: json['prixpromo'],
        lienweb: json['lienweb']
    );
  }
}