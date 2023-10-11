class Commune{
  final int idcom;
  final String libelle;

  // M e t h o d s
  Commune({required this.idcom, required this.libelle});

  String get leLibelle {
    return libelle;
  }

  int get leIdcom {
    return idcom;
  }

  factory Commune.fromJson(Map<String, dynamic> json) {
    return Commune(
        idcom: json['idcom'],
        libelle: json['libelle']
    );
  }
}