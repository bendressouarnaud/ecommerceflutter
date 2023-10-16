import 'beanresumearticle.dart';

class Beansousproduitarticle{
  final String detail;
  final int iddet;
  final List<Beanresumearticle> liste;

  // M e t h o d s
  Beansousproduitarticle({required this.detail, required this.iddet, required this.liste});

  factory Beansousproduitarticle.fromJson(Map<String, dynamic> json) {
    return Beansousproduitarticle(
        detail: json['detail'],
        iddet: json['iddet'],
        liste: List<dynamic>.from(json['liste']).map((i) => Beanresumearticle.fromJson(i)).toList()
    );
  }
}