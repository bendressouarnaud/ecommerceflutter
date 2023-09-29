class Beanarticledetail {
  final int idart;
  final int iddet, prix, reduction, note, articlerestant;
  final String libelle;
  final String lienweb;

  const Beanarticledetail({
    required this.idart,
    required this.iddet,
    required this.prix,
    required this.reduction,
    required this.note,
    required this.articlerestant,
    required this.libelle,
    required this.lienweb
  });

  factory Beanarticledetail.fromJson(Map<String, dynamic> json) {
    return Beanarticledetail(
      idart: json['idart'],
      iddet: json['iddet'],
      prix: json['prix'],
      reduction: json['reduction'],
      note: json['note'],
      articlerestant: json['articlerestant'],
      libelle: json['libelle'],
      lienweb: json['lienweb']
    );
  }
}