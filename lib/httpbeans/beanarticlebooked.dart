class BeanArticleBooked {
  final int iduser,totaux;
  final String nom,prenom,dates,heure;

  const BeanArticleBooked({
    required this.iduser,
    required this.totaux,
    required this.nom,
    required this.prenom,
    required this.dates,
    required this.heure
  });

  factory BeanArticleBooked.fromJson(Map<String, dynamic> json) {
    return BeanArticleBooked(
        iduser: json['iduser'],
        totaux: json['totaux'],
        nom: json['nom'],
        prenom: json['prenom'],
        dates: json['dates'],
        heure: json['heure']
    );
  }
}