import 'beanresumearticle.dart';

class BeanArticleHistoCommande{
  final int totalarticle, totalprix;
  final List<Beanresumearticle> listearticle;

  // M e t h o d s
  BeanArticleHistoCommande({
    required this.totalarticle,
    required this.totalprix,
    required this.listearticle
  });

  factory BeanArticleHistoCommande.fromJson(Map<String, dynamic> json) {
    return BeanArticleHistoCommande(
      totalarticle: json['totalarticle'],
      totalprix: json['totalprix'],
      listearticle: List<dynamic>.from(json['listearticle']).map((i) => Beanresumearticle.fromJson(i)).toList()
    );
  }
}