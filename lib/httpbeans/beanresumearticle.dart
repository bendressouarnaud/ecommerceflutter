class Beanresumearticle {
  final int prix, idart;
  final String libelle;
  final String lienweb;

  const Beanresumearticle({
    required this.prix,
    required this.idart,
    required this.libelle,
    required this.lienweb
  });

  factory Beanresumearticle.fromJson(Map<String, dynamic> json) {
    return Beanresumearticle(
        prix: json['prix'],
        idart: json['idart'],
        libelle: json['libelle'],
        lienweb: json['lienweb']
    );
  }
}