class BeanArticleDiscounted {
  final int idart;
  final int modepourcentage;
  final int reduction;
  final String libelle;
  final String lienweb;

  const BeanArticleDiscounted({
    required this.idart,
    required this.modepourcentage,
    required this.reduction,
    required this.libelle,
    required this.lienweb
  });

  factory BeanArticleDiscounted.fromJson(Map<String, dynamic> json) {
    return BeanArticleDiscounted(
        idart: json['idart'],
        modepourcentage: json['modepourcentage'],
        reduction: json['reduction'],
        libelle: json['libelle'],
        lienweb: json['lienweb']
    );
  }
}