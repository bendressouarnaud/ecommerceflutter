class Imagesupplement {
  final int idims, idart;
  final String lienweb;

  const Imagesupplement({
    required this.idims,
    required this.idart,
    required this.lienweb,
  });

  factory Imagesupplement.fromJson(Map<String, dynamic> json) {
    return Imagesupplement(
      idims: json['idims'],
      idart: json['idart'],
      lienweb: json['lienweb'],
    );
  }
}