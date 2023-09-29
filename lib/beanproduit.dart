class Produit {
  final int idprd;
  final String libelle;
  final String lienweb;

  const Produit({
    required this.idprd,
    required this.libelle,
    required this.lienweb
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      idprd: json['idprd'],
      libelle: json['libelle'],
      lienweb: json['lienweb']
    );
  }
}