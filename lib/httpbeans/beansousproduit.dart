class Beansousproduit {
  final int idspr;
  final String libelle;
  final String lienweb;
  final String produit;

  const Beansousproduit({
    required this.idspr,
    required this.libelle,
    required this.lienweb,
    required this.produit,
  });

  factory Beansousproduit.fromJson(Map<String, dynamic> json) {
    return Beansousproduit(
        idspr: json['idspr'],
        libelle: json['libelle'],
        lienweb: json['lienweb'],
        produit: json['produit']
    );
  }
}