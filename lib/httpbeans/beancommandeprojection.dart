class BeanCommandeProjection {
  final int iduser, nbrearticle, traites, demandeconfirme, demandeorigine, montant, emissions, livres;
  final String dates, heure;

  const BeanCommandeProjection({
    required this.iduser,
    required this.nbrearticle,
    required this.traites,
    required this.demandeconfirme,
    required this.demandeorigine,
    required this.montant,
    required this.emissions,
    required this.livres,
    required this.dates,
    required this.heure
  });

  factory BeanCommandeProjection.fromJson(Map<String, dynamic> json) {
    return BeanCommandeProjection(
      iduser: json['iduser'],
      nbrearticle: json['nbrearticle'],
      traites: json['traites'],
      demandeconfirme: json['demandeconfirme'],
      demandeorigine: json['demandeorigine'],
      montant: json['montant'],
      emissions: json['emissions'],
      livres: json['livres'],
      dates: json['dates'],
      heure: json['heure']
    );
  }

  /*Map<String, dynamic> toJson() {
    return {
      'idart': idart,
      'actif': actif,
      'total': total
    };
  }*/
}