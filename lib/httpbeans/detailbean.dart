class Detail {
  final int idspr, iddet;
  final String libelle;
  final String lienweb;

  const Detail({
    required this.idspr,
    required this.iddet,
    required this.libelle,
    required this.lienweb,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
        idspr: json['idspr'],
        iddet: json['iddet'],
        libelle: json['libelle'],
        lienweb: json['lienweb'],
    );
  }
}